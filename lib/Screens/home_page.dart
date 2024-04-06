import 'package:flutter/material.dart';
import 'game_creation.dart';
import 'nav_bar.dart';

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
            const SizedBox(height: 143),
            // Bottom "PickUP" Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 68),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the game creation page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameCreationPage(),
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
            // Check In Button with Drop Shadow
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Handle check-in functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(
                    255,
                    20,
                    157,
                    57,
                  ), // Green color for contrast
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'Check In',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
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
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Text(
          'No Upcoming Games',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      );
    } else {
      // Display each upcoming game
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your Games',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
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
                            textAlign: TextAlign.center,
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
