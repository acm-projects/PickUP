import 'package:flutter/material.dart';
import 'Screens/log_in.dart';
import 'Screens/sign_up.dart';

void main() => runApp(const PickUp());

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class PickUp extends StatelessWidget {
  const PickUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Use the navigatorKey here
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to PickUp'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.note_add),
              onPressed: () {
                // Use the navigatorKey to push the route
                navigatorKey.currentState?.pushNamed('/Signup');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // Use the navigatorKey to push the route
                navigatorKey.currentState?.pushNamed('/Login');
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
      },
    );
  }
}


