import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/recursos_almacen_model.dart';

import 'package:sqflite/sqlite_api.dart';

class RecursosAlmacenDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarRecurso(RecursosAlmacenModel recurso) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'RecursosAlmacen',
        recurso.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<RecursosAlmacenModel>> getRecursosAlmacenByIDSede(String idSede) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<RecursosAlmacenModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM RecursosAlmacen WHERE idSede='$idSede'");

      if (maps.isNotEmpty) list = RecursosAlmacenModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<RecursosAlmacenModel>> getRecursosAlmacenByIDSedeANDQuery(String idSede, String query) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<RecursosAlmacenModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM RecursosAlmacen WHERE idSede='$idSede' AND (nombreClaseLogistica LIKE '%$query%' OR nombreRecurso LIKE '%$query%' OR stockAlmacen LIKE '%$query%' OR unidadRecurso LIKE '%$query%' OR nombreTipoRecurso LIKE '%$query%')");

      if (maps.isNotEmpty) list = RecursosAlmacenModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteRecurso(String idSede) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM RecursosAlmacen WHERE idSede='$idSede'");

    return res;
  }
}
