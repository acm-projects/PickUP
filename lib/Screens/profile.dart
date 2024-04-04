import 'package:flutter/material.dart';
import 'reset_password.dart';
import 'stats.dart';
import 'start_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'Ronaldo'; // Initial username

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A3E2F), // Background color
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF88F37F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Center(
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
                SizedBox(width: 40), // Adjust spacing as needed
              ],
            ),
          ),
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
                            'ronaldo@example.com', // Replace with user's email
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResetPass()),
              );
            } else if (title == 'Log Out') {
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

    _getImage() async {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    }

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
                ElevatedButton(
                  onPressed: _getImage,
                  child: Text('Select Profile Photo'),
                ),
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
