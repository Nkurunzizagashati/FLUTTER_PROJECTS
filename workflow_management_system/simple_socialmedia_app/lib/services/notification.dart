import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Notifications {
  void notify(senderEmail, receiverEmail, message) async {
    await FirebaseFirestore.instance.collection("notifications").add({
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'message': message,
      'isRead': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyNotifications() {
    final myEmail = FirebaseAuth.instance.currentUser!.email;
    return FirebaseFirestore.instance
        .collection("notifications")
        .where('receiverEmail', isEqualTo: myEmail)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyUnreadNotifications() {
    final myEmail = FirebaseAuth.instance.currentUser!.email;
    return FirebaseFirestore.instance
        .collection("notifications")
        .where('receiverEmail', isEqualTo: myEmail)
        .where('isRead', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
