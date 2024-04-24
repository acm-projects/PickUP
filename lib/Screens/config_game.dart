import 'package:flutter/material.dart';
import 'package:pickup/classes/game.dart';
import 'package:pickup/classes/user.dart';
class ConfigureGame extends StatelessWidget {
  const ConfigureGame({super.key});
  
  @override
  Widget build(BuildContext context) {
    final String? sport = ModalRoute.of(context)?.settings.arguments as String?;
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    titleController.text = "${User.firstName}'s $sport Game";
    const Map<String, int> maxPlayersPerSport = {
      'Basketball': 12,
      'Volleyball': 12,
      'Soccer': 22,
      'Tennis': 4,
     
    };
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
                      'Create a $sport Game',
                     style: TextStyle(
                          fontSize: 22,
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
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
                      Game.currentGame.title = titleController.text;
                      Game.currentGame.description = descriptionController.text;
                      Game.currentGame.location = locationController.text;
                      Game.currentGame.maxNumOfPlayers = maxPlayersPerSport[sport]!;
                      Navigator.of(context).pushNamed('/ChooseTime');
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
                          vertical: 10.0, horizontal: 20),
                      child: const Text(
                        'Next',
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
          ),
        );
      
    
    
  }
}