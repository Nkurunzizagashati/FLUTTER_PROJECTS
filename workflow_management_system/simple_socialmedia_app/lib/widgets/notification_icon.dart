import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection("notifications").snapshots(),
      builder: (context, snapshot) {
        // Default notification count to 0
        int notificationCount = 0;

        if (snapshot.hasData) {
          // Safely access the documents from the snapshot
          final List<DocumentSnapshot> notifications = snapshot.data!.docs;
          notificationCount = notifications.length;
        }

        return Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_active,
                size: 40,
              ),
              onPressed: () {
                // Define what happens when the button is pressed
              },
            ),
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
                child: Center(
                  child: Text(
                    '$notificationCount', // Display the number of notifications
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
