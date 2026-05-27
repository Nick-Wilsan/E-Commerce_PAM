import 'package:flutter/material.dart';
import 'package:tugasakhir/pages/dashboard_page.dart';
import 'package:tugasakhir/pages/home.dart';
import 'package:tugasakhir/pages/lesson_page.dart';
import 'package:tugasakhir/pages/login_page.dart';
import 'package:tugasakhir/pages/register_page.dart';
import 'package:tugasakhir/state/app_state.dart';
import 'package:tugasakhir/state/app_state_scope.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

@override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppState _appState = AppState();

@override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: _appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

title: 'BelajarKu',

theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B7F79)),

fontFamily: 'Poppins',

inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),

cardTheme: const CardThemeData(
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              side: BorderSide(color: Color(0xFFE4E7EC)),
            ),
          ),
        ),

initialRoute: '/',

routes: {
          '/': (_) => const HomePage(),
          LoginPage.routeName: (_) => const LoginPage(),
          RegisterPage.routeName: (_) => const RegisterPage(),
          DashboardPage.routeName: (_) => const DashboardPage(),
          LessonPage.routeName: (_) => const LessonPage(),
        },
      ),
    );
  }
}
