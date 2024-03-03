import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickup/classes/user.dart';
import 'package:pickup/classes/location.dart';
import 'dart:math';

// google maps api, calendar.

// Every error that is caught must be transformed into a emessage popup

class Game {
  String name;
  String organizer;
  String sport;
  String description;
  int numOfPlayers = 0;
  DateTime startTime;
  List<String> players = []; // User IDs
  
  final int _maxNumOfPlayers;
  final DateTime _timeCreated = DateTime.now();
  final Location _location;
  final String _gameID = generateRandomHex();
  
  // Constructor
  Game(
    this.name, 
    this.organizer,
    this.sport,
    this.description,
    this._location,
    this._maxNumOfPlayers,
    this.startTime
  );

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'organizer': organizer,
      'gameID': _gameID,
      'sport': sport,
      'description': description,
      'players': players,
      'location': _location.toMap(),
      'numOfPlayers': numOfPlayers,
      'maxNumOfPlayers': _maxNumOfPlayers,
      'timeCreated': _timeCreated.toIso8601String(),
      'startTime': startTime.toIso8601String(),
    };
  }

  // Accessors (Getters)
  String get gameID => _gameID;
  int get maxNumOfPlayers => _maxNumOfPlayers;
  DateTime get timeCreated => _timeCreated;
  Location get location => _location;

  Future<void> updateGame() async {
    //Before any action is taken the values must be updated
  }

  // Create
  Future<void> instantiate() async { print("Instantiating $_gameID");
    CollectionReference usersActiveGames = FirebaseFirestore.instance
        .collection("Users")
        .doc(await User.getUserID())
        .collection("ActiveGames");

    //Prompt User to delete Games or become an official organizer
    if ((usersActiveGames as Map<String, dynamic>).length >= 5) return;

    final targetGame = FirebaseFirestore.instance.collection("ActiveGames").doc(_gameID);

    DocumentSnapshot docSnapshot = await targetGame.get();

    if (docSnapshot.exists) {
      usersActiveGames.doc(_gameID).set({});
      await targetGame.update(toMap());
    } else {
      await targetGame.set(toMap());
    }
  }

  // Read
  static Future<Object?> fetch([String target = '']) async { print("Fetching $target");
    CollectionReference activeGamesColl = FirebaseFirestore.instance.collection("ActiveGames");
      
    if (target.isNotEmpty) {
      try {
        final DocumentReference targetGameDoc = activeGamesColl.doc(target);
        
        final targetGame = await targetGameDoc.get();

        return targetGame.data();
      } catch (e) {
       print(e); 
      } 
    } //Otherwise
    final QuerySnapshot activeGames = await activeGamesColl.get();

    final activeGamesData = activeGames.docs.map((e) => e.data()).toList();

    return activeGamesData;
  }

  // Update
  static Future<void> edit(String target, Map<String, dynamic> doc) async { print("Editing $target");

    try {
      final DocumentReference targetGameDoc = FirebaseFirestore.instance.collection("ActiveGames").doc(target);
    
      final targetGame = await targetGameDoc.get();

      if (!targetGame.exists) throw "$target doesn't exist.";
        
      if ((targetGame.data() as Map<String, dynamic>)["organizer"] != await User.getUserID()) {
        throw "You're not $target's owner!";
      }
      await targetGameDoc.set(doc);
    } catch (e) {
      print(e); 
    }
  }

  // Destroy
  static Future<void> delete(String target, [bool? user]) async { print("Deleting $target");
    try {
      final DocumentReference targetGameDoc = FirebaseFirestore.instance.collection("ActiveGames").doc(target);
    
      final targetGame = await targetGameDoc.get();

      if (!targetGame.exists) throw "$target doesn't exist.";
        
      if ((targetGame.data() as Map<String, dynamic>)["organizer"] != await User.getUserID()) {
        throw "You're not $target's owner!";
      }
      
      await targetGameDoc.delete();
    } catch (e) {
      print(e);
    }
  }

  // Game Access - Join
  static Future<void> join(String target) async { print("Joining $target");
    try {
      Map<String, dynamic> targetGame = await Game.fetch(target) as Map<String, dynamic>;

      if (targetGame["players"].contains(await User.getUserID())) {
        throw "You Have Already Joined This Game";
      }
      
      targetGame["players"].add(await User.getUserID());
      targetGame["numOfPlayers"] = targetGame["players"].length;
      
      await Game.edit(target, targetGame);
    } catch (e) {
      print(e);
    }
  }

  // Game Access - Leave
  static Future<void> leave(String target) async { print('Leaving $target');
    // Check if owner and if amount of players is greate than half then don't delete otherwise delete game
    try {
      Map<String, dynamic> targetGame = await Game.fetch(target) as Map<String, dynamic>;

      if (!targetGame["players"].contains(await User.getUserID())) {
        throw "You Are Not In This Game"; // Button Shouldn't be clickable
      }
      
      targetGame["players"].remove(await User.getUserID());
      targetGame["numOfPlayers"] = targetGame["players"].length;

      // Handle Game Ownership if Organizer leaves

      if (targetGame["numOfPlayers"] == 0) {
        // Prompt the User that leaving will delete the game
        await Game.delete(target);
      } else { 
        await Game.edit(target, targetGame); 
      }
    } catch(e) {
      print(e);
    }
  }  
  
  // Firestore Document => Game
  static Future<Game?> firestoreToGame(String target) async { print("Converting $target to a Game object.");
    try {
      Map<String, dynamic> jsonData = (await fetch(target)) as Map<String, dynamic>;

      return Game(
          jsonData["name"],
          jsonData["organizer"],
          jsonData["sport"],
          jsonData["description"],
          jsonData["location"],
          jsonData["maxNumOfPlayers"],
          DateTime.parse(jsonData["startTime"]));
    } catch (e) {
      print('Error: $e'); // Typically while fetching, if fetch == false
    }

    return null;
  }
}

String generateRandomHex() {
  var random = Random.secure();
  var values = List<int>.generate(6, (i) => random.nextInt(256));
  return values.map((e) => e.toRadixString(25).padLeft(2, '0')).join();
}
