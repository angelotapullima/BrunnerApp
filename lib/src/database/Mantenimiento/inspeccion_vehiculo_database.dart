import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_model.dart';
import 'package:sqflite/sqlite_api.dart';

class InspeccionVehiculoDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarInspeccion(InspeccionVehiculoModel inspeccion) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'InspeccionVehiculos',
        inspeccion.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<InspeccionVehiculoModel>> getInspeccion() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM InspeccionVehiculos");

      if (maps.isNotEmpty) list = InspeccionVehiculoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<InspeccionVehiculoModel>> getInpeccionesByQuery(String query) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM InspeccionVehiculos WHERE nombreChofer LIKE '%$query%' OR dniChofer LIKE '%$query%' ORDER BY CAST(idChofer AS INTEGER)");

      if (maps.isNotEmpty) list = InspeccionVehiculoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteInspeccion() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM InspeccionVehiculos");

    return res;
  }
}
