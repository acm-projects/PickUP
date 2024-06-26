import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickup/classes/notification.dart';
import 'package:pickup/classes/user.dart';
import 'package:pickup/classes/location.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:math';

// google maps api, calendar.

// Every error that is caught must be transformed into a emessage popup

// Add templates

// On game join make a local noti for the games creation time.
// Remove notis when deleted.
// Delete all joined users noti when organizer destroys the game

// Users can check in within 15 minutes of startTime

Map<String, dynamic> emptyMap = {};

class Game {
  String title;
  String sport;
  String description;
  String location = "";
  int numOfPlayers = 0;
  int maxNumOfPlayers = 0;

  tz.TZDateTime startTime;
  List<String> players = []; // User IDs
  Map<String, dynamic> coordinates = Location.get(); //assume at the current pos

  static Game currentGame =
      Game("", "", "", tz.TZDateTime.now(Location.getTimeZone()));

  final String _gameID = generateRandomHex();

  // Constructor
  Game(this.title, this.sport, this.description, this.startTime);

  Future<Map<String, dynamic>> toMap() async {
    return {
      'title': title,
      'organizer': await User.getUserID(),
      'gameID': _gameID,
      'sport': sport,
      'description': description,
      'players': players,
      'coordinates': coordinates,
      'location': location,
      'numOfPlayers': numOfPlayers,
      'maxNumOfPlayers': maxNumOfPlayers,
      'timeCreated': DateTime.now(),
      'startTime': startTime.toIso8601String(),
      'checkedIn': [],
      'chat': [],
    };
  }

  // Accessors (Getters)
  String get gameID => _gameID;

  Future<void> updateGame() async {
    //Before any action is taken the values must be updated
  }

  // Create
  Future<void> instantiate() async {
    print("Instantiating $_gameID");
    CollectionReference usersActiveGames = FirebaseFirestore.instance
        .collection("Users")
        .doc(await User.getUserID())
        .collection("ActiveGames");

    final globablTargetGame =
        FirebaseFirestore.instance.collection("ActiveGames").doc(_gameID);

    final usersTargetGame = usersActiveGames.doc(_gameID);

    DocumentSnapshot globablTargetGameSS = await globablTargetGame.get();

    if ((await usersActiveGames.get()).docs.length >= 10) {
      throw 'You have reached the limit of games you can make';
    }

    if (globablTargetGameSS.exists) {
      //Prompt User to delete Games or become an official organizer
      await globablTargetGame.update(await toMap());
      await usersTargetGame.update(emptyMap);
    } else {
      await globablTargetGame.set(await toMap());
      await usersTargetGame.set(emptyMap);
    }

    await Game.join(_gameID);
  }

  static Future<Object?> getGameLocation(String target) async {
    CollectionReference activeGamesColl =
        FirebaseFirestore.instance.collection("ActiveGames");

    final DocumentReference targetGameDoc = activeGamesColl.doc(target);

    final targetGame = await targetGameDoc.get();

    print((targetGame as Map<String, dynamic>)['location']);
    return null;
  }

  // Read
  static Future<Object?> fetch([String target = '']) async {
    //print("Fetching $target");
    CollectionReference activeGamesColl =
        FirebaseFirestore.instance.collection("ActiveGames");

    if (target.isNotEmpty) {
      try {
        final DocumentReference targetGameDoc = activeGamesColl.doc(target);

        final targetGame = await targetGameDoc.get();

        return targetGame.data();
      } catch (e) {
        return false;
      }
    }

    final QuerySnapshot activeGames = await activeGamesColl.get();

    final activeGamesData =
        activeGames.docs.map((e) => e.data() as Map<String, dynamic>).toList();

    return activeGamesData;
  }

  // Update
  static Future<void> edit(String target, Map<String, dynamic> doc,
      [bool override = false]) async {
    print("Editing $target");

    final DocumentReference targetGameDoc =
        FirebaseFirestore.instance.collection("ActiveGames").doc(target);

    final targetGame = await targetGameDoc.get();

    if (!targetGame.exists) throw "$target doesn't exist.";

    if ((targetGame.data() as Map<String, dynamic>)["organizer"] !=
            await User.getUserID() &&
        !override) {
      throw "You're not $target's owner!";
    }

    await targetGameDoc.set(doc);
  }

  // Destroy
  static Future<void> delete(String target, [bool? user]) async {
    print("Deleting $target");
    try {
      final DocumentReference targetGameDoc =
          FirebaseFirestore.instance.collection("ActiveGames").doc(target);

      final DocumentReference usersActiveGame = FirebaseFirestore.instance
          .collection("Users")
          .doc(await User.getUserID())
          .collection("ActiveGames")
          .doc(target);

      final targetGame = await targetGameDoc.get();

      if (!targetGame.exists) throw "$target doesn't exist.";

      if ((targetGame.data() as Map<String, dynamic>)["organizer"] !=
          await User.getUserID()) {
        throw "You're not $target's owner!";
      }

      for (String user
          in (targetGame.data() as Map<String, dynamic>)["players"]) {
        await Game.leave(target, user);
      }
      print(targetGameDoc);
      await targetGameDoc.delete();
      await usersActiveGame.delete();
    } catch (e) {
      print(e);
    }
  }

