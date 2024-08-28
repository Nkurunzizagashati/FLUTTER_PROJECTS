import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  Future<UserCredential> registerUser(String email, String password) async {
    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<DocumentReference<Map<String, dynamic>>> addUserDetails(
      String email, String password, String username) async {
    return await FirebaseFirestore.instance.collection("users").add({
      'email': email,
      'password': password,
      'username': username,
    });
  }

  Future<UserCredential> loginUser(String email, String password) async {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getAllUsers() async {
    final response = await FirebaseFirestore.instance.collection("users").get();
    final users = response.docs;
    return users;
  }
}
