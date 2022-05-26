import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:sqflite/sqlite_api.dart';

class InspeccionVehiculoDetalleDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarDetalleInspeccion(InspeccionVehiculoDetalleModel detalle) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'InspeccionVehiculoDetalle',
        detalle.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<InspeccionVehiculoDetalleModel>> getDetallesInspeccion() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoDetalleModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM InspeccionVehiculoDetalle");

      if (maps.isNotEmpty) list = InspeccionVehiculoDetalleModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<InspeccionVehiculoDetalleModel>> getDetalleInspeccionById(String idInspeccionDetalle) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoDetalleModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM InspeccionVehiculoDetalle WHERE idInspeccionDetalle='$idInspeccionDetalle'");

      if (maps.isNotEmpty) list = InspeccionVehiculoDetalleModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<InspeccionVehiculoDetalleModel>> getDetalleInspeccionByPlacaVehiculo(String plavaVehiculo) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoDetalleModel> list = [];
      List<Map> maps =
          await db.rawQuery("SELECT * FROM InspeccionVehiculoDetalle WHERE plavaVehiculo='$plavaVehiculo' AND estadoFinalInspeccionDetalle!='0'");

      if (maps.isNotEmpty) list = InspeccionVehiculoDetalleModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<InspeccionVehiculoDetalleModel>> getDetalleInspeccionFiltro(String tipoUnidad, String fechaInicial, String fechaFinal, String placa,
      String idCategoria, String idItem, String estado, String nroCheck) async {
    try {
      String query = "SELECT * FROM InspeccionVehiculoDetalle WHERE tipoUnidad='$tipoUnidad'";

      if (fechaInicial.isNotEmpty && fechaFinal.isNotEmpty) {
        query += " AND fechaInspeccion BETWEEN '$fechaInicial' AND '$fechaFinal'";
      }

      if (placa.isNotEmpty) {
        query += " AND plavaVehiculo LIKE '%$placa%'";
      }

      if (idCategoria.isNotEmpty) {
        query += " AND idCategoria='$idCategoria'";
      }

      if (idItem.isNotEmpty) {
        query += " AND idItemInspeccion='$idItem'";
      }

      if (estado.isNotEmpty) {
        query += " AND estadoFinalInspeccionDetalle='$estado'";
      }
      if (nroCheck.isNotEmpty) {
        query += " AND nroCheckList='$nroCheck'";
      }

      //query += " ORDER BY CAST(idInspeccionDetalle AS INTEGER)";
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoDetalleModel> list = [];
      List<Map> maps = await db.rawQuery(query);

      if (maps.isNotEmpty) list = InspeccionVehiculoDetalleModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteDetalleInspeccion() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM InspeccionVehiculoDetalle");

    return res;
  }
}
