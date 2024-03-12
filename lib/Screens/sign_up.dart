import 'package:flutter/material.dart';
import 'package:pickup/main.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();

  void _signup() {
    // Implement your login logic
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C2219), // Dark green background
      body: SingleChildScrollView(
        
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.0),
            const Padding( // Add Padding widget to align text
              padding: EdgeInsets.only(left: 5.0), // Adjust the padding as needed
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mada',
                ),
                textAlign: TextAlign.left, // Align text to the left
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              //controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'LeagueSpartan',fontSize: 24.0,),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextFormField(
              //controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'LeagueSpartan',fontSize: 24.0,),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextFormField(
              //controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'UTD Email Address',
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'LeagueSpartan',fontSize: 24.0,),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextFormField(
              //controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'LeagueSpartan',fontSize: 24.0,),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              obscureText: true,
            ),
            const SizedBox(height: 30),


             buildGradientButton(context, 'Create Account',_signup),

            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                 navigatorKey.currentState?.pushNamed('/Login');
              },
              child: const Text(
                'Have an account? Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
            
            const SizedBox(height: 20),

            Align(
            alignment: Alignment.center,
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white, 
                BlendMode.srcATop,
              ),
              child: Image.network(
                'https://cf-00.iconduck.com/assets.00/volleyball-icon-96x96-hgtgwc0y.png',
                width: 96,
                height: 96,
              ),
            ),
          ),
        

                    ],
                  ),
                ),
              );
            }
          }

Widget buildGradientButton(BuildContext context, String text, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF80E046), // Green color #80E046
            Color(0xFF88F37F), // Green color #88F37F
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 28.0, fontFamily: 'LeagueSpartan'),
        ),
      ),
    );
  }