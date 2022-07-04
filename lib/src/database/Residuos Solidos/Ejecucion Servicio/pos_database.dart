import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Consulta%20Informacion%20OE/pos_model.dart';
import 'package:sqflite/sqlite_api.dart';

class POSDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarPOS(POSModel pos) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'POS',
        pos.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<POSModel>> getPOSPendientes() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<POSModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM POS");

      if (maps.isNotEmpty) list = POSModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deletePOS() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM POS");

    return res;
  }
}
