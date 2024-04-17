import 'package:flutter/material.dart';
import 'start_screen.dart';
import 'dart:io';
import '../classes/user.dart';

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
      backgroundColor: const Color(0xFF0C2219), // Background color
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF88F37F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: const Center(
              // Center the row
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  SizedBox(width: 0), // Adjust spacing as needed
                ],
              ),
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
                      const SizedBox(width: 20),
                      // Name and Email
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName, // Display the updated username
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
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
                  const SizedBox(height: 20),
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
          onTap: () async {
            if (title == 'Reset Password') {
              print("reset pw");
            } else if (title == 'Log Out') {
              await User.logOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const StartScreen()),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (icon != null)
                Icon(
                  icon,
                  color: Colors.white,
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Divider(
          color: Colors.white,
          thickness: 1,
        ),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    File? image; // Variable to hold the selected image
    /*
    getImage() async {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    }*/
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text field for entering the name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter name here',
                  ),
                ),
                const SizedBox(height: 20),
                // Button for selecting a profile photo
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Select Profile Photo'),
                ),
                const SizedBox(height: 20),
                // Display the selected image
                image != null ? Image.file(image) : const SizedBox(),
                const SizedBox(height: 20),
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
                  child: const Text('Update Profile'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
