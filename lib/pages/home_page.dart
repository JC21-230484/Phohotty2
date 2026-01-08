import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import 'album_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AssetPathEntity>? _paths;
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoad();
  }

  Future<void> _requestPermissionAndLoad() async {
    final ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      setState(() {
        _error = "ストレージのアクセス許可が必要です";
        _isLoading = false;
      });
      return;
    }

    try {
      final paths = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(minWidth: 100, minHeight: 100),
          ),
          orders: [
            const OrderOption(type: OrderOptionType.createDate, asc: false),
          ],
        ),
      );
      if (mounted) {
        setState(() {
          _paths = paths;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('写真フォルダ一覧')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(fontSize: 16)));
    }
    if (_paths == null || _paths!.isEmpty) {
      return const Center(child: Text("アルバムが見つかりません"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _paths!.length,
      itemBuilder: (context, index) {
        final path = _paths![index];
        return _buildAlbumTile(path);
      },
    );
  }

  Widget _buildAlbumTile(AssetPathEntity path) {
    return FutureBuilder<List<AssetEntity>>(
      future: path.getAssetListPaged(page: 0, size: 1),
      builder: (context, snapshot) {
        Widget thumbnail = Container(width: 72, height: 72, color: Colors.grey[300]);

        if (snapshot.connectionState == ConnectionState.done && snapshot.data?.isNotEmpty == true) {
          thumbnail = _buildThumbnail(snapshot.data!.first);
        }

        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: thumbnail,
          ),
          title: Text(path.name),
          subtitle: FutureBuilder<int>(
            future: path.assetCountAsync,
            builder: (c, s) => Text(s.data != null ? "${s.data} 枚" : "読み込み中..."),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AlbumPage(path: path)),
            );
          },
        );
      },
    );
  }

  Widget _buildThumbnail(AssetEntity asset) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          return Image.memory(snapshot.data!, width: 72, height: 72, fit: BoxFit.cover);
        }
        return Container(width: 72, height: 72, color: Colors.grey[300]);
      },
    );
  }
}
