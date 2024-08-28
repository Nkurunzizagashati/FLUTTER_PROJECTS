import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_socialmedia_app/helpers/helper_functions.dart';
import 'package:simple_socialmedia_app/pages/home_page.dart';
import 'package:simple_socialmedia_app/widgets/button.dart';
import 'package:simple_socialmedia_app/widgets/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();

  void login() async {
    // show loading indicator

    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // login the user

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailFieldController.text,
          password: passwordFieldController.text);

      // pop loading indicator
      if (context.mounted) Navigator.pop(context);

      Navigator.pushNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // pop loading indicator

      Navigator.pop(context);

      // display error message to the user
      displayMessageToUser(e.code, context);
    }
  }

  @override
  void dispose() {
    emailFieldController.dispose();
    passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 80,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "M I N I M A L",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 25),
                      CustomTextField(
                        hintText: "Email",
                        obsecureText: false,
                        controller: emailFieldController,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        hintText: "Password",
                        obsecureText: true,
                        controller: passwordFieldController,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot password",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      CustomButton(
                        text: "login",
                        onTap: login,
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/register");
                            },
                            child: const Text(
                              " Register Here",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const HomePage();
            }
          }),
    );
  }
}
