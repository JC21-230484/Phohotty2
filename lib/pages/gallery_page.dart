import 'dart:io';
import 'package:flutter/material.dart';
import '../services/local_storage.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final local = LocalStorageService();

    return Scaffold(
      appBar: AppBar(title: const Text("ギャラリー")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.label),
                label: const Text("画像にタグ付け"),
                onPressed: () => Navigator.pushNamed(context, "/tag-lens"),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: local.loadGallery(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("エラー: ${snapshot.error}"));
                }
                final items = snapshot.data;
                if (items == null || items.isEmpty) {
                  return const Center(child: Text("まだ画像がありません"));
                }
                return _buildGalleryGrid(items);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryGrid(List<Map<String, dynamic>> items) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final filePath = item["path"];
        final tags = (item["tags"] as List).join(", ");

        return GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(
              tags,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          child: Image.file(File(filePath), fit: BoxFit.cover),
        );
      },
    );
  }
}
