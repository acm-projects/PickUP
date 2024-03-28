import 'package:flutter/material.dart';

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
              Navigator.of(context).pop(); // Navigates back to the previous screen
            },
          ),
          title: const Text('Create a Game'),
          titleTextStyle: const TextStyle(color: Colors.black, fontFamily: 'Mada', fontWeight: FontWeight.bold, fontSize: 24),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF80E046), // Green color
                  Color(0xFF88F37F), // Lighter green color
                ],
              ),
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
                  gradientButton("Volleyball", () => Navigator.of(context).pushNamed("/createVolleyballGame")),
                  gradientButton("Basketball", () => Navigator.of(context).pushNamed("/createBasketballGame")),
                ],
              ),
              const SizedBox(height: 30), // Spacing between rows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  gradientButton("Soccer", () => Navigator.of(context).pushNamed("/createSoccerGame")),
                  gradientButton("Tennis", () => Navigator.of(context).pushNamed("/createTennisGame")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gradientButton(String text, VoidCallback onPressed) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF80E046),
            Color(0xFF88F37F),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
        ),
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black, fontFamily: 'Mada', fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
