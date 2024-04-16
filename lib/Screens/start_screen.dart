import 'package:flutter/material.dart';
import 'package:pickup/classes/user.dart' as local_user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pickup/classes/game.dart';
import 'dart:async';

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

    Navigator.pushNamed(context, '/Login/HomePage');
  } catch (e) {
    print(e);
  }
}

class _StartScreenState extends State<StartScreen> {
  // Now you can define initState() here
  @override
  //Automatic Login else Send to login/signup
  void initState() {
    super.initState();
    initLogin(context);

    int messageCount = 0;
    /*
    Timer? timer;

    timer = Timer.periodic(Duration(milliseconds: 3000), (_) async {
      List<dynamic> gameChat = (await Game.fetch('858g98137a5i') as Map<String, dynamic>)["chat"];

      for (int i = messageCount; i < gameChat.length; i++) {
        print(gameChat[i]);
      }

      messageCount = gameChat.length;

      timer?.cancel();
    });
    */
  }

   @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background color
        Container(
          color: const Color(0xFF0C2219), // Your desired background color
          width: double.infinity,
          height: double.infinity,
        ),
        // Background pattern widget
        BackgroundPattern(),
        Scaffold(
          backgroundColor:
              Colors.transparent, // Make scaffold background transparent
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            children: [
              const Text(
                'PickUP',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center horizontally
                children: [
                  ElevatedButton(
                    
                     onPressed: () {
                    
                      Navigator.of(context).pushNamed('/Signup');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green.shade300, // Light green color
                      padding:
                          const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                      elevation: 4, // Add a slight elevation
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // Make the text bold
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  const Text(
                    'or',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton(
                   onPressed: () {
                      
                      Navigator.of(context).pushNamed('/Login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade300,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                      elevation: 4, // Add a slight elevation
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // Make the text bold
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class BackgroundPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Add transparent images of sports balls positioned as desired
          Positioned(
            top: 100,
            left: 50,
            child: Image.asset(
              'assets/basketball-hoop.png',
              width: 100,
              height: 100,
              color: Colors.white.withOpacity(0.3), // Adjust opacity as needed
            ),
          ),
          Positioned(
            top: 200,
            right: 100,
            child: Image.asset(
              'assets/volleyball.png',
              width: 120,
              height: 120,
              color: Colors.white.withOpacity(0.3), // Adjust opacity as needed
            ),
          ),
          Positioned(
            bottom: 150,
            left: 80,
            child: Image.asset(
              'assets/soccer-ball.png',
              width: 90,
              height: 90,
              color: Colors.white.withOpacity(0.3), // Adjust opacity as needed
            ),
          ),
          // Add more images as needed
        ],
      ),
    );
  }
}