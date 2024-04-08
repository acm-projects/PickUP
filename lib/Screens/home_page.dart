import 'package:flutter/material.dart';
import 'choose_gametype.dart';
import 'package:slider_button/slider_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _activeGames = [];
  List<Map<String, dynamic>> _upcomingGames = [];
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
    _upcomingGames = [
      {
        'teamName1': 'Arsenal',
        'teamName2': 'Liverpool',
        'gameTime': '3:00 PM',
      },
      {
        'teamName1': 'Barcelona',
        'teamName2': 'Real Madrid',
        'gameTime': '5:00 PM',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3E2F),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Active Game Section
            _buildActiveGamesSection(),
            const SizedBox(height: 20),
            // Upcoming Games Section
            _buildUpcomingGamesSection(),
            const SizedBox(height: 125),
            // Bottom "PickUP" Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 68),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the game creation page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameCreation(),
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
                  padding: EdgeInsets.symmetric(vertical: 12),
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
            const SizedBox(height: 20),
          ],
        ),
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
      final Map<String, dynamic> game = _activeGames.first;
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
                  '${game['teamName1']}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'vs',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${game['teamName2']}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              '${game['gameTime']}',
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
                  '${game['location']}',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.access_time, color: Colors.black),
                const SizedBox(width: 5),
                const Text(
                  '5 min before',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // SliderButton for Check In
            Center(
              child: SliderButton(
                action: () async {
                  /// Do something here OnSlideComplete
                  print("complete");
                },
                backgroundColor: Color.fromARGB(255, 19, 189, 7),
                label: const Text(
                  "Slide to Check In",
                  style: TextStyle(
                    color: Color(0xff4a4a4a),
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildUpcomingGamesSection() {
    if (_upcomingGames.isEmpty) {
      // Display message if there are no upcoming games
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
            Text(
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
                            '${game['teamName1']} vs ${game['teamName2']} ${game['gameTime']}',
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
