import 'package:flutter/material.dart';
import 'package:pickup/classes/game.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:pickup/classes/location.dart';

class GameCreation extends StatelessWidget {
  const GameCreation({Key? key});

  @override
  Widget build(BuildContext context) {
    // Gradient used for AppBar and buttons
    final LinearGradient appBarGradient = LinearGradient(
      colors: [Color(0xFF80F37F), Color(0xFF80E046)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF1A3E2F),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(20),  // Reduced height of the AppBar
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Stack(
              fit: StackFit.expand,
              children: [
                Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF80F37F), Color(0xFF80E046)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                Positioned(
                  top: 15,  // Adjust the top value to move it upwards as needed
                  left: 5,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.only(left: 48),  // Adjust based on IconButton's size
                    alignment: Alignment.center,
                    child: Text(
                      'Choose a Game Type',
                     style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,  // Adjust the top value to move the button upwards as needed
                  left: 4,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
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
              const SizedBox(
                  height: 65), // Additional space at the top of the column
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  gradientButton("Volleyball", Icons.sports_volleyball, context,
                      appBarGradient),
                  gradientButton("Basketball", Icons.sports_basketball, context,
                      appBarGradient),
                ],
              ),
              const SizedBox(height: 30), // Spacing between rows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  gradientButton(
                      "Soccer", Icons.sports_soccer, context, appBarGradient),
                  gradientButton(
                      "Tennis", Icons.sports_tennis, context, appBarGradient),
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
    Widget iconWidget;

    if (text == "Soccer") {
      // Use an image for the soccer button
      iconWidget = Image.asset(
        'assets/soccer-ball (1).png',
        width: 100,
        height: 100,
        color: Colors.black,
      );
    } else {
      // Use the default icon for other buttons
      iconWidget = Icon(icon, color: Colors.black, size: 80);
    }

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
            iconWidget,
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Mada',
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
