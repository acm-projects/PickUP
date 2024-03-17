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
import 'package:pickup/Pages/calendar.dart';
import 'dart:async';

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
    runApp(MaterialApp(home: App()));
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


