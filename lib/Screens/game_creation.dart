import 'package:flutter/material.dart';

class GameCreationPage extends StatelessWidget {
  const GameCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Creation'),
      ),
      body: const Center(
        child: Text('This is a placeholder for the Game Creation page.'),
      ),
    );
  }
}
