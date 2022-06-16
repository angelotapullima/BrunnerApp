import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Empresa/sede_model.dart';
import 'package:sqflite/sqlite_api.dart';

class SedeDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarSede(SedeModel sede) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Sede',
        sede.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<SedeModel>> getSedes() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<SedeModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Sede");

      if (maps.isNotEmpty) list = SedeModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }
}
