import 'package:pickup/Functions/liveMaps.dart';
import 'package:pickup/Pages/loginPage.dart';
import 'package:pickup/Screens/home_page.dart';
import 'package:pickup/Screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/log_in.dart';
import 'Screens/sign_up.dart';
import 'Screens/choose_gametype.dart';
import 'Screens/create_vbgame.dart';
import 'Screens/create_scgame.dart';
import 'Screens/create_bbgame.dart';
import 'Screens/create_tengame.dart';
import 'Screens/choose_location.dart';
import 'Screens/choose_time.dart';
import 'Screens/home_page.dart';
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyCQL-lqTgbOQhTv8F1Oj1YGsqlDCTb-Za8",
            appId: "1:850087823328:android:49aae45eba0d0b47758d85",
            messagingSenderId: "850087823328",
            projectId: "utdpickup",
          ),
        )
      : await Firebase.initializeApp();

  runApp(const PickUpApp());

}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class PickUpApp extends StatelessWidget
{
  const PickUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      // Optionally use navigatorKey if you need it for navigating without context.
      navigatorKey: navigatorKey,
      home: const PickUp(),
      routes: {
        '/Signup': (context) => const Signup(),
        '/Login': (context) => const Login(),
        '/chooseGameType': (context) => const GameCreation(),
        '/homePage': (context) => const HomePage(),
        '/createVolleyballGame': (context) => const createVolleyballGame(),
        '/createSoccerGame': (context) => const createSoccerGame(),
        '/createTennisGame': (context) => const createTennisGame(),
        '/createBasketballGame': (context) => const createBasketballGame(),
        '/chooseTime': (context) => const ChooseTime(),
        '/chooseLocation': (context) => const chooseLocation(),
      },
    );
  }
}

class PickUp extends StatelessWidget 
{
  const PickUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      backgroundColor: const Color(0xFF0C2219),
      body: Padding
      (
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            const Text
            (
              'PickUp',
              style: TextStyle
              (
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
                  onPressed: () 
                  {
                    Navigator.of(context).pushNamed('/Signup');
                  },
                  style: ElevatedButton.styleFrom
                  (
                    backgroundColor: const Color.fromARGB(255, 94, 160, 96),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text
                  (
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 24),
                const Text(
                  'or',
                  style: TextStyle(color: Colors.white, fontSize: 18,),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: () 
                  {
                    Navigator.of(context).pushNamed('/Login');
                  },
                  style: ElevatedButton.styleFrom
                  (
                    backgroundColor: const Color.fromARGB(255, 94, 160, 96),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Login',
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
}
