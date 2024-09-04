import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_socialmedia_app/auth/auth.dart';
import 'package:simple_socialmedia_app/firebase_options.dart';
import 'package:simple_socialmedia_app/pages/create_task.dart';
import 'package:simple_socialmedia_app/pages/home_page.dart';
import 'package:simple_socialmedia_app/pages/login_page.dart';
import 'package:simple_socialmedia_app/pages/register_page.dart';
import 'package:simple_socialmedia_app/pages/update_task.dart';
import 'package:simple_socialmedia_app/providers/notification_provider.dart';
import 'package:simple_socialmedia_app/themes/dark_mode.dart';
import 'package:simple_socialmedia_app/themes/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (context) => NotificationsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      theme: lightMode,
      darkTheme: darkMode,
      initialRoute: "/auth",
      routes: {
        '/home': (context) => const HomePage(),
        '/auth': (context) => const AuthPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/create-task': (context) => const CreateTask(),
        '/update-task': (context) => const UpdateTask(),
      },
    );
  }
}
