import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Logistica/Cotizacion/recurso_cotizacion_model.dart';

import 'package:sqflite/sqlite_api.dart';

class RecursoCotizacionDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarRecurso(RecursoCotizacionModel recurso) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'RecursoCotizacion',
        recurso.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<RecursoCotizacionModel>> getRecursosLogistica() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<RecursoCotizacionModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM RecursoCotizacion");

      if (maps.isNotEmpty) list = RecursoCotizacionModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<RecursoCotizacionModel>> getRecursosLogisticaByQuery(String query) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<RecursoCotizacionModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM RecursoCotizacion WHERE nombreClaseLogistica LIKE '%$query%' OR nombreRecursoLogistica LIKE '%$query%' OR cantidadAlmacen LIKE '%$query%'");

      if (maps.isNotEmpty) list = RecursoCotizacionModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteRecurso() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM RecursoCotizacion");

    return res;
  }
}
