import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/unidades_oe_model.dart';
import 'package:sqflite/sqlite_api.dart';

class UnidadesOEDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarUnidadOE(UnidadesOEModel unidad) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'UnidadesOE',
        unidad.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<UnidadesOEModel>> getUnidadesOEByid(String id) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<UnidadesOEModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM UnidadesOE WHERE id = '$id'");

      if (maps.isNotEmpty) list = UnidadesOEModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<UnidadesOEModel>> getUnidadesOEByQuery(String id, String query) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<UnidadesOEModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM UnidadesOE WHERE id = '$id' AND placaVehiculo LIKE '%$query%' ");

      if (maps.isNotEmpty) list = UnidadesOEModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  delete() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM UnidadesOE");

    return res;
  }
}
