import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FbAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('サインアウトしました')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('サインアウトに失敗しました: $e')));
    }
  }

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _aiTaggingEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _aiTaggingEnabled = prefs.getBool('aiTaggingEnabled') ?? false;
    });
  }

  Future<void> _saveAiTaggingEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('aiTaggingEnabled', value);
    setState(() {
      _aiTaggingEnabled = value;
    });
  }

  Future<void> _requestPhotoPermission(BuildContext context) async {
    final status = await Permission.photos.request();

    if (status.isGranted) {
      _show(context, '写真フォルダへのアクセスを許可しました');
    } else if (status.isPermanentlyDenied) {
      _openSettings(context);
    } else {
      _show(context, '写真フォルダへのアクセスが拒否されました');
    }
  }

  Future<void> _requestLocationPermission(BuildContext context) async {
    final status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      _show(context, '位置情報へのアクセスを許可しました');
    } else if (status.isPermanentlyDenied) {
      _openSettings(context);
    } else {
      _show(context, '位置情報へのアクセスが拒否されました');
    }
  }

  void _openSettings(BuildContext context) {
    openAppSettings();
    _show(context, '設定画面から権限を有効にしてください');
  }

  void _show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('AIによる画像へのタグ付け機能'),
            subtitle: const Text('Vision AI を使用して画像に自動でタグを付ける 再起動時反映されます'),
            value: _aiTaggingEnabled,
            onChanged: _saveAiTaggingEnabled,
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('写真フォルダへのアクセス許可'),
            onTap: () => _requestPhotoPermission(context),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('位置情報へのアクセス許可'),
            onTap: () => _requestLocationPermission(context),
          ),
        ],
      ),
    );
  }
}
