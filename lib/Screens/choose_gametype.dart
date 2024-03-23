/*
import 'package:flutter/material.dart';


class GameCreation extends StatelessWidget {
  const GameCreation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0C2219),
        appBar: AppBar(
          title: const Text('Create a Game'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF80E046), // Green color #80E046
                  Color(0xFF88F37F), // Lighter green color #88F37F
                ],
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // First row with two buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Volleyball Button
                  Container(
                    width: 100, // Set your desired width for a square shape
                    height: 100, // Equal height to ensure square shape
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), // Slightly rounded corners
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF80E046), 
                            Color(0xFF88F37F), 
                          ],
                        ),
                      ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/createVolleyballGame");
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Slightly rounded corners
                        ),
                       
                      ),
                      child: const Text("Volleyball"),
                    ),
                  ),
                  // Basketball Button
                  SizedBox(
                    width: 100, // Same width and height for square shape
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/createBasketballGame");
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Slightly rounded corners
                        ),
                        backgroundColor: Colors.red, // Button background color
                      ),
                      child: const Text("Basketball"),
                    ),
                  ),
                ],
              ),
              // Second row with two more buttons
              Padding(
                padding: const EdgeInsets.only(top: 20.0), // Adjust the space as needed
                // Second row with two more buttons
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Football Button
                  SizedBox(
                    width: 100, // Same width and height for square shape
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/createSoccerGame");
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Slightly rounded corners
                        ),
                        backgroundColor: Colors.green, // Button background color
                      ),
                      child: const Text("Soccer"),
                    ),
                  ),
                  // Tennis Button
                  SizedBox(
                    width: 100, // Same width and height for square shape
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/createTennisGame");
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Slightly rounded corners
                        ),
                        backgroundColor: Colors.orange, // Button background color
                      ),
                      child: const Text("Tennis"),
                    ),
                  ),
                ],
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
