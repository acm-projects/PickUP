import 'package:flutter/material.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  String selectedSport = 'Basketball';
  List<Map<String, dynamic>> stats = [];

  List<Map<String, dynamic>> basketballStats = [
    {'team1': 'Lakers', 'team2': 'Bulls', 'score': '112-108', 'result': 'Win'},
    {
      'team1': 'Celtics',
      'team2': 'Warriors',
      'score': '98-102',
      'result': 'Loss'
    },
  ];

  List<Map<String, dynamic>> volleyballStats = [
    {'team1': 'Team A', 'team2': 'Team B', 'score': '3-1', 'result': 'Win'},
    {'team1': 'Team C', 'team2': 'Team D', 'score': '2-3', 'result': 'Loss'},
  ];

  List<Map<String, dynamic>> soccerStats = [
    {
      'team1': 'Real Madrid',
      'team2': 'Barcelona',
      'score': '2-1',
      'result': 'Win'
    },
    {
      'team1': 'Manchester City',
      'team2': 'Liverpool',
      'score': '0-2',
      'result': 'Loss'
    },
  ];

  @override
  void initState() {
    super.initState();
    stats = basketballStats;
  }

  // Function to calculate wins
  int calculateWins(List<Map<String, dynamic>> stats) {
    int wins = 0;
    for (var game in stats) {
      if (game['result'] == 'Win') {
        wins++;
      }
    }
    return wins;
  }

  // Function to calculate losses
  int calculateLosses(List<Map<String, dynamic>> stats) {
    int losses = 0;
    for (var game in stats) {
      if (game['result'] == 'Loss') {
        losses++;
      }
    }
    return losses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C2219),
      appBar: AppBar(
        title: const Text('Stats'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'Mada',
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pop(); // Navigates back to the previous screen
          },
        ),
        backgroundColor:
            Colors.transparent, // Make AppBar background transparent
        elevation: 0, // Removes shadow
        flexibleSpace: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF80F37F), Color(0xFF80E046)], // Gradient colors
              begin: Alignment.topCenter, // Start point of the gradient
              end: Alignment.bottomCenter, // End point of the gradient
            ),
            borderRadius: BorderRadius.circular(30), // Rounded corners
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          // Dropdown button for selecting the sport
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.5, // Adjust the width here
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200], // Light grey background color
                borderRadius: BorderRadius.circular(30),
              ),
              child: DropdownButton<String>(
                value: selectedSport,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black, fontSize: 18),
                underline: Container(
                  height: 0,
                  color: Colors.transparent,
                ),
                onChanged: (String? newValue) {
                  // Update the selected sport when the user makes a selection
                  if (newValue != null) {
                    setState(() {
                      selectedSport = newValue;
                      if (newValue == 'Basketball') {
                        stats = basketballStats;
                      } else if (newValue == 'Volleyball') {
                        stats = volleyballStats;
                      } else if (newValue == 'Soccer') {
                        stats = soccerStats;
                      }
                    });
                  }
                },
                items: <String>['Basketball', 'Volleyball', 'Soccer']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10), // Add left padding here
                          // Display sport icon (you can replace the icons with your own)
                          if (value == 'Basketball')
                            const Icon(Icons.sports_basketball, color: Colors.black),
                          if (value == 'Volleyball')
                            const Icon(Icons.sports_volleyball, color: Colors.black),
                          if (value == 'Soccer')
                            const Icon(Icons.sports_soccer, color: Colors.black),
                          const SizedBox(
                              width: 10), // Add spacing between icon and text
                          Text(value,
                              style: const TextStyle(
                                  color:
                                      Colors.black)), // Adjust the text color
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Wins and Losses Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Wins',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${calculateWins(stats)}', // Calculate wins dynamically
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 2,
                  height: 100, // Adjust height as needed
                  color: Colors.white.withOpacity(0.29),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Losses',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${calculateLosses(stats)}', // Calculate losses dynamically
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Recent Games Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 2,
                        color: Colors.white.withOpacity(0.29),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Recent Games',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: Colors.white.withOpacity(0.29),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount:
                  stats.length, // Example count, replace with actual data count
              itemBuilder: (context, index) {
                // Example game data, replace with actual game data
                Map<String, dynamic> game = stats[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: index.isEven
                      ? const Color(0xFF255035) // Alternate row color
                      : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${game['team1']} vs ${game['team2']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${game['score']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 60,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: game['result'] == 'Win'
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          game['result'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
