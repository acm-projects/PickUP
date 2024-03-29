import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();

  // You can define your TextEditingController here for each field if needed.
  // TextEditingController _firstNameController = TextEditingController();
  // Add other controllers here

  void _signup() {
    // Implement your signup logic
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
            const Padding(
              padding: EdgeInsets.only(left: 1.0),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mada',
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 10),
            _buildTextFormField(
              label: 'First Name',
              // controller: _firstNameController,
            ),
            _buildTextFormField(
              label: 'Last Name',
              // controller: _lastNameController,
            ),
            _buildTextFormField(
              label: 'UTD Email Address',
              // controller: _emailController,
            ),
            _buildTextFormField(
              label: 'Password',
              isPassword: true,
              // controller: _passwordController,
            ),
            const SizedBox(height: 30),
            buildGradientButton(context, 'Create Account', _signup),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                //navigatorKey.currentState?.pushNamed('/Login');
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

  TextFormField _buildTextFormField({
    required String label,
    bool isPassword = false,
    // TextEditingController? controller,
  }) {
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
      style: const TextStyle(color: Colors.white),
      obscureText: isPassword,
      // controller: controller,
    );
  }
}

Widget buildGradientButton(
    BuildContext context, String text, VoidCallback onPressed) {
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Mada'),
      ),
    ),
  );
}
