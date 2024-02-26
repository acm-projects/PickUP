import 'package:pickup/classes/Game.dart';
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
          child: const Text('Create a Game'),
          onPressed: () async {
            Game newGame = Game(
              'Championship', // name
              'John Doe', // user
              'Basketball', // sport
              123, // location
              10, // numOfPlayers
              DateTime.now(), // date
              DateTime.now(), // timeCreated
              DateTime.now().add(Duration(hours: 1)), // startTime
            );

            Game.createGame(game: newGame);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondPage()),
            );
          },
        ),
      ),
    );
  }
}
