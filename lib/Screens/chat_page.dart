import 'package:flutter/material.dart';





class chatPage extends StatelessWidget {
  const chatPage({super.key});

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
          title: const Text('Chat'),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontFamily: 'Mada',
            fontWeight: FontWeight.bold,
            
            fontSize: 24,
          ),
          backgroundColor: Colors.transparent, // Make AppBar background transparent
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
