## `services/local_storage.dart`

- **目的**: デバイスのローカルストレージへのデータ保存・読み込みを管理します。
- **主要機能**:
    - `saveImage`: `Uint8List`形式の画像データを、アプリのドキュメントディレクトリに`.jpg`ファイルとして保存します。ファイル名はUUIDで一意に生成されます。
    - `saveImageTags`: 画像のパスとタグのリストを、`SharedPreferences`にJSON形式で保存します。`gallery`というキーで、複数の画像情報をリストとして管理します。
    - `loadGallery`: `SharedPreferences`から保存されたギャラリーの全アイテム（画像パス、タグ、作成日時など）を読み込み、`List<Map<String, dynamic>>`として返します。
    - `deleteItem`: 指定されたIDのアイテムをギャラリーから削除します。
    - `clearAll`: ギャラリーの全データを`SharedPreferences`から削除します。
