import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pickup/classes/user.dart' as local_user;

// Ensure this import is correct and necessary

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  // Consider uncommenting these if you need to use them
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<String?> _login(BuildContext context) async {
    try {
      print(_usernameController.text);
      print(_passwordController.text);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );

      Navigator.pushNamed(context, '/Login/HomePage');

      await local_user.User.createUser(
          _usernameController.text, _passwordController.text, "", "");

      setState(() {
        _errorMessage = ''; // Clear any previous error message
      });
      return null;
    } catch (e) {
      print(e);
      setState(() {
        _errorMessage =
            'Incorrect username or password'; // Set the error message
      });

      return e.toString(); // Return error message if unsuccessful
    }
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
            if (_errorMessage
                .isNotEmpty) // Display the error message if not empty
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.center,
            ),
            const SizedBox(height: 15),
            // Login button with gradient
            buildGradientButton(context, 'Login'),
            const SizedBox(height: 20),
            // Sign up button
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      '/Signup'); // Adjusted for direct navigation without global key
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: Colors.white),
                ),
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
               child: Image.asset(
              'assets/beachsoccer.png',
                  width: 1000,
                  height: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildTextFormField(
      {required String label, bool isPassword = false}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'LeagueSpartan',
          fontSize: 22.0,
          fontWeight: FontWeight.w900,
        ),
        hintText: 'Enter your Text',
        hintStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'LeagueSpartan',
          fontSize: 14.0,
        ),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
      ),
      style: const TextStyle(color: Colors.white, fontFamily: 'LeagueSpartan'),
      obscureText: isPassword,
      controller: isPassword ? _passwordController : _usernameController,
    );
  }

  Widget buildGradientButton(BuildContext context, String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
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
        onPressed: () {
          _login(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 100),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 28.0,
              fontFamily: 'Mada',
              fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
