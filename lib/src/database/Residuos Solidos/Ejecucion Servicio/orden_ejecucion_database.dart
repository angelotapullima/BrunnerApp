import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/orden_ejecucion_model.dart';
import 'package:sqflite/sqlite_api.dart';

class OrdenEjecucionDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarOE(OrdenEjecucionModel oe) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'OrdenEjecucion',
        oe.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<OrdenEjecucionModel>> getOEByidCliente(String idCliente) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<OrdenEjecucionModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM OrdenEjecucion WHERE idCliente = '$idCliente'");

      if (maps.isNotEmpty) list = OrdenEjecucionModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<OrdenEjecucionModel>> getOEByQuery(String idCliente, String query) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<OrdenEjecucionModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM OrdenEjecucion WHERE idCliente = '$idCliente' AND  numeroOE LIKE '%$query%'");

      if (maps.isNotEmpty) list = OrdenEjecucionModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  delete() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM OrdenEjecucion");

    return res;
  }
}
