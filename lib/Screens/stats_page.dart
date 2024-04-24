import 'package:flutter/material.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  String selectedSport = 'Basketball';
  List<Map<String, dynamic>> stats = [];

  List<Map<String, dynamic>> basketballStats = [
    {'title': "Ahmed's Basketball Game", 'score': '112-108', 'result': 'Win'},
    {
      'team1': 'Celtics',
      'team2': 'Warriors',
      'score': '98-102',
      'result': 'Loss'
    },
    {'team1': 'Heat', 'team2': 'Knicks', 'score': '109-101', 'result': 'Win'},
    {
      'team1': 'Raptors',
      'team2': 'Clippers',
      'score': '94-96',
      'result': 'Loss'
    },
    {'team1': 'Bucks', 'team2': 'Nets', 'score': '120-115', 'result': 'Win'},
  ];

  List<Map<String, dynamic>> volleyballStats = [
    {'team1': 'Team A', 'team2': 'Team B', 'score': '3-1', 'result': 'Win'},
    {'team1': 'Team C', 'team2': 'Team D', 'score': '2-3', 'result': 'Loss'},
    {'team1': 'Team X', 'team2': 'Team Y', 'score': '3-0', 'result': 'Win'},
    {'team1': 'Team P', 'team2': 'Team Q', 'score': '1-3', 'result': 'Loss'},
    {'team1': 'Team M', 'team2': 'Team N', 'score': '3-2', 'result': 'Win'},
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
    {'team1': 'Arsenal', 'team2': 'Chelsea', 'score': '3-2', 'result': 'Win'},
    {
      'team1': 'Bayern Munich',
      'team2': 'Dortmund',
      'score': '1-1',
      'result': 'Draw'
    },
    {'team1': 'Juventus', 'team2': 'AC Milan', 'score': '2-0', 'result': 'Win'},
  ];

  List<Map<String, dynamic>> tennisStats = [
    {
      'player1': 'Federer',
      'player2': 'Nadal',
      'score': '6-4, 3-6, 6-3',
      'result': 'Win'
    },
    {
      'player1': 'Djokovic',
      'player2': 'Murray',
      'score': '7-6, 4-6, 6-3',
      'result': 'Win'
    },
    {
      'player1': 'Nadal',
      'player2': 'Djokovic',
      'score': '6-3, 3-6, 7-6',
      'result': 'Win'
    },
    {
      'player1': 'Murray',
      'player2': 'Federer',
      'score': '6-2, 4-6, 6-3',
      'result': 'Win'
    },
    {
      'player1': 'Nadal',
      'player2': 'Federer',
      'score': '6-4, 6-3',
      'result': 'Win'
    },
  ];

  @override
  void initState() {
    super.initState();
    stats = basketballStats;
  }

  int calculateWins(List<Map<String, dynamic>> stats) {
    int wins = 0;
    for (var game in stats) {
      if (game['result'] == 'Win') {
        wins++;
      }
    }
    return wins;
  }

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
      backgroundColor: const Color(0xFF1A3E2F),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
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
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Stats',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 40),
              ],
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.56,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: DropdownButton<String>(
                value: selectedSport,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black, fontSize: 18),
                underline: Container(
                  height: 0,
                  color: Colors.transparent,
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedSport = newValue;
                      if (newValue == 'Basketball') {
                        stats = basketballStats;
                      } else if (newValue == 'Volleyball') {
                        stats = volleyballStats;
                      } else if (newValue == 'Soccer') {
                        stats = soccerStats;
                      } else if (newValue == 'Tennis') {
                        stats = tennisStats;
                      }
                    });
                  }
                },
                items: <String>['Basketball', 'Volleyball', 'Soccer', 'Tennis']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10),
                          if (value == 'Basketball')
                            Icon(Icons.sports_basketball, color: Colors.black),
                          if (value == 'Volleyball')
                            Icon(Icons.sports_volleyball, color: Colors.black),
                          if (value == 'Soccer')
                            Icon(Icons.sports_soccer, color: Colors.black),
                          if (value == 'Tennis')
                            Icon(Icons.sports_tennis, color: Colors.black),
                          SizedBox(width: 10),
                          Text(value, style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Wins',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${calculateWins(stats)}',
                        style: TextStyle(
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
                  height: 100,
                  color: Colors.white.withOpacity(0.29),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Losses',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${calculateLosses(stats)}',
                        style: TextStyle(
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 2,
                        color: Colors.white.withOpacity(0.29),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Recent Games',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
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
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: stats.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> game = stats[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: index.isEven ? Color(0xFF255035) : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${game['title'] != null ? game['title'] : '${game['team1']} vs ${game['team2']}'}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${game['score']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 60,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: game['result'] == 'Win'
                              ? Colors.green
                              : (game['result'] == 'Loss'
                                  ? Colors.red
                                  : Colors.blue),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          game['result'],
                          style: TextStyle(
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
