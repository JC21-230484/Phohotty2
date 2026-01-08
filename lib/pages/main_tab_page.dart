import 'package:flutter/material.dart';
import 'home_page.dart';
import 'tag_lens_page.dart';
import 'map_page.dart';
import 'sns_page.dart';
import 'settings_page.dart';
import 'auth_page.dart';

class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key});

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    HomePage(),
    TagLensPage(),
    MapPage(),
    SnsPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AuthPage()),
              );
            },
            child: Text('アカウント'),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: '写真一覧',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'タグ付け',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '画像マップ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'SNS投稿',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
