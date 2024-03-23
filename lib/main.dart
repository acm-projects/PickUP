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
      navigatorKey: navigatorKey, 
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to PickUp'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.note_add),
              onPressed: () {
              
                navigatorKey.currentState?.pushNamed('/Signup');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
               
                navigatorKey.currentState?.pushNamed('/Login');
              },
            ),
            IconButton(
              icon: const Icon(Icons.sports_soccer), // Icon for game creation, choose an appropriate one
              onPressed: () {
                navigatorKey.currentState?.pushNamed('/GameCreation');
              },
            ),
          ],
        ),
        body: const Center(
          child: Text('Home Page'),
        ),
      ),
      routes: {
        '/Signup': (context) => const Signup(),
        '/Login': (context) => const Login(),
        '/GameCreation': (context) => const GameCreation(),
        '/createVolleyballGame': (context) => const createVolleyballGame(),
        '/createSoccerGame': (context) => const createSoccerGame(),
        '/createTennisGame': (context) => const createTennisGame(),
        '/createBasketballGame': (context) => const createBasketballGame(),

      },
    );
  }
}


