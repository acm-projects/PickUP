import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickup/Functions/liveMap.dart';
import 'package:pickup/buttons/button.dart';
import 'package:pickup/buttons/myTextField.dart';


class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  // text editing
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<String?> signUserUp() async {
    try {
      String email = usernameController.text;

      if (email.endsWith('@utdallas.edu')) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: passwordController.text,
        );
        return null;
      } else {
        return 'Email domain is not valid';
      }
    } catch (e) {
      return e.toString(); // Return error message if unsuccessful
    }
  }

  Future<String?> signUserIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
      return "Successfully signed in";
    } catch (e) {
      return e.toString(); // Return error message if unsuccessful
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Icon(
            Icons.lock,
            size: 100,
          ),
          const SizedBox(height: 50),
          Text(
            'Welcome Back to PickUp! Let the games Begin!',
            style: TextStyle(
              color: Colors.blue[400],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 25),
          MyTextField(
            controller: usernameController,
            hintTxt: 'username',
            obscureTxt: false,
          ),
          const SizedBox(height: 25),
          MyTextField(
            controller: passwordController,
            hintTxt: 'password',
            obscureTxt: true,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Add your forgot password logic here
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blue[200]),
                  ),
                ),
              ],
            ),
          ),
          MyButton(
  onTap: () async {
    String? signInResult = await signUserIn();

    if (signInResult == "Successfully signed in") {
      // If sign-in is successful, navigate to the SignUpPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LiveMap(),
        ),
      );
    } else {
      // Handle unsuccessful sign-in, you can show an error message if needed
      print("Sign-in failed: $signInResult");
    }
  },
)

        ],
      ),
    );
  }
}