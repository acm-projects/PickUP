import 'package:flutter/material.dart';
import 'stats_page.dart';
import 'start_screen.dart';
import 'package:pickup/classes/user.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'Ronaldo'; // Initial username

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A3E2F), // Background color
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
                      'Profile',
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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Profile Picture
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/ronaldo.jpeg', // Replace with user's profile picture URL
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      // Name and Email
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName, // Display the updated username
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'ronaldo@utdallas.edu', // Replace with user's email
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Options
                  buildOptionRow(context, 'Stats', Icons.arrow_forward),
                  buildOptionRow(context, 'Edit Profile', Icons.arrow_forward),
                  buildOptionRow(
                      context, 'Reset Password', Icons.arrow_forward),
                  buildOptionRow(
                      context, 'Log Out', null), // No arrow for log out
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionRow(BuildContext context, String title, IconData? icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (title == 'Stats') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatsPage()),
              );
            } else if (title == 'Reset Password') {
            } else if (title == 'Log Out') {
              User.logOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => StartScreen()),
                (route) => false,
              );
            } else {
              _showEditProfileDialog(context);
            }
          },
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              if (icon != null)
                Icon(
                  icon,
                  color: Colors.white,
                ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Divider(
          color: Colors.white,
          thickness: 1,
        ),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    File? _image; // Variable to hold the selected image

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text field for entering the name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Enter name here',
                  ),
                ),
                SizedBox(height: 20),
                // Button for selecting a profile photo

                SizedBox(height: 20),
                // Display the selected image
                _image != null ? Image.file(_image!) : SizedBox(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Update the username and profile photo when the button is pressed
                    setState(() {
                      userName = nameController.text;
                      // Handle updating the profile photo here
                      // You can save the _image file path or upload it to a server
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Update Profile'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
