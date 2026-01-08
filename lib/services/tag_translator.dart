import 'package:translator/translator.dart';
import 'tag_dictionary.dart';
import 'tag_dictionary_store.dart';
import 'tag_normalizer.dart';

class TagTranslator {
  static final _translator = GoogleTranslator();
  static bool _initialized = false;

  // 🔽 起動時に呼ぶ
  static Future<void> init() async {
    if (_initialized) return;

    final stored = await TagDictionaryStore.load();
    tagDictionaryJa.addAll(stored);
    _initialized = true;
  }

  static Future<String> toJapaneseSmart(String tag) async {
    await init();

    final normalized = normalizeTag(tag);

    // ① 辞書にある
    if (tagDictionaryJa.containsKey(normalized)) {
      return tagDictionaryJa[normalized]!;
    }

    // ② 自動翻訳
    final translated =
        await _translator.translate(tag, to: 'ja');

    final ja = translated.text;

    // ③ 辞書に追加
    tagDictionaryJa[normalized] = ja;
    await TagDictionaryStore.save(tagDictionaryJa);

    return ja;
  }

  static Future<List<String>> toJapaneseSmartList(
      List<String> tags) async {
    return Future.wait(tags.map(toJapaneseSmart));
  }
}
