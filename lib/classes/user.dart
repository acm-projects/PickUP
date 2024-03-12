import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const SECURE_STORAGE = FlutterSecureStorage();

//Note: Integrate createUser w Login
//When user creates an account save it in secureStorage -
//And add it to the db
//On app open check secureStorage, if user and pw is present then log them into the db -
//and give them read/write access

class User {
  String firstName;
  String lastName;
  String email;
  DateTime birthday;

  User(this.firstName, this.lastName, this.email, this.birthday);

  //Go into User Database, and add a game
  static Future<void> createUser(String name, String password) async {
    final docUser = FirebaseFirestore.instance.collection('Users').doc(name);

    print("Creating User");

    final user = {'name': name, 'age': 21, 'birthday:': DateTime(2001, 7, 28)};

    await SECURE_STORAGE.write(key: "user", value: name);

    await SECURE_STORAGE.write(key: "password", value: password);

    await docUser.set(user);
  }

  static Future<String> getUserID() async {
    final userID = await SECURE_STORAGE.read(key: 'user');

    return userID!;
  }

  static Future<String> getPassword() async {
    final pass = await SECURE_STORAGE.read(key: 'password');

    return pass!;
  }

  //delete from SS: await secureStorage.delete(key: 'token');
}
