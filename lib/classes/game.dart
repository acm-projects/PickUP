import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickup/classes/user.dart';
import 'dart:math';

class Game {
  String name;
  String user; //who made the game
  String sport;
  String gameID = generateRandomHex();
  int location;
  int numOfPlayers;
  DateTime timeCreated;
  DateTime startTime;

  Game(this.name, this.user, this.sport, this.location, this.numOfPlayers,
      this.timeCreated, this.startTime, DateTime add);

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'user': user,
      'gameID': gameID,
      'sport': sport,
      'location': location,
      'numOfPlayers': numOfPlayers,
      'timeCreated': timeCreated.toIso8601String(),
      'startTime': startTime.toIso8601String(),
    };
  }

  //Users Can Only Have 5 Active Games at a time
  static Future createGame({required Game game}) async {
    //Instead of example@utdallas.edu we grab the local user id/email
    Map<String, dynamic> localDB = await User.readFromLocalJsonFile();
    String userID = localDB["_localUser"];

    final db = FirebaseFirestore.instance;
    final usersCreatedGames = db
        .collection("Users")
        .doc(userID)
        .collection("ActiveGames")
        .doc(game.gameID);

    Map<String, dynamic> gameJSON = {game.gameID: game.toJSON()};

    DocumentSnapshot docSnapshot = await usersCreatedGames.get();

    if (docSnapshot.exists) {
      // If the document exists in the database, update it
      await usersCreatedGames.update(gameJSON);
    } else {
      // If the document does not exist in the database, create it
      await usersCreatedGames.set(gameJSON);
    }

    //READ GAMES

    /*
    usersCreatedGames.get().then(
          (DocumentSnapshot doc) {
            final data = doc.data() as Map<String, dynamic>;
            print(data);
          },
          onError: (e) => print("Error getting document: $e"),
        );
    */

    //await docUser.set(user);
  }
}

String generateRandomHex() {
  var random = Random.secure();
  var values = List<int>.generate(6, (i) => random.nextInt(256));
  return values.map((e) => e.toRadixString(25).padLeft(2, '0')).join();
}