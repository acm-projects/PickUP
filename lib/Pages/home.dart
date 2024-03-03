import 'package:pickup/classes/game.dart';
import 'package:flutter/material.dart';
import 'package:pickup/classes/user.dart';
import 'package:pickup/classes/location.dart';
import 'package:pickup/Pages/creategame.dart';

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
            Game newGame = Game(
              'Championship', // name
              await User.getUserID(), // user
              'Basketball', // sport
              'description',
              Location(1,2), // location
              10, // numOfPlayers
              DateTime.now().add(const Duration(hours: 1)), // startTime
            );

            await newGame.instantiate();
            await Game.leave(newGame.gameID);
            //leaving twice deleted it
            await Game.join(newGame.gameID);
            await Game.fetch(newGame.gameID);
            newGame.description = "pooop";
            await Game.edit(newGame.gameID, newGame.toMap());
            await Game.delete(newGame.gameID);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateGame()),
            );
          },
        ),
      ),
    );
  }
}
