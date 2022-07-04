import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Consulta%20Informacion%20OE/oes_model.dart';
import 'package:sqflite/sqlite_api.dart';

class OESDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarOES(OESModel oes) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'OES',
        oes.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<OESModel>> getOESPendientes() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<OESModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM OES");

      if (maps.isNotEmpty) list = OESModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteOES() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM OES");

    return res;
  }
}
