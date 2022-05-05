import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/vehiculo_model.dart';
import 'package:sqflite/sqlite_api.dart';

class VehiculoDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarVehiculo(VehiculoModel vehiculo) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Vehiculos',
        vehiculo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<VehiculoModel>> getVehiculos() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<VehiculoModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Vehiculos");

      if (maps.isNotEmpty) list = VehiculoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<VehiculoModel>> getVehiculosQuery(String query) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<VehiculoModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM Vehiculos WHERE rucVehiculo LIKE '%$query%' OR razonSocialVehiculo LIKE '%$query%' OR placaVehiculo LIKE '%$query%' OR marcaVehiculo LIKE '%$query%' ORDER BY CAST(idVehiculo AS INTEGER)");

      if (maps.isNotEmpty) list = VehiculoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteVehiculos() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Vehiculos");

    return res;
  }
}
