import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
}
