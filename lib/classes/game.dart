import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickup/classes/user.dart';
import 'dart:math';

class Game {
  String name;
  String user; //who made the game
  String sport;
  String gameID = generateRandomHex();
  int location;
  int numOfPlayers = 0;
  int maxNumOfPlayers;
  DateTime timeCreated;
  DateTime startTime;

  Game(this.name, this.user, this.sport, this.location, this.maxNumOfPlayers,
      this.timeCreated, this.startTime);

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'user': user,
      'gameID': gameID,
      'sport': sport,
      'location': location,
      'numOfPlayers': numOfPlayers,
      'maxNumOfPlayers': maxNumOfPlayers,
      'timeCreated': timeCreated.toIso8601String(),
      'startTime': startTime.toIso8601String(),
    };
  }

  //Create, Users Can Only Have 5 Active Games at a time
  void instantiate() async {
    //Instead of example@utdallas.edu we grab the local user id/email
    final usersCreatedGames = FirebaseFirestore.instance
        .collection("Users")
        .doc(await User.getUserID())
        .collection("ActiveGames")
        .doc(gameID);

    DocumentSnapshot docSnapshot = await usersCreatedGames.get();

    if (docSnapshot.exists) {
      await usersCreatedGames.update({gameID: toJSON()});
    } else {
      await usersCreatedGames.set({gameID: toJSON()});
    }
  }

  //Read
  static Future<Object> fetch([String target = '']) async {
    final usersCreatedGames = FirebaseFirestore.instance
        .collection("Users")
        .doc(await User.getUserID())
        .collection("ActiveGames");
    
    final List<Map<String, dynamic>> activeGamesData = (await usersCreatedGames.get())
      .docs
      .map((doc) => doc.data())
      .toList();

    if (target.isEmpty) return activeGamesData;

    for (final entry in activeGamesData) {
      if (entry[target] != null) return entry[target];
    }

    return false;
  }

  //Update
  static Future<void> edit(String target, Map<String,dynamic> doc) async {
    DocumentReference targetGame = FirebaseFirestore.instance
        .collection("Users")
        .doc(await User.getUserID())
        .collection("ActiveGames")
        .doc(target);

        //Check if doc exists
    if ((await targetGame.get()).exists) {
      await targetGame.set(doc);
    } else {
      print(target + " doesn't exists");
    }
  }

  //Destroy
  static Future<void> delete(String target) async {
    DocumentReference targetGame = FirebaseFirestore.instance
        .collection("Users")
        .doc(await User.getUserID())
        .collection("ActiveGames")
        .doc(target);
    
    //Check if doc exists
    if ((await targetGame.get()).exists) {
      await targetGame.delete();
    } else {
      print(target + " doesn't exists");
    }
  }

  static Future<Game?> firestoreToGame(String target) async {
    try {
      Map<String, dynamic> jsonData = await fetch(target) as Map<String, dynamic>;

      return Game(
        jsonData["name"], 
        jsonData["user"], 
        jsonData["sport"],
        jsonData["location"],
        jsonData["maxNumOfPlayers"],
        DateTime.parse(jsonData["timeCreated"]),
        DateTime.parse(jsonData["startTime"]));
    } catch(e) {
      print('Error: $e'); //Typically while fetching, if fetch == false
    }  

    return null;
  }
}

String generateRandomHex() {
  var random = Random.secure();
  var values = List<int>.generate(6, (i) => random.nextInt(256));
  return values.map((e) => e.toRadixString(25).padLeft(2, '0')).join();
}
