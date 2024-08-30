import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:simple_socialmedia_app/auth/auth.dart';
import 'package:simple_socialmedia_app/pages/home_page.dart';
import 'package:simple_socialmedia_app/pages/login_page.dart';
import 'package:simple_socialmedia_app/pages/register_page.dart';
import 'package:simple_socialmedia_app/themes/dark_mode.dart';
import 'package:simple_socialmedia_app/themes/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      theme: darkMode,
      darkTheme: lightMode,
      initialRoute: "/auth",
      routes: {
        '/home': (context) => const HomePage(),
        '/auth': (context) => const AuthPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage()
      },
    );
  }
}
