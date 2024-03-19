import 'package:pickup/Pages/loginPage.dart';
import 'package:pickup/Pages/home.dart';
import 'package:pickup/Pages/root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pickup/Pages/signup.dart';
import 'package:pickup/classes/notification.dart';
import 'package:pickup/classes/user.dart' as local_user;
import 'dart:io' show Platform;

void main() async {  
  WidgetsFlutterBinding.ensureInitialized();

  await LocalNotification.init();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyCQL-lqTgbOQhTv8F1Oj1YGsqlDCTb-Za8",
            appId: "1:850087823328:android:49aae45eba0d0b47758d85",
            messagingSenderId: "850087823328",
            projectId: "utdpickup",
          ),
        )
      : await Firebase.initializeApp();

  //Automatic Login else Send to login/signup
  try {
    final String userID = await local_user.User.getUserID();
    final String password = await local_user.User.getPassword();

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: userID,
      password: password,
    );

    runApp(MaterialApp(home: HomePage()));
  } catch (e) {
    print("Account credentials don't match or exist.");
    runApp(MaterialApp(home: LoginPage()));
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Root(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/login/home': (context) => const HomePage(),
      },
    );
  }
}
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