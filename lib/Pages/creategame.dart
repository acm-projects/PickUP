import 'package:flutter/material.dart';
import 'package:pickup/components/createGameButton.dart';
import 'package:pickup/components/gameTextFields.dart';
import 'package:pickup/classes/game.dart';
import 'package:pickup/classes/location.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:pickup/classes/user.dart';

class CreateGame extends StatefulWidget {
  const CreateGame({super.key});

  @override
  CreateGameState createState() => CreateGameState();
}

// ignore: must_be_immutable
class CreateGameState extends State<CreateGame> {
  var sport = TextEditingController();
  var numPlayers = TextEditingController();
  var gameDescription = TextEditingController();
  var name = TextEditingController();
  String selectedSport = 'Basketball'; // Store the selected sport

  final List<String> sports = [
    'Basketball',
    'Soccer',
    'Tennis',
    'Volleyball',
    'Baseball',
    // Add more sports here if needed
  ];

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
          DropdownButton<String>(
              value: selectedSport,
              onChanged: (newValue) {
                setState(() {
                  // Update state to reflect change
                  selectedSport = newValue!;
                });
              },
              items: sports.map<DropdownMenuItem<String>>((String sport) {
                return DropdownMenuItem<String>(
                  value: sport,
                  child: Text(sport),
                );
              }).toList(),
              hint: const Text('Select a sport')),
          const SizedBox(height: 15),
          GameTextFields(
            controller: gameDescription,
            hintTxt: 'Game details',
            obscureTxt: false,
          ),

          //This should be a mostly linear process,
          //One Game Attribute at a time
          //Input validation
          CreateGameButton(
            //Send them to select time page then to ->
            //Send Them To Location Selection Page
            onTap: () async {
              String x = '858g98137a5i';
              // gameDetails()
              await Game.message(x, "msg");
              await Game.message(x, "msg1");
              await Game.message(x, "msg2");
              await Game.message(x, "msg3");
              await Game.message(x, "msg4");
              await Game.message(x, "msg5");
              await Game.message(x, "msg6");
              Navigator.pushNamed(context, '/login/home/create/calendar');
            },
          )
        ],
      ),
    );
  }
}
