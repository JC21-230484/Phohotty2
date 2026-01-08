import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/tag_chip.dart';
import '../services/google_vision.dart';
import '../services/tag_translator.dart';
import '../services/local_storage.dart';

class TagLensPage extends StatefulWidget {
  const TagLensPage({super.key});

  @override
  State<TagLensPage> createState() => _TagLensPageState();
}

class _TagLensPageState extends State<TagLensPage> {
  Uint8List? imageBytes;

  List<String> suggestedTags = [];
  Set<String> selectedTags = {};
  List<String> customTags = [];

  bool loading = false;
  String? errorMessage;
  bool aiEnabled = false;

  final picker = ImagePicker();
  final customTagController = TextEditingController();

  late final GoogleVisionService vision;
  final local = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = dotenv.env['GOOGLE_VISION_API_KEY'] ?? '';
    setState(() {
      aiEnabled = prefs.getBool('aiTaggingEnabled') ?? false;
      if (apiKey.isEmpty) {
        errorMessage = 'Google Vision API キーが設定されていません';
      }
    });
    vision = GoogleVisionService(apiKey: apiKey);
  }

  @override
  void dispose() {
    customTagController.dispose();
    super.dispose();
  }

  // ===============================
  // 画像選択 → AI解析 → 日本語タグ化
  // ===============================
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    setState(() {
      imageBytes = bytes;
      suggestedTags.clear();
      selectedTags.clear();
      customTags.clear();
      loading = true;
      errorMessage = null;
    });

    if (aiEnabled) {
      try {
        // ① AIで英語タグ取得
        final labels = await vision.analyzeLabels(bytes);

        // 辞書登録込みで日本語化
        final jaTags =
          await TagTranslator.toJapaneseSmartList(labels);
        setState(() {
          suggestedTags = jaTags;
          selectedTags = jaTags.toSet();
          loading = false;
        });
      } catch (e) {
        setState(() {
          loading = false;
          errorMessage = 'タグ解析エラー: $e';
        });
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  // ===============================
  // カスタムタグ追加
  // ===============================
  void addCustomTag() {
    final tag = customTagController.text.trim();
    if (tag.isEmpty) return;

    if (selectedTags.contains(tag)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('すでに存在するタグです')),
      );
      return;
    }

    setState(() {
      customTags.add(tag);
      selectedTags.add(tag);
      customTagController.clear();
    });
  }

  // ===============================
  // 保存処理
  // ===============================
  Future<void> saveImage() async {
    if (imageBytes == null || selectedTags.isEmpty) return;

    try {
      setState(() => loading = true);

      final path = await local.saveImage(imageBytes!);
      await local.saveImageTags(path, selectedTags.toList());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('画像とタグを保存しました'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushNamed(context, '/gallery');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存エラー: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ふぉとってぃ'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/gallery'),
            child: const Text('ギャラリー'),
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  // 画像選択
                  InkWell(
                    onTap: pickImage,
                    child: Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: imageBytes == null
                          ? const Center(
                              child: Text('クリックして画像を選択'),
                            )
                          : Image.memory(imageBytes!, fit: BoxFit.cover),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'タグ候補',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...suggestedTags.map(
                        (tag) => TagChip(
                          label: tag,
                          selected: selectedTags.contains(tag),
                          onTap: () {
                            setState(() {
                              selectedTags.contains(tag)
                                  ? selectedTags.remove(tag)
                                  : selectedTags.add(tag);
                            });
                          },
                        ),
                      ),
                      ...customTags.map(
                        (tag) => TagChip(
                          label: tag,
                          custom: true,
                          selected: selectedTags.contains(tag),
                          onTap: () {
                            setState(() {
                              selectedTags.contains(tag)
                                  ? selectedTags.remove(tag)
                                  : selectedTags.add(tag);
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // カスタムタグ
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: customTagController,
                          decoration: const InputDecoration(
                            hintText: 'カスタムタグを追加',
                          ),
                          onSubmitted: (_) => addCustomTag(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: addCustomTag,
                      )
                    ],
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('保存'),
                    onPressed: saveImage,
                  )
                ],
              ),
            ),
    );
  }
}