  // Game Access - Join
  static Future<void> join(String target) async {
    print("Joining $target");
    CollectionReference usersJoinedGames = FirebaseFirestore.instance
        .collection("Users")
        .doc(await User.getUserID())
        .collection("JoinedGames");

    try {
      Map<String, dynamic> targetGame =
          await Game.fetch(target) as Map<String, dynamic>;

      DocumentReference targetGameDoc = usersJoinedGames.doc(target);

      if ((await targetGameDoc.get()).exists) {
        throw "You Have Already Joined This Game";
      }

      await targetGameDoc.set(emptyMap);

      targetGame["players"].add(await User.getUserID());
      targetGame["numOfPlayers"] = targetGame["players"].length;

      await Game.edit(target, targetGame, true);

      String targetGameSport = targetGame["sport"];

      print("Adding Notification");

      LocalNotification.scheduleNotification(
          id: 0,
          title: 'Your $targetGameSport Game is Starting in 15 minutes!',
          body: "Ready to Check In? ",
          payload: "payload", //just the homepage so they can checkin
          scheduledTime: tz.TZDateTime.parse(
                  Location.getTimeZone(), targetGame["startTime"])
              .subtract(const Duration(minutes: 15)));
    } catch (e) {
      print(e);
    }
  }

  // Game Access - Leave
  static Future<void> leave(String target, [String? user]) async {
    print('Leaving $target');
    // Check if owner and if amount of players is greate than half then don't delete otherwise delete game
    CollectionReference usersJoinedGames = FirebaseFirestore.instance
        .collection("Users")
        .doc(await User.getUserID())
        .collection("JoinedGames");

    usersJoinedGames.doc(target).delete();

    try {
      Map<String, dynamic> targetGame =
          await Game.fetch(target) as Map<String, dynamic>;

      if (!targetGame["players"].contains(await User.getUserID())) {
        throw "You Are Not In This Game"; // Button Shouldn't be clickable
      }

      targetGame["players"].remove(await User.getUserID());
      targetGame["numOfPlayers"] = targetGame["players"].length;

      // Handle Game Ownership if Organizer leaves
      await Game.edit(target, targetGame);

      if (targetGame["numOfPlayers"] == 0) {
        // Prompt the User that leaving will delete the game
        await Game.delete(target);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> checkIn(String target) async {
    print('Checking In ${await User.getUserID()}');

    Map<String, dynamic> game =
        await Game.fetch(target) as Map<String, dynamic>;

    print(game);

    game["checkedIn"].add((await User.getUserID())!);
    print(target);

    await Game.edit(target, game);
  }

  static Future<void> message(String target, String msg) async {
    Map<String, dynamic> doc = await Game.fetch(target) as Map<String, dynamic>;

    Map<String, dynamic> package = {
      "message": "${await User.getFirstName()} ~ $msg",
      "user": await User.getUserID(),
      "time": DateTime.now().toIso8601String()
    };

    (doc["chat"] as List<dynamic>).add(package);

    await edit(target, doc, true);
  }

  static Future<List<Map<String, dynamic>>> search(
      String target, Map<String, dynamic> attributes) async {
    //sport, title, startTime, gameID

    List<Object?> games = await Game.fetch(target) as List<Object?>;

    List<Map<String, dynamic>> matches = [];

    for (final object in games) {
      Map<String, dynamic> game = object as Map<String, dynamic>;

      if (attributes["title"] == game["title"]) {
        matches.add(game);
      } else if (attributes["sport"] == game["sport"]) {
        matches.add(game);
      } else if (attributes["gameID"] == game["gameID"]) {
        matches.add(game);
      }
    }

    return matches;
  }

  static Future<List<Map<String, dynamic>>> sort(
      String target, String sort) async {
    List<Object?> games = await Game.fetch(target) as List<Object?>;

    List<Map<String, dynamic>> matches = [];

    return matches;
  }

  // Firestore Document => Game
  static Future<Game?> firestoreToGame(String target) async {
    print("Converting $target to a Game object.");
    try {
      Map<String, dynamic> jsonData =
          (await fetch(target)) as Map<String, dynamic>;

      return Game(jsonData["title"], jsonData["sport"], jsonData["description"],
          tz.TZDateTime.parse(Location.getTimeZone(), jsonData["startTime"]));
    } catch (e) {
      print('Error: $e'); // Typically while fetching, if fetch == false
    }

    return null;
  }
}

String generateRandomHex() {
  var random = Random.secure();
  var values = List<int>.generate(9, (i) => random.nextInt(256));
  return values.map((e) => e.toRadixString(25).padLeft(2, '0')).join();
}
