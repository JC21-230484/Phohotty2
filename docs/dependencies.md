## `pubspec.yaml` (Dependencies)

プロジェクトが依存している主要なパッケージ（ライブラリ）の一覧です。

### Firebase
- `firebase_core`: Firebaseプロジェクトに接続するための基本パッケージ。
- `firebase_auth`: メールアドレス/パスワード、Googleサインインなどの認証機能を提供。
- `cloud_firestore`: NoSQLデータベース。ユーザー情報や投稿などを保存。
- `firebase_storage`: 画像などのファイルをクラウドに保存。

### UI & Widgets
- `flutter`: FlutterのUIフレームワーク。
- `cupertino_icons`: iOS風のアイコンセット。
- `photo_view`: ピンチ操作による画像のズームやパンを可能にするウィジェット。
- `google_maps_flutter`: Googleマップをアプリに統合。

### Device & Permissions
- `image_picker`: デバイスのギャラリーやカメラから画像を選択。
- `photo_manager`: デバイスのストレージ（特に写真ライブラリ）へのアクセスと管理。
- `path_provider`: アプリのドキュメントディレクトリなど、ファイルシステムのパスを取得。
- `geolocator`: デバイスの位置情報を取得。

### Data & Utilities
- `shared_preferences`: 簡単なデータをデバイスに永続的に保存（キーバリュー形式）。
- `http`: HTTPリクエストを作成・実行し、外部APIと通信。
- `uuid`: 一意なID（UUID）を生成。
- `flutter_dotenv`: `.env`ファイルから環境変数を読み込み、APIキーなどを安全に管理。
- `image`: 画像データの高度な操作や変換を行う。

### Authentication
- `google_sign_in`: Googleアカウントでのサインインを実装。
