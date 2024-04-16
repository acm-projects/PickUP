import 'package:flutter/material.dart';
import 'choose_gametype.dart';
import 'package:pickup/classes/user.dart';
import 'package:slider_button/slider_button.dart';
import 'package:pickup/classes/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickup/classes/location.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _activeGames = [];
  List<Map<String, dynamic>> _upcomingGames = [];

  Widget? sliderWidget;

  @override
  void initState() {
    super.initState();
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

      for (final game in games) {
        if (game == 'bedrock') continue;
        Map<String, dynamic> gameInfo =
            await Game.fetch(game) as Map<String, dynamic>;
        tz.TZDateTime date =
            tz.TZDateTime.parse(Location.getTimeZone(), gameInfo["startTime"]);
        String morningOrNight = date.hour - 12 >= 0 ? "PM" : "AM";

        final Map<int, String> monthsInYear = {
          1: 'January',
          2: 'February',
          3: 'March',
          4: 'April',
          5: 'May',
          6: 'June',
          7: 'July',
          8: 'August',
          9: 'September',
          10: 'October',
          11: 'November',
          12: 'December',
        };

        String startTime =
            "${monthsInYear[date.month]} ${date.day} ${date.hour % 12}:${date.minute} ${morningOrNight}";

        bool doesContain = false;

        for (final ugame in _upcomingGames) {
          if (ugame["id"] == game) doesContain = true;
        }

        if (tz.TZDateTime.now(Location.getTimeZone()).isAfter(date)) {
          for (int index = 0; index < _upcomingGames.length; index++) {
            if (_upcomingGames[index]["id"] == game) {
              _upcomingGames.remove(_upcomingGames[index]);
            }
          }
          sliderWidget = null;
          await Game.leave(game);
          continue;
        }

        if (doesContain) continue;

        setState(() {
          _upcomingGames.add({
            'title': gameInfo["title"],
            'startTime': startTime,
            'id': game,
            'date': date,
            'location': gameInfo["location"],
          });
        });
      }
    }

    getActiveGames();
    Timer.periodic(const Duration(milliseconds: 3000), (_) async {
      await getActiveGames();
    });
    //Cancel timer you navigate away
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
                      builder: (context) => const GameCreation(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF88F37F), // Light green color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 9, horizontal: 120),
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
          if (closestGame["date"].isBefore(game["date"])) closestGame = game;
        } else {
          closestGame = game;
        }
        differenceInMinutes = closestGame["date"]
            .difference(tz.TZDateTime.now(Location.getTimeZone()))
            .inMinutes;

        print(differenceInMinutes);

        if (differenceInMinutes <= 15 && differenceInMinutes >= 0) {
          sliderWidget = Center(
            child: SliderButton(
              action: () async {
                /// Do something here OnSlideComplete
                await Game.checkIn(closestGame["id"]);
                for (int index = 0; index < _upcomingGames.length; index++) {
                  if (_upcomingGames[index]["id"] == game) {
                    _upcomingGames.remove(_upcomingGames[index]);
                  }
                }
                sliderWidget = null;
                await Game.leave(closestGame["id"]);
                sliderWidget = null;
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
      //MAKE LOCATION NAMED

      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF88F37F),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Active Game',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${closestGame['title'] == null ? "No Active Games" : closestGame['title']}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              '${closestGame['startTime'] == null ? "" : closestGame['startTime']}',
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
                  '${closestGame['location'] == null ? "No Location" : closestGame['location']}',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.access_time, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  '${differenceInMinutes < 0 ? "" : differenceInMinutes.toString() + " min till"}',
                  style: const TextStyle(
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
    if (_upcomingGames.isEmpty) {
      // Display message if there are no upcoming games
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Text(
          'No Upcoming Games',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      // Display each upcoming game
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Your Games',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
              textAlign: TextAlign.center, // Centered text
            ),
            const SizedBox(height: 10),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _upcomingGames.length,
              itemBuilder: (context, index) {
                final game = _upcomingGames[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: index % 2 == 0
                          ? const Color(0xFF255035)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '${game['title'] == null ? "" : game['title']} ${game['startTime'] == null ? "" : game['startTime']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16, // Increased font size
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start, // Left-aligned text
                          ),
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
