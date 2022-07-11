import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/recurso_logistica_model.dart';

import 'package:sqflite/sqlite_api.dart';

class RecursoLogisticaDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarRecurso(RecursoLogisticaModel recurso) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'RecursoLogistica',
        recurso.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<RecursoLogisticaModel>> getRecursosLogisticaByIDSede(String idSede) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<RecursoLogisticaModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM RecursoLogistica WHERE idSede='$idSede'");

      if (maps.isNotEmpty) list = RecursoLogisticaModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<RecursoLogisticaModel>> getRecursosLogisticaByIDSedeANDQuery(String idSede, String query) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<RecursoLogisticaModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM RecursoLogistica WHERE idSede='$idSede' AND (nombreClaseLogistica LIKE '%$query%' OR nombreRecursoLogistica LIKE '%$query%' OR cantidadAlmacen LIKE '%$query%')");

      if (maps.isNotEmpty) list = RecursoLogisticaModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteRecurso(String idSede) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM RecursoLogistica WHERE idSede='$idSede'");

    return res;
  }
}
