import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/choferes_model.dart';
import 'package:sqflite/sqlite_api.dart';

class ChoferesDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarChofer(ChoferesModel chofer) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Choferes',
        chofer.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<ChoferesModel>> getChoferes() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ChoferesModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Choferes");

      if (maps.isNotEmpty) list = ChoferesModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<ChoferesModel>> getChoferesByQuery(String query) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ChoferesModel> list = [];
      List<Map> maps = await db
          .rawQuery("SELECT * FROM Choferes WHERE nombreChofer LIKE '%$query%' OR dniChofer LIKE '%$query%' ORDER BY CAST(idChofer AS INTEGER)");

      if (maps.isNotEmpty) list = ChoferesModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteChoferes() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Choferes");

    return res;
  }
}
