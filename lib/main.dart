import 'package:pickup/Pages/loginPage.dart';
import 'package:pickup/Pages/creategame.dart';
import 'package:pickup/Pages/calendar.dart';
import 'package:pickup/Pages/home.dart';
import 'package:pickup/Screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pickup/Pages/signup.dart';
import 'package:pickup/classes/notification.dart';
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

  runApp(const MaterialApp(home: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/login/home': (context) => const HomePage(),
        '/login/home/create': (context) => const CreateGame(),
        '/login/home/create/calendar': (context) => const Calendar(),
        //'/login/home/create/calendar/location': (context) => const Map(),
      },
    );
  }
}
