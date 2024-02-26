import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Let's Make a Game!"),
      ),
      body: const Center(
        child: Text('Welcome to the Second Page!'),
      ),
    );
  }
}