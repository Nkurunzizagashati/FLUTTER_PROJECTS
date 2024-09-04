import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationsProvider with ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  List<DocumentSnapshot> _notifications = [];

  List<DocumentSnapshot> get notifications => _notifications;

  FireSoreService() {
    _fireStore.collection("notifications").snapshots().listen((snapshot) {
      _notifications = snapshot.docs;
      notifyListeners();
    });
  }
}
