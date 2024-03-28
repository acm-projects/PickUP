import 'package:flutter/material.dart';
import 'package:pickup/Pages/creategame.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Pick Up!'),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateGame()),
            );
          },
        ),
      ),
    );
  }
}
