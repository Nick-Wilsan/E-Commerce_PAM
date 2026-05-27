// FILE INI MEMBUAT APPSTATE BISA DIAKSES DARI SEMUA HALAMAN.
//
// AppState dibuat di `main.dart`, tetapi halaman lain seperti LoginPage dan
// DashboardPage juga perlu mengaksesnya. Untuk itu dipakai InheritedNotifier.
//
// Cara pakai di halaman:
// final appState = AppStateScope.of(context);
//
// Setelah mendapatkan appState, halaman bisa memanggil:
// - appState.login(...)
// - appState.register(...)
// - appState.completeLesson(...)
// - appState.logout()

import 'package:flutter/widgets.dart';

import 'app_state.dart';

// InheritedNotifier membuat widget turunannya otomatis rebuild saat notifier
// menjalankan `notifyListeners()`.
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState notifier,
    required super.child,
  }) : super(notifier: notifier);

  // Method static ini memudahkan halaman mengambil AppState dari context.
  //
  // `context.dependOnInheritedWidgetOfExactType` artinya halaman yang memanggil
  // method ini akan ikut mendengarkan perubahan AppState.
  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();

    // Assert dipakai saat development. Jika AppStateScope tidak ditemukan,
    // berarti ada halaman yang tidak dibungkus oleh AppStateScope di main.dart.
    assert(scope != null, 'AppStateScope tidak ditemukan.');

    return scope!.notifier!;
  }
}
