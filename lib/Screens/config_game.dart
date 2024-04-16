import 'package:flutter/material.dart';
import 'package:pickup/classes/game.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:pickup/classes/location.dart';

class ConfigureGame extends StatelessWidget {
  const ConfigureGame({super.key});

  @override
  Widget build(BuildContext context) {
    final String? sport = ModalRoute.of(context)?.settings.arguments as String?;

    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController locationController = TextEditingController();

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
        title: Text('Create a $sport Game'),
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
      body: Container(
        padding: const EdgeInsets.all(16.0),
        //color: const Color(0xFF0C2219),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Game Title',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'LeagueSpartan',
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                ),
                hintText: 'What would you like to name your game?',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              controller: titleController,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name of Location',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'LeagueSpartan',
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                ),
                hintText: 'Name the Location or Describe it',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              controller: locationController,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'LeagueSpartan',
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                ),
                hintText: 'Additional Comments',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
            ),
            Align(
              //alignment: Alignment.b,
              child: Padding(
                padding: const EdgeInsets.all(
                    20.0), // Adds padding around the button for better positioning
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          18.0), // Retains the rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 30),
                    backgroundColor: Colors.transparent,
                    // The background is transparent to maintain the gradient effect from the container
                  ),
                  onPressed: () {
                    Game.currentGame = Game("", "", "", 0,
                        tz.TZDateTime.now(Location.getTimeZone()));
                    Game.currentGame.title = titleController.text;
                    Game.currentGame.description = descriptionController.text;
                    Game.currentGame.location = locationController.text;
                    Navigator.of(context).pushNamed('/ChooseTime');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF88F37F),
                          Color(0xFF88F37F),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                          18.0), // Applies rounded corners to the container
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20), // Adjust padding to fit the text
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.black, // Text color
                        fontSize: 20, // Adjust the font size as necessary
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
