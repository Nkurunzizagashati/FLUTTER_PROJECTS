import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_socialmedia_app/helpers/helper_functions.dart';
// import 'package:flutter/widgets.dart';
import 'package:simple_socialmedia_app/widgets/button.dart';
import 'package:simple_socialmedia_app/widgets/text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameFieldController = TextEditingController();
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  final TextEditingController consfirmPasswordFieldController =
      TextEditingController();

  void registerUser() async {
    // show loading circle

    showDialog(
      context: context,
      builder: (builder) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // make sure password and consfirm password matches

    if (passwordFieldController.text != consfirmPasswordFieldController.text) {
      // pop loading circle

      Navigator.pop(context);

      // show error message

      displayMessageToUser("Passwords don't match", context);
    } else {
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailFieldController.text,
                password: passwordFieldController.text);

        // pop loading circle
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop loading circle
        Navigator.pop(context);

        // show error message
        displayMessageToUser(e.code, context);
      }
    }
  }

  // create user

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
      body: Center(
        child: SingleChildScrollView(
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
                hintText: "Username",
                obsecureText: false,
                controller: usernameFieldController,
              ),
              const SizedBox(height: 10),
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
              CustomTextField(
                hintText: "Confirm Password",
                obsecureText: true,
                controller: consfirmPasswordFieldController,
              ),
              const SizedBox(height: 25),
              CustomButton(
                text: "register",
                onTap: registerUser,
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: const Text(
                      " Login Here",
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
      ),
    );
  }
}
