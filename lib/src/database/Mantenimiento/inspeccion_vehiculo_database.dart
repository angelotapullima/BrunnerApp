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

  Future<List<InspeccionVehiculoModel>> getInspeccionFiltro(
      String fechaInicial, String fechaFinal, String placaMarca, String operario, String estado, String nroCheck) async {
    try {
      String query = '';
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
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM InspeccionVehiculos WHERE fechaInspeccionVehiculo BETWEEN '$fechaInicial' AND '$fechaFinal' $query ORDER BY CAST(idInspeccionVehiculo AS INTEGER)");

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
