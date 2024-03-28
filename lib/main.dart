import 'package:pickup/Functions/liveMaps.dart';
import 'package:pickup/Pages/loginPage.dart';
import 'package:pickup/Pages/home.dart';
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
void main() => runApp(const PickUp());

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class PickUp extends StatelessWidget {
  const PickUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/Signup': (context) => const Signup(),
        '/Login': (context) => const Login(),
        '/GameCreation': (context) => const GameCreation(),
        '/createVolleyballGame': (context) => const createVolleyballGame(),
        '/createSoccerGame': (context) => const createSoccerGame(),
        'createSoccerGame': (context) => const createTennisGame(),
        '/createBasketballGame': (context) => const createBasketballGame(),

        '/': (context) => const StartScreen(),
        //'/login': (context) => LoginPage(),
        //'/signup': (context) => SignUpPage(),
        '/login/home': (context) => const HomePage(),
        '/login/liveMap': (context) => LiveMap(),
      },
    );
  }
}