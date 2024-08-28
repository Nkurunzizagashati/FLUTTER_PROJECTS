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

  Future<List<String>> getAllUsers() async {
    // Specify the type of the collection reference
    CollectionReference<Map<String, dynamic>> usersCollection =
        FirebaseFirestore.instance.collection('users');

    // Now, the snapshot will be of type QuerySnapshot<Map<String, dynamic>>
    QuerySnapshot<Map<String, dynamic>> snapshot = await usersCollection.get();

    // Extract the 'name' field from each document
    List<String> userNames = snapshot.docs.map((doc) {
      return doc.data()['email'] as String; // Ensure type safety here
    }).toList();

    return userNames;
  }
}
