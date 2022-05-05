import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static void saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {}
  }

  static Future<dynamic> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic obj = prefs.get(key);
    return obj;
  }

  static Future<bool> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<bool> deleteAllData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  // clearPreferences() async {
  //   final prefs = Preferences();
  // }

  // get idUser {
  //   return _prefs!.getString('id_user');
  // }

  // set idUsers(String value) {
  //   _prefs!.setString('id_user', value);
  // }

  // get idPerson {
  //   _prefs!.getString('id_person');
  // }

  // set idPersons(String value) {
  //   _prefs!.setString('id_person', value);
  // }

  // get userNickname {
  //   return _prefs!.getString('user_nickname');
  // }

  // set userNicknames(String value) {
  //   _prefs!.setString('user_nickname', value);
  // }

  // get userEmail {
  //   return _prefs!.getString('user_email');
  // }

  // set userEmails(String value) {
  //   _prefs!.setString('user_email', value);
  // }

  // get image {
  //   return _prefs?.getString('image');
  // }

  // set images(String value) {
  //   _prefs!.setString('image', value);
  // }

  // get personName {
  //   return _prefs!.getString('person_name');
  // }

  // set personNames(String value) {
  //   _prefs!.setString('person_name', value);
  // }

  // get personSurname {
  //   return _prefs!.getString('person_surname');
  // }

  // set personSurnames(String value) {
  //   _prefs!.setString('person_surname', value);
  // }

  // get rolNombre {
  //   return _prefs?.getString('rol_nombre');
  // }

  // set rolNombres(String value) {
  //   _prefs!.setString('rol_nombre', value);
  // }

  // get idRol {
  //   return _prefs!.getString('id_rol');
  // }

  // set idRols(String value) {
  //   _prefs!.setString('id_rol', value);
  // }

  // //Null check
  // get token {
  //   return _prefs?.getString('token');
  // }

  // set tokens(String value) {
  //   _prefs!.setString('token', value);
  // }
}
