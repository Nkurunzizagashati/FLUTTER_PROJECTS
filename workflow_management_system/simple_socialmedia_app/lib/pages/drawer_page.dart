import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.fromLTRB(10, 70, 10, 30),
      width: MediaQuery.of(context).size.width * 0.85,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.book,
              size: 40,
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
                  ),
                  Text("NOTIFICATIONS")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
