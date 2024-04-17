import 'package:flutter/material.dart';
import 'package:pickup/classes/game.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:pickup/classes/location.dart';

class GameCreation extends StatelessWidget {
  const GameCreation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0C2219),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .pop(); // Navigates back to the previous screen
            },
          ),
          title: const Text('Choose a Game Type'),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontFamily: 'Mada',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          backgroundColor:
              Colors.transparent, // Make AppBar background transparent
          elevation: 0, // Removes shadow
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF88F37F), // Same green color for a consistent look
                  Color(0xFF88F37F),
                ],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              // borderRadius: BorderRadius.circular(30), // Rounded corners
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
                      "Volleyball", Icons.sports_volleyball, context),
                  gradientButton(
                      "Basketball", Icons.sports_basketball, context),
                ],
              ),
              const SizedBox(height: 30), // Spacing between rows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  gradientButton("Soccer", Icons.sports_soccer, context),
                  gradientButton("Tennis", Icons.sports_tennis, context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gradientButton(String text, IconData icon, BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 142, 202, 135),
            Color(0xFF88F37F),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: InkWell(
        onTap: () {
          Game.currentGame =
              Game("", "", "", 0, tz.TZDateTime.now(Location.getTimeZone()));
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
                  color: Colors.black,
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
