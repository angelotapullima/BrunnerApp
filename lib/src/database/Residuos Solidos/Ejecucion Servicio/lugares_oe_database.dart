import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/lugares_oe_model.dart';
import 'package:sqflite/sqlite_api.dart';

class LugaresOEDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarLugarOE(LugaresOEModel lugar) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'LugaresOE',
        lugar.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<LugaresOEModel>> getLugaresOEByidPeriodo(String idPeriodo) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<LugaresOEModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM LugaresOE WHERE idPeriodo = '$idPeriodo'");

      if (maps.isNotEmpty) list = LugaresOEModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  delete() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM LugaresOE");

    return res;
  }
}
