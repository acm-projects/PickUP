// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';




class createVolleyballGame extends StatelessWidget {
  const createVolleyballGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create a Game'),
          titleTextStyle: const TextStyle(color: Colors.black, fontFamily: 'League', fontWeight: FontWeight.bold, fontSize: 24),
           leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Navigates back to the previous screen
            },
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF80E046), // Green color #80E046
                  Color(0xFF88F37F), // Green color #88F37F
                ],
              ),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          color: const Color(0xFF0C2219),
          child: Column(
            children: <Widget>[
               const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white, fontFamily: 'LeagueSpartan', fontSize: 22.0,fontWeight: FontWeight.w900,),
                  hintText: 'What would you like to name your game?',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              
              
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white, fontFamily: 'LeagueSpartan', fontSize: 22.0,fontWeight: FontWeight.w900,),
                  hintText: 'Additional Comments',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              Align(
  //alignment: Alignment.b,
  child: Padding(
    padding: const EdgeInsets.all(20.0), // Adds padding around the button for better positioning
    child: TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0), // Retains the rounded corners
        ),
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 30),
        backgroundColor: Colors.transparent,
        // The background is transparent to maintain the gradient effect from the container
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/chooseLocation');
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF80E046), // Green color
              Color(0xFF88F37F), // Green color
            ],
          ),
          borderRadius: BorderRadius.circular(18.0), // Applies rounded corners to the container
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20), // Adjust padding to fit the text
        child: Text(
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green[900],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home', // 'label' is the correct property, not a Text widget
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.white),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            label: 'Profile',
          ),
        ],
      ),
    )
    );
    
  }
}
