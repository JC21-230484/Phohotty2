## `services/fb_auth.dart`

- **目的**: Firebase Authenticationに関する処理をまとめたサービスクラスです。
- **主要機能**:
    - `FbUser`クラス: Firebaseの`User`オブジェクトを、アプリケーション内で扱いやすいように抽象化したモデルです。
    - `FbAuth`クラス (シングルトン):
        - `authStateChanges`: Firebaseの認証状態の変更をStreamとして提供します。これにより、ログイン状態をリアルタイムに監視できます。
        - `currentUser`: 現在ログインしているユーザーの情報を`FbUser`オブジェクトとして取得します。
        - `signInWithGoogle`: Googleサインインを実行し、成功すると`FbUser`オブジェクトを返します。
        - `signOut`: FirebaseおよびGoogleからサインアウトします。
