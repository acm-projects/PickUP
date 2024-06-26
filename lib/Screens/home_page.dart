import 'package:flutter/material.dart';
import 'package:pickup/Screens/stats_page.dart';
import 'package:pickup/classes/user.dart';
import 'package:slider_button/slider_button.dart';
import 'package:pickup/classes/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickup/Screens/chat_page.dart';
import 'package:pickup/classes/location.dart';
import 'package:timezone/timezone.dart' as tz;
import 'directionMap.dart';
import 'package:pickup/Screens/join_page.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static late Timer timer;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _activeGames = [];
  List<Map<String, dynamic>> _upcomingGames = [];

  Widget? sliderWidget;
  bool finishGame = false;

  @override
  void initState() {
    try {
      super.initState();

      User.getFirstName();
      User.getLastName();
      User.getUserID();

      // Mock data for active game
      _activeGames = [
        {
          'teamName1': 'Chelsea',
          'teamName2': 'Man UTD',
          'gameTime': '7:30 PM',
          'location': 'UTD Field 1',
        }
      ];
      // Mock data for upcoming games
      _upcomingGames = [];

      Future<void> getActiveGames() async {
        setState(() {});
        CollectionReference usersJoinedGames = FirebaseFirestore.instance
            .collection("Users")
            .doc(await User.getUserID())
            .collection("JoinedGames");

        List<String> games =
            (await usersJoinedGames.get()).docs.map((doc) => doc.id).toList();

        for (int index = 0; index < _upcomingGames.length; index++) {
          if (!games.contains(_upcomingGames[index]["id"])) {
            _upcomingGames.removeAt(index);
          }
        }

        for (final game in games) {
          if (game == 'bedrock') continue;
          Map<String, dynamic> gameInfo =
              await Game.fetch(game) as Map<String, dynamic>;
          tz.TZDateTime date = tz.TZDateTime.parse(
              Location.getTimeZone(), gameInfo["startTime"]);

          String morningOrNight = date.hour - 12 >= 0 ? "PM" : "AM";

          final Map<int, String> monthsInYear = {
            1: 'Jan',
            2: 'Feb',
            3: 'Mar',
            4: 'Apr',
            5: 'May',
            6: 'Jun',
            7: 'Jul',
            8: 'Aug',
            9: 'Sept',
            10: 'Oct',
            11: 'Nov',
            12: 'Dec',
          };

          int hour = date.hour % 12;
          if (hour == 0) {
            hour = 12; // 0 and 12 should map to 12 in 12-hour format
          }

          String startTime =
              "${monthsInYear[date.month]} ${date.day} $hour:${date.minute.toString().padLeft(2, '0')} $morningOrNight";

          bool doesContain = false;

          for (final ugame in _upcomingGames) {
            if (ugame["id"] == game) doesContain = true;
          }

          for (int index = 0; index < _upcomingGames.length; index++) {
            if (_upcomingGames[index]["id"] == game &&
                tz.TZDateTime.now(Location.getTimeZone()).isAfter(date) &&
                !finishGame) {
              _upcomingGames.remove(_upcomingGames[index]);
              sliderWidget = null;
              await Game.leave(game);
              continue;
            }
          }

          if (doesContain) continue;

          _upcomingGames.add({
            'title': gameInfo["title"],
            'startTime': startTime,
            'id': game,
            'date': date,
            'location': gameInfo["location"],
            'coordinates': gameInfo["coordinates"],
          });
        }

        setState(() {});
      }

      getActiveGames();
      HomePage.timer =
          Timer.periodic(const Duration(milliseconds: 1000), (_) async {
        await getActiveGames();
      });
    } catch (e) {}

    //Cancel timer you navigate away
  }

  void _showFinishGameDialog(BuildContext context) {
    String? result;
    TextEditingController team1Controller = TextEditingController();
    TextEditingController team2Controller = TextEditingController();
    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(
              255, 221, 219, 219), // Set background color to very light grey
          title: Text('Did you win or lose?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: result,
                onChanged: (String? value) {
                  setState(() {
                    result = value;
                  });
                },
                items: <String>['Win', 'Lose'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Result',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: team1Controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Team 1 Score',
                      ),
                    ),
                  ),
                  Text(' - '),
                  Expanded(
                    child: TextField(
                      controller: team2Controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Team 2 Score',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
                finishGame = false;
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Process the result and scores here
                // For now, just print them
                if (result != null) {
                  print('Result: $result');
                  print('Team 1 Score: ${team1Controller.text}');
                  print('Team 2 Score: ${team2Controller.text}');
                }
                // Close the dialog
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StatsPage()));
                finishGame = false;
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3E2F),
      body: Column(
        children: [
          _buildActiveGamesSection(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Active Game Section
                  // Upcoming Games Section
                  _buildUpcomingGamesSection(),
                ],
              ),
            ),
          ),
          // Bottom "PickUP" Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the game creation page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const JoinGamePage()));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  elevation: 5, // Set primary color to transparent
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF80F37F),
                        Color(0xFF80E046)
                      ], // Gradient colors
                      begin: Alignment.topCenter, // Start point of the gradient
                      end: Alignment.bottomCenter, // End point of the gradient
                    ),
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 67),
                    child: Text(
                      'PickUP',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActiveGamesSection() {
    if (_activeGames.isEmpty) {
      // Display message if there are no active games
      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF88F37F),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: const Text(
          'No Active Games',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      // Display the first active game only
      Map<String, dynamic> closestGame = {};

      int differenceInMinutes = -1;

      for (final game in _upcomingGames) {
        if (closestGame.isNotEmpty) {
          if (game["date"].isBefore(closestGame["date"])) closestGame = game;
        } else {
          closestGame = game;
        }
        differenceInMinutes = closestGame["date"]
            .difference(tz.TZDateTime.now(Location.getTimeZone()))
            .inMinutes;
        if (differenceInMinutes <= 15 &&
            differenceInMinutes >= 0 &&
            sliderWidget == null) {
          sliderWidget = Center(
            child: SliderButton(
              action: () async {
                setState(() async {
                  finishGame = true;
                  Navigator.of(context).pushNamed('/DirectionsMap',
                      arguments: game["coordinates"]);

                  /// Do something here OnSlideComplete
                  await Game.checkIn(closestGame["id"]);

                  print(_upcomingGames.length);
                  for (int index = 0; index < _upcomingGames.length; index++) {
                    if (_upcomingGames[index]["id"] == game["id"]) {
                      _upcomingGames.removeAt(index);
                      sliderWidget = null;
                      await Game.leave(closestGame["id"]);
                      break;
                    }
                  }

                  sliderWidget = Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the game creation page
                          _showFinishGameDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Rounded corners
                          ),
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          elevation: 5, // Set primary color to transparent
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF1A3E2F),
                                Color(0xFF1A3E2F)
                              ], // Gradient colors
                              begin: Alignment
                                  .topCenter, // Start point of the gradient
                              end: Alignment
                                  .bottomCenter, // End point of the gradient
                            ),
                            borderRadius:
                                BorderRadius.circular(30), // Rounded corners
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 13, horizontal: 67),
                            child: Text(
                              'Check Out',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
                setState(() {});
              },
              backgroundColor: const Color.fromARGB(255, 19, 189, 7),
              label: const Text(
                "Slide to Check In",
                style: TextStyle(
                  color: Color(0xff4a4a4a),
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
            ),
          );
        }
      }

      if ((differenceInMinutes > 15 || differenceInMinutes <= -1) &&
          !finishGame) sliderWidget = null;

      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF80F37F), Color(0xFF80E046)], // Gradient colors
            begin: Alignment.topCenter, // Start point of the gradient
            end: Alignment.bottomCenter, // End point of the gradient
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${closestGame['title'] ?? "No Active Games"}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              '${closestGame['startTime'] ?? ""}',
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  '${closestGame['location'] ?? ""}',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.access_time, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  differenceInMinutes < 0
                      ? ""
                      : "$differenceInMinutes min till",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // SliderButton for Check In
            sliderWidget ?? Container(),
          ],
        ),
      );
    }
  }

  Widget _buildUpcomingGamesSection() {
    const Color darkGreen = Color(0xFF1A3E2F); // Dark green
    const Color lightGreen = Color(0xFF255035); // Light green
    const double borderRadiusValue = 20.0; // Value for the border radius

    if (_upcomingGames.isEmpty) {
      // Display message if there are no upcoming games
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Text(
          'No Upcoming Games',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                'Your Games',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _upcomingGames.length,
              itemBuilder: (context, index) {
                final game = _upcomingGames[index];
                bool isDarkBackground = index % 2 == 0;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: isDarkBackground ? darkGreen : lightGreen,
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                    border: isDarkBackground
                        ? Border.all(color: Colors.white24, width: 1)
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                    child: ExpansionTile(
                      title: Text(
                        '${game['title'] ?? ""} ${game['startTime'] ?? ""}',
                        style: TextStyle(
                          color: isDarkBackground ? Colors.white : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      children: <Widget>[
                        ListTile(
                          title: Text('View Information',
                              style: TextStyle(
                                  color: isDarkBackground
                                      ? Colors.white
                                      : Colors.white)),
                          trailing: Icon(
                              Icons.info_outline, // Icon for View Information
                              color: isDarkBackground
                                  ? Colors.white
                                  : Colors.white),
                          onTap: () {
                            // Action for viewing game information
                          },
                        ),
                        ListTile(
                          title: Text('Game Chat',
                              style: TextStyle(
                                  color: isDarkBackground
                                      ? Colors.white
                                      : Colors.white)),
                          trailing: Icon(Icons.chat, // Icon for Game Chat
                              color: isDarkBackground
                                  ? Colors.white
                                  : Colors.white),
                          onTap: () {
                            Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    ChatPage(_upcomingGames[index]["id"]),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text('Leave Game',
                              style: TextStyle(
                                  color: isDarkBackground
                                      ? Colors.white
                                      : Colors.white)),
                          trailing: Icon(
                              Icons.exit_to_app, // Icon for Leave Game
                              color: isDarkBackground
                                  ? Colors.white
                                  : Colors.white),
                          onTap: () {
                            Game.leave(_upcomingGames[index]["id"]);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                'Your Games',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _upcomingGames.length,
              itemBuilder: (context, index) {
                final game = _upcomingGames[index];
                Map<String, dynamic> closestGame = {};

                for (final game in _upcomingGames) {
                  if (closestGame.isNotEmpty) {
                    if (game["date"].isBefore(closestGame["date"])) {
                      closestGame = game;
                    }
                  } else {
                    closestGame = game;
                  }
                }

                bool isDarkBackground = closestGame["id"] != game["id"];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: isDarkBackground ? darkGreen : lightGreen,
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                    border: isDarkBackground
                        ? Border.all(color: Colors.white24, width: 1)
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                    child: ExpansionTile(
                      title: Text(
                        '${game['title'] ?? ""} ${game['startTime'] ?? ""}',
                        style: TextStyle(
                          color: isDarkBackground ? Colors.white : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      children: <Widget>[
                        ListTile(
                          title: Text('View Information',
                              style: TextStyle(
                                  color: isDarkBackground
                                      ? Colors.white
                                      : Colors.white)),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: isDarkBackground
                                  ? Colors.white
                                  : Colors.white,
                              size: 16), // Small right arrow
                          onTap: () {
                            // Action for viewing game information
                          },
                        ),
                        ListTile(
                          title: Text('Game Chat',
                              style: TextStyle(
                                  color: isDarkBackground
                                      ? Colors.white
                                      : Colors.white)),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: isDarkBackground
                                  ? Colors.white
                                  : Colors.white,
                              size: 16), // Small right arrow
                          onTap: () {
                            Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    ChatPage(_upcomingGames[index]["id"]),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text('Leave Game',
                              style: TextStyle(
                                  color: isDarkBackground
                                      ? Colors.white
                                      : Colors.white)),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: isDarkBackground
                                  ? Colors.white
                                  : Colors.white,
                              size: 16), // Small right arrow
                          onTap: () {
                            Game.leave(_upcomingGames[index]["id"]);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }
}
