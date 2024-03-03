import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const SECURE_STORAGE = FlutterSecureStorage();

//Note: Integrate createUser w Login

class User {
  String firstName;
  String lastName;
  String email;
  DateTime birthday;

  User(this.firstName, this.lastName, this.email, this.birthday);

  //Go into User Database, and add a game
  Future<void> createUser({required String name}) async {
    final docUser = FirebaseFirestore.instance.collection('User').doc('my-id');

    final user = {'name': name, 'age': 21, 'birthday:': DateTime(2001, 7, 28)};

    await SECURE_STORAGE.write(key: "_localUser", value: name);

    await docUser.set(user);
  }

  static Future<String> getUserID() async {
    final userID = await SECURE_STORAGE.read(key: 'token');

    return userID!;
  }

  //delete from SS: await secureStorage.delete(key: 'token');

}
