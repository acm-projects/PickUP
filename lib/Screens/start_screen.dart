import 'package:flutter/material.dart';
import 'package:pickup/classes/user.dart' as local_user;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pickup/classes/notification.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:pickup/classes/location.dart';

import 'dart:async';
import 'package:pickup/classes/game.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

void initLogin(BuildContext context) async {
  try {
    final String userID = await local_user.User.getUserID();
    final String password = await local_user.User.getPassword();

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: userID,
      password: password,
    );

    Navigator.pushNamed(context, '/login/home');
  } catch (e) {
    print("Account credentials don't match or exist.");
  }
}

class _StartScreenState extends State<StartScreen> {
  // Now you can define initState() here
  @override
  //Automatic Login else Send to login/signup
  void initState() async {
    super.initState();
    initLogin(context);

    int messageCount = 0;  

    Timer? timer;

    timer = Timer.periodic(Duration(milliseconds: 3000), (_) async {
      List<dynamic> gameChat = (await Game.fetch('858g98137a5i') as Map<String, dynamic>)["chat"];

      for (int i = messageCount; i < gameChat.length; i++) {
        print(gameChat[i]);
      }

      messageCount = gameChat.length;

      timer?.cancel();
    });

    // Your function to be executed when the page opens
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3E2F),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'PickUP',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 48,
              ),
            ),
            const SizedBox(height: 180),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 94, 160, 96),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 24),
                const Text(
                  'or',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 94, 160, 96),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // ... other methods and build method
}
