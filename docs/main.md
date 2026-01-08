## `main.dart`

- **目的**: アプリケーションのエントリーポイント（開始点）です。
- **主要機能**:
    - `main`関数:
        - `WidgetsFlutterBinding.ensureInitialized()`: Flutterアプリの初期化を保証します。
        - `.env`ファイルから環境変数を読み込みます (`flutter_dotenv`)。
        - Firebaseを初期化します (`Firebase.initializeApp`)。
        - デバイスのストレージへのアクセス許可を要求します (`PhotoManager.requestPermissionExtend`)。
        - `runApp(const MyApp())` を呼び出して、アプリケーションを起動します。
    - `MyApp`クラス:
        - `MaterialApp`をルートウィジェットとして使用します。
        - `StreamBuilder`を使用して、Firebaseの認証状態 (`FbAuth.instance.authStateChanges`) を監視します。
        - 認証状態に応じて、以下のいずれかのページを表示します。
            - **認証待ち**: `CircularProgressIndicator`を表示します。
            - **未認証**: `AuthPage`（ログイン/ユーザー作成ページ）を表示します。
            - **認証済み**: `MainTabPage`（メインのタブページ）を表示します。
