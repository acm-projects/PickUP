import 'package:flutter/material.dart';
import 'package:pickup/classes/game.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:pickup/classes/location.dart';
import 'dart:async';


class JoinGamePage extends StatefulWidget {
  const JoinGamePage({super.key});

  @override
  JoinGamePageState createState() => JoinGamePageState();
}

class JoinGamePageState extends State<JoinGamePage> {
  @override

  List<Object?> activeGames = [];
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer.periodic(const Duration(milliseconds: 1000), (_) async {
        activeGames = await Game.fetch() as List<Object?>;

        setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3E2F),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF80F37F), Color(0xFF80E046)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Join Game',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            pinned: true,
            floating: false,
            expandedHeight: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              // Mock games
              for (final game in activeGames) 
                _buildGameWidget(context, game as Map<String, dynamic>)
              // Pass context to the method
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildGameWidget(BuildContext context, Map<String, dynamic> game) {
    // Mock data for game
              tz.TZDateTime startTime = tz.TZDateTime.parse(
              Location.getTimeZone(), game["startTime"]);


          String morningOrNight = startTime.hour - 12 >= 0 ? "PM" : "AM";

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

          int hour = startTime.hour % 12;
          if (hour == 0) {
            hour = 12; // 0 and 12 should map to 12 in 12-hour format
          }

          String date =
              "${monthsInYear[startTime.month]} ${startTime.day} $hour:${startTime.minute.toString().padLeft(2, '0')} $morningOrNight";
    String id = game["gameID"];
    String title = game["title"];
    String location = game["location"];
    String players = '${game["numOfPlayers"]} / ${game["maxNumOfPlayers"]}';

    // Add context parameter
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF254E32), // Game widget background color
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  title, // Display team 1
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              id, // Display time
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on,
                    color: Colors.white), // Location icon
                const SizedBox(width: 5),
                Text(
                  location, // Display location
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.person,
                    color: Colors.white), // Player count icon
                const SizedBox(width: 5),
                Text(
                  players, // Display player count
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today,
                    color: Colors.white), // Calendar icon
                const SizedBox(width: 5),
                Text(
                  date, // Display date
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Navigate back to home page when join button is pressed
                await Game.join(id);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF80F37F), Color(0xFF80E046)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 50),
                  alignment: Alignment.center,
                  child: const Text(
                    'Join',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}