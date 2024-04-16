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
  static Future<void> createUser(
      String email, String password, String firstName, String lastName) async {
    final docUser = FirebaseFirestore.instance.collection('Users').doc(email);

    print("Creating User");

    final user = {'firstName': firstName, 'lastName': lastName, 'user': email};

    await SECURE_STORAGE.write(key: "user", value: email);

    await SECURE_STORAGE.write(key: "password", value: password);

    await SECURE_STORAGE.write(key: "firstName", value: firstName);

    await SECURE_STORAGE.write(key: "lastName", value: lastName);

    await docUser.set(user);
  }

  //do not merge this
  static Future<String?> getUserID() async {
    final userID = await SECURE_STORAGE.read(key: 'user');

    return "ios@utdallas.edu";
  }

  static Future<String> getPassword() async {
    final pass = await SECURE_STORAGE.read(key: 'password');

    return pass!;
  }

  static Future<void> logOut() async {
    await SECURE_STORAGE.delete(key: "user");
    await SECURE_STORAGE.delete(key: "password");
  }

  //delete from SS: await secureStorage.delete(key: 'token');
}
