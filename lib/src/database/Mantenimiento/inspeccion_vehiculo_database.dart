import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_model.dart';
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

  Future<List<InspeccionVehiculoModel>> getInspeccionByIdInspeccion(String idInspeccionVehiculo) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM InspeccionVehiculos WHERE idInspeccionVehiculo='$idInspeccionVehiculo'  ORDER BY CAST(idInspeccionVehiculo AS INTEGER)");

      if (maps.isNotEmpty) list = InspeccionVehiculoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<InspeccionVehiculoModel>> getInspeccionFiltro(
      String fechaInicial, String fechaFinal, String placaMarca, String operario, String estado, String nroCheck) async {
    try {
      String query = "SELECT * FROM InspeccionVehiculos WHERE fechaInspeccionVehiculo BETWEEN '$fechaInicial' AND '$fechaFinal'";
      if (placaMarca.isNotEmpty) {
        query += " AND (placaVehiculo LIKE '%$placaMarca%' OR marcaVehiculo  LIKE '%$placaMarca%')";
      }

      if (operario.isNotEmpty) {
        query += " AND idchofer = '$operario'";
      }

      if (estado.isNotEmpty) {
        query += " AND estadoCheckInspeccionVehiculo ='$estado'";
      }
      if (nroCheck.isNotEmpty) {
        query += " AND numeroInspeccionVehiculo ='$nroCheck'";
      }

      query += " ORDER BY CAST(idInspeccionVehiculo AS INTEGER)";

      Preferences.saveData('query', query);
      Preferences.saveData('fechaInicial', fechaInicial);
      Preferences.saveData('fechaFinal', fechaFinal);
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoModel> list = [];
      List<Map> maps = await db.rawQuery(query);

      if (maps.isNotEmpty) list = InspeccionVehiculoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<InspeccionVehiculoModel>> getInspeccionQuery() async {
    try {
      String? query = await Preferences.readData('query');

      Preferences.saveData('query', query);
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoModel> list = [];
      List<Map> maps = await db.rawQuery(query.toString());

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
