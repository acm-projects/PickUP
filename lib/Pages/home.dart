import 'package:pickup/classes/game.dart';
import 'package:flutter/material.dart';
import 'package:pickup/Pages/secondPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Pick Up!'),
          onPressed: () async {

            /*
            Game newGame = Game(
              'Championship', // name
              'Kobe', // user
              'Basketball', // sport
              123, // location
              10, // numOfPlayers
              DateTime.now(), // timeCreated
              DateTime.now().add(const Duration(hours: 1)), // startTime
            );
            */
            Game.fetch();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecondPage()),
            );
          },
        ),
      ),
    );
  }
}
