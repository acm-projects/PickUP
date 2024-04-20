import 'package:flutter/material.dart';
import 'package:pickup/classes/game.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:pickup/classes/location.dart';

class GameCreation extends StatelessWidget {
  const GameCreation({super.key});

  @override
  Widget build(BuildContext context) {
    // Gradient used for AppBar and buttons
    const gradient = LinearGradient(
      colors: [Color(0xFF80F37F), Color(0xFF80E046)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0C2219),
        appBar: AppBar(
          title: const Text('Choose a Game Type'),
          centerTitle: true, // Centering the title
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontFamily: 'Mada',
            fontWeight: FontWeight
                .bold, // Adjust weight if needed, e.g., to FontWeight.w800 or FontWeight.bold for more emphasis
            fontSize: 28,
          ),
          backgroundColor:
              Colors.transparent, // Make AppBar background transparent
          elevation: 0, // Removes shadow
          flexibleSpace: Ink(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(30), // Rounded corners
            ),
          ),
        ),
        
        body: Center(
          
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  gradientButton(
                      "Volleyball", Icons.sports_volleyball, context, gradient),
                  gradientButton(
                      "Basketball", Icons.sports_basketball, context, gradient),
                ],
              ),
              const SizedBox(height: 30), // Spacing between rows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  gradientButton(
                      "Soccer", Icons.sports_soccer, context, gradient),
                  gradientButton(
                      "Tennis", Icons.sports_tennis, context, gradient),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gradientButton(String text, IconData icon, BuildContext context,
      LinearGradient gradient) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: InkWell(
        onTap: () {
          Game.currentGame =
              Game("", "", "", tz.TZDateTime.now(Location.getTimeZone()));
          Game.currentGame.sport = text;
          Navigator.of(context).pushNamed('/ConfigureGame', arguments: text);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.black, size: 80), // Icon
            const SizedBox(height: 10), // Space between icon and text
            Text(
              text,
              style: const TextStyle(
                  color: Colors.black, // Ensuring text color is white
                  fontFamily: 'Mada',
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
