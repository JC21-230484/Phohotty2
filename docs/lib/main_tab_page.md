## `pages/main_tab_page.dart`

- **目的**: アプリケーションのメイン画面となる、タブ切り替えのインターフェースを提供します。
- **主要機能**:
    - `BottomNavigationBar`を使用して、複数のページを切り替えるためのタブバーを画面下部に表示します。
    - タブは「Gallery」(`HomePage`)と「Tag Lens」(`TagLensPage`)の2つで構成されます。
    - `IndexedStack`ウィジェットを使用して、選択されたタブのページのみを表示し、非表示のページの状態は保持します。
