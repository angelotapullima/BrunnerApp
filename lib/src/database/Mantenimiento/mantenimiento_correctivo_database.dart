import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/mantenimiento_correctivo_model.dart';
import 'package:sqflite/sqlite_api.dart';

class MantenimientoCorrectivoDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarMantenimiento(MantenimientoCorrectivoModel mantenimiento) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'MantenimientoCorrectivo',
        mantenimiento.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<MantenimientoCorrectivoModel>> getMantenimientoByIdInspeccionDetalle(String idInspeccionDetalle) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<MantenimientoCorrectivoModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM MantenimientoCorrectivo WHERE idInspeccionDetalle='$idInspeccionDetalle'");

      if (maps.isNotEmpty) list = MantenimientoCorrectivoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<MantenimientoCorrectivoModel>> getMantenimientosOrdenHabByIdInspeccionDetalle(String idInspeccionDetalle) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<MantenimientoCorrectivoModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM MantenimientoCorrectivo WHERE idInspeccionDetalle='$idInspeccionDetalle' AND (estado='5' OR estado='2') AND estadoFinal='1' ");

      if (maps.isNotEmpty) list = MantenimientoCorrectivoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<MantenimientoCorrectivoModel>> getMantenimientosInformePendienteByIdInspeccionDetalle(String idInspeccionDetalle) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<MantenimientoCorrectivoModel> list = [];
      List<Map> maps = await db
          .rawQuery("SELECT * FROM MantenimientoCorrectivo WHERE idInspeccionDetalle='$idInspeccionDetalle' AND estado='1' AND estadoFinal='1' ");

      if (maps.isNotEmpty) list = MantenimientoCorrectivoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<MantenimientoCorrectivoModel>> getMantenimientosFiltro(String idInspeccionDetalle, String idPersona, String estado) async {
    try {
      String query = "SELECT * FROM MantenimientoCorrectivo WHERE idInspeccionDetalle='$idInspeccionDetalle'";

      if (idPersona.isNotEmpty) {
        query += " AND idResponsable='$idPersona'";
      }

      if (estado.isNotEmpty) {
        query += " AND estado= '$estado'";
      }
      query += " ORDER BY CAST(idMantenimiento AS INTEGER)";
      final Database db = await dbprovider.getDatabase();
      List<MantenimientoCorrectivoModel> list = [];
      List<Map> maps = await db.rawQuery(query);

      if (maps.isNotEmpty) list = MantenimientoCorrectivoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteMantenimiento() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM MantenimientoCorrectivo");

    return res;
  }
}
