import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/orden_almacen_model.dart';

import 'package:sqflite/sqlite_api.dart';

class OrdenAlmacenDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarOrden(OrdenAlmacenModel notaP) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'OrdenAlmacen',
        notaP.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<OrdenAlmacenModel>> getOrdenById(String idAlmacenLog) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<OrdenAlmacenModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM OrdenAlmacen WHERE idAlmacenLog='$idAlmacenLog'");

      if (maps.isNotEmpty) list = OrdenAlmacenModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<OrdenAlmacenModel>> getNotasPendientesFiltro(String idSede, String tipo) async {
    try {
      String initial = "SELECT * FROM OrdenAlmacen";
      String query = '';
      if (idSede.isNotEmpty) {
        query += "idSede='$idSede'";
      }
      if (tipo.isNotEmpty) {
        if (query.isNotEmpty) {
          query += " OR tipoAlmacenLog='$tipo'";
        } else {
          query += "tipoAlmacenLog='$tipo'";
        }
      }

      if (query.isNotEmpty) {
        initial = "SELECT * FROM OrdenAlmacen WHERE $query";
      }

      final Database db = await dbprovider.getDatabase();
      List<OrdenAlmacenModel> list = [];
      List<Map> maps = await db.rawQuery(initial);

      if (maps.isNotEmpty) list = OrdenAlmacenModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteNotas() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM OrdenAlmacen");

    return res;
  }
}
