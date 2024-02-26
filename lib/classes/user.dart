import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class User {
  String firstName;
  String lastName;
  String email;
  DateTime birthday;

  User(this.firstName, this.lastName, this.email, this.birthday);

  //Go into User Database, and add a game
  Future createUser({required String name}) async {
    final docUser = FirebaseFirestore.instance.collection('User').doc('my-id');

    final user = {'name': name, 'age': 21, 'birthday:': DateTime(2001, 7, 28)};

    await docUser.set(user);
  }

  static Future<Map<String, dynamic>> readFromLocalJsonFile() async {
    String jsonData = await rootBundle.loadString('assets/local.json');
    Map<String, dynamic> data = jsonDecode(jsonData);
    return data;
  }
}