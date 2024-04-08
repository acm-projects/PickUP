import 'package:pickup/Screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/log_in.dart';
import 'Screens/sign_up.dart';
import 'Screens/start_screen.dart';
import 'Screens/choose_gametype.dart';
import 'Screens/config_game.dart';
import 'Screens/choose_location.dart';
import 'Screens/choose_time.dart';
import 'package:pickup/classes/notification.dart';
import 'dart:io' show Platform;

import 'Pages/calendar.dart';

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

  runApp(const PickUpApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class PickUpApp extends StatelessWidget {
  const PickUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Optionally use navigatorKey if you need it for navigating without context.
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/Signup': (context) => const Signup(),
        '/Login': (context) => const Login(),
        '/chooseGameType': (context) => const GameCreation(),
        '/homePage': (context) => const HomePage(),
        '/createVolleyballGame': (context) => const createVolleyballGame(),
        '/createSoccerGame': (context) => const createSoccerGame(),
        '/createTennisGame': (context) => const createTennisGame(),
        '/createBasketballGame': (context) => const createBasketballGame(),
        '/chooseTime': (context) => const ChooseTime(),
        '/chooseLocation': (context) => const chooseLocation(),
        '/chatPage': (context) => const ChatPage(),
      },
    );
  }
}
