import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> registerUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential registeredUser =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return registeredUser.user;
    } catch (e) {
      log("Something went wrong: $e"); // Logging the actual error
      return null; // Return null if registration fails
    }
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential registeredUser = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return registeredUser.user;
    } catch (e) {
      log("Something went wrong: $e"); // Logging the actual error
      return null; // Return null if registration fails
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  Future<List<Map<String, String>>> fetchUsers() async {
    try {
      // Fetch users from Firestore
      final QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await _firestore.collection('Users').get();

      // Log the number of documents found
      print("Number of users fetched: ${usersSnapshot.docs.length}");

      // Convert the snapshot into a list of users with type casting
      final List<Map<String, String>> users = usersSnapshot.docs.map((user) {
        print("User found: ${user.data()}");
        return {
          "name": user.data()["name"] as String? ?? "No Name",
          "email": user.data()["email"] as String? ?? "No Email",
        };
      }).toList();

      print("METHOD CALLED");

      return users;
    } catch (e) {
      log("Error fetching users: $e");
      return [];
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return user;
      } else {
        print("Not authenticated");
        return null;
      }
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }
}
