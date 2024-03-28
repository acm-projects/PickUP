import 'package:flutter/material.dart';
import 'nav_bar.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
      ),
      body: Center(
        child: Text(
          'This is the Map Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
