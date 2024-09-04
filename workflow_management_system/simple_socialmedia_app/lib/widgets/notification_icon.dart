import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("notifications")
          .where('receiverEmail', isEqualTo: currentUserEmail)
          .where('isRead', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        // Default notification count to 0
        int notificationCount = 0;

        if (snapshot.hasData) {
          // Access the filtered documents from the snapshot
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
            if (notificationCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 2.0, vertical: 2.0),
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
