/*
import 'package:pickup/Functions/liveMaps.dart';
import 'package:pickup/Pages/loginPage.dart';
import 'package:pickup/Pages/home.dart';
import 'package:pickup/Screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/log_in.dart';
import 'Screens/sign_up.dart';
import 'Screens/choose_gametype.dart'; 
import 'Screens/create_vbgame.dart'; 
import 'Screens/create_scgame.dart'; 
import 'Screens/create_bbgame.dart'; 
import 'Screens/create_tengame.dart'; 
void main() => runApp(const PickUp());

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class PickUp extends StatelessWidget {
  const PickUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/Signup': (context) => const Signup(),
        '/Login': (context) => const Login(),
        '/GameCreation': (context) => const GameCreation(),
        '/createVolleyballGame': (context) => const createVolleyballGame(),
        '/createSoccerGame': (context) => const createSoccerGame(),
        'createSoccerGame': (context) => const createTennisGame(),
        '/createBasketballGame': (context) => const createBasketballGame(),

        '/': (context) => const StartScreen(),
        '/login': (context) => LoginPage(),
        //'/signup': (context) => SignUpPage(),
        //'/login/home': (context) => const HomePage(),
        '/login/liveMap': (context) => LiveMap(),
      },
    );
  }
}
*/

import 'package:pickup/Functions/directionMaps.dart';
import 'package:pickup/Functions/liveMaps.dart';
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
      initialRoute: '/login/home/create/calendar/location', //LIVE MAPS
      routes: {
        '/': (context) => const StartScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/login/home': (context) => const HomePage(),
        '/login/home/create': (context) => const CreateGame(),
        //'/login/home/create/calendar': (context) => const Calendar(),
        '/login/home/create/calendar/location': (context) => LiveMap(),
      },
    );
  }
}
