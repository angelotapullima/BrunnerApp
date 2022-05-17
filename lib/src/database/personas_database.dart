import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/personas_model.dart';
import 'package:sqflite/sqlite_api.dart';

class PersonasDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarPerson(PersonasModel person) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Personas',
        person.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<PersonasModel>> getPersonas() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<PersonasModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Personas");

      if (maps.isNotEmpty) list = PersonasModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<PersonasModel>> getPersonasByQuery(String query) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<PersonasModel> list = [];
      List<Map> maps = await db
          .rawQuery("SELECT * FROM Personas WHERE nombrePerson LIKE '%$query%' OR dniPerson LIKE '%$query%' ORDER BY CAST(idPerson AS INTEGER)");

      if (maps.isNotEmpty) list = PersonasModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteChoferes() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Personas");

    return res;
  }
}
