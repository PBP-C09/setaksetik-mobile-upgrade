import 'package:flutter/material.dart';
import 'screens/login.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SetakSetik',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF6D4C41),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.brown,
          ).copyWith(secondary: const Color(0xFF842323)),
          fontFamily: 'Raleway',
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontFamily: 'Raleway', color: const Color(0xFFF5F5DC)),
            bodyMedium: TextStyle(fontFamily: 'Raleway', color: const Color(0xFF3E2723)),
            bodySmall: TextStyle(fontFamily: 'Raleway', color: const Color(0xFFF5F5DC)),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFFF5F5DC),
            titleTextStyle: TextStyle(
              fontFamily: 'Playfair Display',
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF3E2723),
              fontSize: 20,
            ),
          ),
          useMaterial3: true,
          ),
        home: const LoginPage(),
      ),
    );
  }
}

class UserProfile {
  static bool loggedIn = false;
  static Map<String, dynamic> data = {};

  static void login(Map<String, dynamic> data) {
    loggedIn = true;
    UserProfile.data = data;
  }

  static void logout() {
    loggedIn = false;
    data = {};
  }
}