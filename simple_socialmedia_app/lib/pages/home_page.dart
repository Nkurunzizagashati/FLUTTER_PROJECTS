import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_socialmedia_app/pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surface,
                appBar: AppBar(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: const Text(
                    'Home Page',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: logout,
                    )
                  ],
                ),
                body: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.blue),
                              foregroundColor:
                                  WidgetStateProperty.all(Colors.white)),
                          child: const Text(
                            "View tasks",
                          ),
                        ),
                        // const Expanded(
                        //   child: SizedBox(),
                        // ),
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.blue),
                              foregroundColor:
                                  WidgetStateProperty.all(Colors.white)),
                          child: const Text(
                            "Create task",
                          ),
                        )
                      ],
                    ),
                    Row(),
                  ],
                ));
          } else {
            return const LoginPage();
          }
        });
  }
}
