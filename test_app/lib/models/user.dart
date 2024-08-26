class User {
  final String email;
  final String password;

  User(this.email, this.password);

  @override
  String toString() {
    return 'User{email: $email, password: $password}';
  }
}
