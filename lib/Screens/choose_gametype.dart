import 'package:flutter/material.dart';
import 'package:pickup/classes/game.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:pickup/classes/location.dart';

class GameCreation extends StatelessWidget {
  const GameCreation({Key? key});

  @override
  Widget build(BuildContext context) {
    // Gradient used for AppBar
    final appBarGradient = LinearGradient(
      colors: [
        Color(0xFF80F37F),
        Color(0xFF80E046)
      ], // Original gradient color for AppBar
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    // Color used for buttons
    final buttonColor =    const Color(0xFF254E32); // New color for buttons

    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF1A3E2F),
        appBar: AppBar(
          title: const Text('Choose a Game Type'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontFamily: 'Mada',
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Ink(
            decoration: BoxDecoration(
              gradient: appBarGradient, // Use gradient for AppBar
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
              top: 100), // Increased top padding to move content down
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .start, // Aligning content to the start of the column
            children: <Widget>[
              SizedBox(height: 65), // Additional space at the top of the column
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  gradientButton("Volleyball", Icons.sports_volleyball, context,
                      buttonColor), // Use buttonColor instead of gradient
                  gradientButton("Basketball", Icons.sports_basketball, context,
                      buttonColor), // Use buttonColor instead of gradient
                ],
              ),
              const SizedBox(height: 30), // Spacing between rows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  gradientButton("Soccer", Icons.sports_soccer, context,
                      buttonColor), // Use buttonColor instead of gradient
                  gradientButton("Tennis", Icons.sports_tennis, context,
                      buttonColor), // Use buttonColor instead of gradient
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gradientButton(String text, dynamic icon, BuildContext context, Color color) {
  Widget iconWidget;
  
  if (text == "Soccer") {
    // Use an image for the soccer button
    iconWidget = Image.asset(
      'assets/soccer-ball (1).png',
      width: 100,
      height: 100,
      color: Colors.white,
    );
  } else {
    // Use the default icon for other buttons
    iconWidget = Icon(icon, color: Colors.white, size: 80);
  }

  return Container(
    width: 150,
    height: 150,
    decoration: BoxDecoration(
      color: color,
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
          iconWidget,
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
                color: Colors.white,
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
