import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // padding: EdgeInsets.fromLTRB(10, 70, 10, 30),
      width: MediaQuery.of(context).size.width * 0.90,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.book,
              size: 80,
            ),
            const SizedBox(height: 120),
            Container(
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.notifications,
                    size: 30,
                  ),
                  Text(
                    "NOTIFICATIONS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.settings,
                    size: 30,
                  ),
                  Text(
                    "SETTINGS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.add,
                      size: 30,
                    ),
                    Text(
                      "CREATE TASK",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/create-task');
              },
            ),
            const SizedBox(height: 10),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.logout,
                      size: 30,
                    ),
                    Text(
                      "LOGOUT",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
