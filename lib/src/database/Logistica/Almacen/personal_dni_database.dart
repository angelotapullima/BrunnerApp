import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/personal_dni_model.dart';

import 'package:sqflite/sqlite_api.dart';

class PersonalDNIDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarPerson(PersonalDNIModel person) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'DNIPersonalAlmacen',
        person.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<PersonalDNIModel>> getPersons() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<PersonalDNIModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM DNIPersonalAlmacen");

      if (maps.isNotEmpty) list = PersonalDNIModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<PersonalDNIModel>> getPersonByQuery(String query) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<PersonalDNIModel> list = [];
      List<Map> maps =
          await db.rawQuery("SELECT * FROM DNIPersonalAlmacen WHERE name LIKE '%$query%' OR surname LIKE '$query%' OR surname2 LIKE '%$query%'");

      if (maps.isNotEmpty) list = PersonalDNIModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deletePersons() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM DNIPersonalAlmacen ");

    return res;
  }
}
