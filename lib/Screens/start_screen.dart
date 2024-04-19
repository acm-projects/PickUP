import 'package:flutter/material.dart';
import 'package:pickup/classes/user.dart' as local_user;
import 'package:firebase_auth/firebase_auth.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}
void initLogin(BuildContext context) async {
  try {
    final String? userID = await local_user.User.getUserID();
    final String password = await local_user.User.getPassword();

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: userID!,
      password: password,
    );

    Navigator.pushNamed(context, '/Login/HomePage');
  } catch (e) {
    print(e);
  }
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    initLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    // Reduce the initial space to center content more effectively
    double topPadding = MediaQuery.of(context).size.height * 0.35; // Reduced from 0.1 to 0.05

    return Stack(
      children: [
        Container(
          color: const Color(0xFF0C2219), // Background color
          width: double.infinity,
          height: double.infinity,
        ),
        const BackgroundPattern(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Aligns children to the start of the column
            children: [
              SizedBox(height: topPadding), // Adjust top padding dynamically
              Image.asset(
                'assets/PickUP-Logo.png',
                width: 400,
                height: 200,
              ),
              //SizedBox(height: MediaQuery.of(context).size.height * 0.001), // Adjust space after the logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  gradientButton('Sign Up', '/Signup', context),
                  const SizedBox(width: 24),
                  const Text(
                    'or',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 24),
                  gradientButton('Login', '/Login', context),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget gradientButton(String text, String route, BuildContext context) {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFF80F37F), Color(0xFF80E046)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(route),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundPattern extends StatelessWidget {
  const BackgroundPattern({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: 100,
            left: 50,
            child: Image.asset(
              'assets/basketball-hoop.png',
              width: 100,
              height: 100,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          Positioned(
            top: 200,
            right: 100,
            child: Image.asset(
              'assets/volleyball.png',
              width: 120,
              height: 120,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          Positioned(
            bottom: 150,
            left: 80,
            child: Image.asset(
              'assets/soccer-ball.png',
              width: 90,
              height: 90,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
