import 'package:flutter/material.dart';
import 'package:pickup/components/createGameButton.dart';
import 'package:pickup/components/gameTextFields.dart';

class CreateGame extends StatelessWidget {
  CreateGame({Key? key}) : super(key: key);

  var sport = TextEditingController();
  var numPlayers = TextEditingController();
  var gameLocation = TextEditingController();
  var gameDetails = TextEditingController();
  var username = TextEditingController();
  var gameID = TextEditingController();

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
            controller: username,
            hintTxt: 'User ID',
            obscureTxt: false,
          ),
          const SizedBox(height: 15),
          GameTextFields(
            controller: gameID,
            hintTxt: 'Game ID',
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
            controller: gameDetails,
            hintTxt: 'Game details',
            obscureTxt: false,
          ),
          const SizedBox(height: 15),
          GameTextFields(
            controller: gameLocation,
            hintTxt: 'Location',
            obscureTxt: false,
          ),
          
          CreateGameButton(
            onTap: () {
              // gameDetails()
              print('Hello');
            },
          )
        ],
      ),
    );
  }




}