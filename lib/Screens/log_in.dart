import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:pickup/main.dart'; // Ensure this import is correct and necessary

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  // Consider uncommenting these if you need to use them
  // final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();

  void _login() {
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
            SizedBox(height: MediaQuery.of(context).size.height * 0),
            const SizedBox(height: 10),
            const Text(
              'Welcome Back!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Mada', 
              ),
              textAlign: TextAlign.left,
              
            ),
            const SizedBox(height: 1),
            // Username field
            buildTextFormField(label: 'Username'),
            const SizedBox(height: 1),
            // Password field
            buildTextFormField(label: 'Password', isPassword: true),
            const SizedBox(height: 20),
            // Forgot password button
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  // Navigate to Forgot Password Screen
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Login button with gradient
            buildGradientButton(context, 'Login', _login),
            const SizedBox(height: 20),
            // Sign up button
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/Signup'); // Adjusted for direct navigation without global key
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /*
            Align(
              alignment: Alignment.center,
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcATop,
                ),
                child: Image.network(
                  'https://img.icons8.com/ios11/2x/football2.png',
                  width: 326,
                  height: 196,
                ),
              ),
            ),
            */
          ],
        ),
      ),
    );
  }

  TextFormField buildTextFormField({required String label, bool isPassword = false}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white, fontFamily: 'LeagueSpartan', fontSize: 24.0,),
        hintText: 'Enter your Username', // Use the label as hintText or specify your own hint
      hintStyle: TextStyle(
        color: Colors.white.withOpacity(0.5), // Make hint text slightly transparent
        fontFamily: 'LeagueSpartan',
        
        fontSize: 24.0, // Keep consistent font size with the label and input text
      ),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
      style: const TextStyle(color: Colors.white, fontFamily: 'LeagueSpartan'),
      obscureText: isPassword,
      //controller: isPassword ? _passwordController : _usernameController,
    );
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
}