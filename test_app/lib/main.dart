import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_app/pages/auth/register_page.dart';
import 'package:test_app/pages/home_page.dart';
import 'package:test_app/pages/task/create_task.dart';
import 'package:test_app/pages/welcom_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDK9kJ8pTePUXFpJkFhkjrt_VPv_CLOuRk",
          authDomain: "wfms-55d25.firebaseapp.com",
          projectId: "wfms-55d25",
          storageBucket: "wfms-55d25.appspot.com",
          messagingSenderId: "1066587550955",
          appId: "1:1066587550955:web:8e569fc0a6d567b84efaae"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WORKFLOW MANAGEMENT SYSTEM",
      initialRoute: '/login',
      routes: {
        '/': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const WelcomPage(),
        '/task/create': (context) => const CreateTask(),
      },
    );
  }
}
