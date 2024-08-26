import 'package:test_app/models/user.dart';

final List<User> _users = [];

class UserManager {
  // Register a new user
  bool registerUser(String email, String password) {
    if (_users.any((user) => user.email == email)) {
      return false; // User already registered
    }

    print("Email: $email, Password: $password");

    // Register the user if no existing user found with the same email
    _users.add(User(email, password));
    print(_users); // Print all users for debugging
    return true;
  }

  // Login an existing user
  bool loginUser(String email, String password) {
    return _users
        .any((user) => user.email == email && user.password == password);
  }

  // Optionally, provide a way to access the registered users
  List<User> getUsers() {
    return _users;
  }
}
