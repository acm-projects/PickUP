import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickup/components/my_textFields.dart';
import 'package:pickup/components/signUpButton.dart';

class signUpPage extends StatelessWidget {
  signUpPage({super.key});

  // text editing
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<String?> signUserUp() async {
    try {
      String email = usernameController.text;
      if (isConfirmed()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: passwordController.text,
        );
      }
    } catch (e) {
      return e.toString(); // Return error message if unsuccessful
    }
    return null;
  }

  bool isConfirmed() {
    if (passwordController.text == confirmPasswordController.text) {
      return true;
    }
    return false;
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
            'Register for PickUp! Let the games Begin!',
            style: TextStyle(
              color: Colors.blue[400],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 25),
          MyTextField(
            controller: usernameController,
            hintTxt: 'Username',
            obscureTxt: false,
          ),
          const SizedBox(height: 25),
          MyTextField(
            controller: passwordController,
            hintTxt: 'Password',
            obscureTxt: true,
          ),
          const SizedBox(height: 25),
          MyTextField(
            controller: confirmPasswordController,
            hintTxt: 'Confirm Password',
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
          SignUpButton(
            onTap: () {
              signUserUp();
            },
          )
        ],
      ),
    );
  }
}
