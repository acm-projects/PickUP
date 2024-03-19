import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isDarkModeEnabled = false;
  String _selectedThemeColor = 'Blue';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Stack(
        children: [
          // Settings page overlay
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 200, // Set a fixed width for the settings panel
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SwitchListTile(
                    title: Text('Dark Mode'),
                    value: _isDarkModeEnabled,
                    onChanged: (newValue) {
                      setState(() {
                        _isDarkModeEnabled = newValue;
                      });
                    },
                  ), //Needs to be a checklist
                  SizedBox(height: 10),
                  Text('Preffered Sports'),
                  DropdownButton<String>(
                    value: _selectedThemeColor,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedThemeColor = newValue!;
                      });
                    },
                    items: <String>['Basketball', 'Soccer']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}