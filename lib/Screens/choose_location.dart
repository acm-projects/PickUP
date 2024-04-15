import 'package:flutter/material.dart';
import 'package:pickup/classes/game.dart';

// ignore: camel_case_types
class ChooseLocation extends StatelessWidget {
  const ChooseLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0C2219),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Choose a Location'),
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
                  Color(0xFF88F37F),
                  Color(0xFF88F37F),
                ],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              // borderRadius: BorderRadius.circular(30), // Rounded corners
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                  // Your column content here
                  ),
            ),
            Align(
              alignment: Alignment
                  .bottomCenter, // Aligns the button to the bottom center
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 30),
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Game.currentGame.instantiate();
                    //UI pops up that confirms that it was created
                    Navigator.of(context).pushNamed('/Login/HomePage');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF80E046),
                          Color(0xFF88F37F),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 50),
                    child: const Text(
                      'Create Game',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
