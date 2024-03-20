import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickup/Functions/liveMaps.dart';
import 'package:pickup/components/myButtons.dart';
import 'package:pickup/components/my_textFields.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<String?> signUserIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
      Navigator.pushNamed(context, '/login/liveMap');
      return null;
    } catch (e) {
      print(e);
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
            onTap: () {
              signUserIn(context);
              print('button click fr');
            },
          )
        ],
      ),
    );
  }
}
