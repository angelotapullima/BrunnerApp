import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/personal_oe_model.dart';
import 'package:sqflite/sqlite_api.dart';

class PersonalOEDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarPersonalOE(PersonalOEModel persona) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'PersonalOE',
        persona.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<PersonalOEModel>> getPersonalOEByid(String id) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<PersonalOEModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM PersonalOE WHERE id = '$id'");

      if (maps.isNotEmpty) list = PersonalOEModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<PersonalOEModel>> getPersonalsOEByQuery(String id, String query) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<PersonalOEModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM PersonalOE WHERE id = '$id' AND nombre LIKE '%$query%'");

      if (maps.isNotEmpty) list = PersonalOEModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  delete() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM PersonalOE");

    return res;
  }
}
