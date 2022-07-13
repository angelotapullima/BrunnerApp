import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/notas_pendientes_model.dart';

import 'package:sqflite/sqlite_api.dart';

class NotasPendientesDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarNota(NotasPendientesModel notaP) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'NotasPendientes',
        notaP.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<NotasPendientesModel>> getNotas() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<NotasPendientesModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM NotasPendientes");

      if (maps.isNotEmpty) list = NotasPendientesModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<NotasPendientesModel>> getNotasPendientesFiltro(String idSede, String tipo) async {
    try {
      String initial = "SELECT * FROM NotasPendientes";
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
        initial = "SELECT * FROM NotasPendientes WHERE $query";
      }

      final Database db = await dbprovider.getDatabase();
      List<NotasPendientesModel> list = [];
      List<Map> maps = await db.rawQuery(initial);

      if (maps.isNotEmpty) list = NotasPendientesModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteNotas() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM NotasPendientes");

    return res;
  }
}
