import 'package:flutter/material.dart';
import 'package:pickup/components/createGameButton.dart';
import 'package:pickup/components/gameTextFields.dart';
import 'package:pickup/classes/game.dart';
import 'package:pickup/classes/user.dart';
import 'package:pickup/classes/location.dart';
import 'package:timezone/timezone.dart' as tz;

// ignore: must_be_immutable
class CreateGame extends StatelessWidget {
  CreateGame({super.key});

  var sport = TextEditingController();
  var numPlayers = TextEditingController();
  var gameLocation = TextEditingController();
  var gameDescription = TextEditingController();
  var name = TextEditingController();
  var startTime = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Icon(
            Icons.lock,
            size: 100,
          ),
          const SizedBox(height: 50),
          Text(
            'Register for PickUp! Let the games Begin!',
            style: TextStyle(
              color: Colors.blue[400],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 15),
          GameTextFields(
            controller: name,
            hintTxt: 'Title',
            obscureTxt: false,
          ),
          const SizedBox(height: 15),
          GameTextFields(
            controller: sport,
            hintTxt: 'Select Sport',
            obscureTxt: false,
          ),
          const SizedBox(height: 15),
          GameTextFields(
            controller: numPlayers,
            hintTxt: 'Number of players',
            obscureTxt: false,
          ),
          const SizedBox(height: 15),
          GameTextFields(
            controller: gameDescription,
            hintTxt: 'Game details',
            obscureTxt: false,
          ),
          const SizedBox(height: 15),
          GameTextFields(
            controller: gameLocation,
            hintTxt: 'Location',
            obscureTxt: false,
          ),
          const SizedBox(height: 15),
          GameTextFields(
            controller: startTime,
            hintTxt: 'Time',
            obscureTxt: false,
          ),

          //This should be a mostly linear process,
          //One Game Attribute at a time
          //Input validation
          CreateGameButton(
            onTap: () async {
              // gameDetails()
              try {
                Game game = Game(
                    name.text,
                    await User.getUserID(),
                    sport.text, //Should be a drop down -> templates etc
                    gameDescription.text, //Box Should expand
                    Location(0, 2),
                    int.parse(numPlayers.text),
                    tz.TZDateTime.now(Location.get())
                        .add(Duration(minutes: 15, seconds: 5))); //Calendar

                game.instantiate();
              } catch (e) {
                print("error: $e");
              }
            },
          )
        ],
      ),
    );
  }
}
