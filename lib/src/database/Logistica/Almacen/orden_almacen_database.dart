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

  Future<List<OrdenAlmacenModel>> getOrdenesPendientesFiltro(String idSede, String tipo) async {
    try {
      String query = "SELECT * FROM OrdenAlmacen WHERE estadoAlmacenLog='0'";
      if (idSede.isNotEmpty) {
        query += " OR idSede='$idSede'";
      }
      if (tipo.isNotEmpty) {
        query += " OR tipoAlmacenLog='$tipo'";
      }

      final Database db = await dbprovider.getDatabase();
      List<OrdenAlmacenModel> list = [];
      List<Map> maps = await db.rawQuery(query);

      if (maps.isNotEmpty) list = OrdenAlmacenModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<OrdenAlmacenModel>> searchOrdenesPendientesFiltro(String idSede, String tipo, String querys) async {
    try {
      String query =
          "SELECT * FROM OrdenAlmacen WHERE estadoAlmacenLog='0' AND (fechaAlmacenLog LIKE '%$querys%' OR horaAlmacenLog LIKE '%$querys%' OR comentarioAlmacenLog LIKE '%$querys%' OR nombreUserCreacion LIKE '%$querys%' )";
      if (idSede.isNotEmpty) {
        query += " OR idSede='$idSede'";
      }
      if (tipo.isNotEmpty) {
        query += " OR tipoAlmacenLog='$tipo'";
      }

      final Database db = await dbprovider.getDatabase();
      List<OrdenAlmacenModel> list = [];
      List<Map> maps = await db.rawQuery(query);

      if (maps.isNotEmpty) list = OrdenAlmacenModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<OrdenAlmacenModel>> getOrdenesGeneradasFiltro(String idSede, String tipo, String entrega, String numero) async {
    try {
      String query = "SELECT * FROM OrdenAlmacen WHERE estadoAlmacenLog='1'";
      if (idSede.isNotEmpty) {
        query += " OR idSede='$idSede'";
      }
      if (tipo.isNotEmpty) {
        query += " OR tipoAlmacenLog='$tipo'";
      }
      if (entrega.isNotEmpty) {
        query += " OR entregaAlmacenLog='$entrega'";
      }
      if (numero.isNotEmpty) {
        query += " OR codigoAlmacenLog='$numero'";
      }

      final Database db = await dbprovider.getDatabase();
      List<OrdenAlmacenModel> list = [];
      List<Map> maps = await db.rawQuery(query);

      if (maps.isNotEmpty) list = OrdenAlmacenModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<OrdenAlmacenModel>> searchOrdenesGeneradasFiltro(String idSede, String tipo, String entrega, String numero, String querys) async {
    try {
      String query =
          "SELECT * FROM OrdenAlmacen WHERE estadoAlmacenLog='1' AND (fechaAlmacenLog LIKE '%$querys%' OR horaAlmacenLog LIKE '%$querys%' OR nombreSede LIKE '%$querys%' OR comentarioAlmacenLog LIKE '%$querys%' OR nombreUserCreacion LIKE '%$querys%' )";
      if (idSede.isNotEmpty) {
        query += " OR idSede='$idSede'";
      }
      if (tipo.isNotEmpty) {
        query += " OR tipoAlmacenLog='$tipo'";
      }
      if (entrega.isNotEmpty) {
        query += " OR entregaAlmacenLog='$entrega'";
      }
      if (numero.isNotEmpty) {
        query += " OR codigoAlmacenLog='$numero'";
      }

      final Database db = await dbprovider.getDatabase();
      List<OrdenAlmacenModel> list = [];
      List<Map> maps = await db.rawQuery(query);

      if (maps.isNotEmpty) list = OrdenAlmacenModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteOrdenes(String estado) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM OrdenAlmacen WHERE estadoAlmacenLog='$estado'");

    return res;
  }
}
