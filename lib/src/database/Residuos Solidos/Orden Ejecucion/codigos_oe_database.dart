import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Orden%20Ejecucion/codigos_ue_model.dart';
import 'package:sqflite/sqlite_api.dart';

class CodigosOEDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarCodigoOE(CodigosOEModel cod) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'CodigosOE',
        cod.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<CodigosOEModel>> getCodigosOEByIdCliente(String idCliente) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<CodigosOEModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM CodigosOE WHERE idCliente = '$idCliente'");

      if (maps.isNotEmpty) list = CodigosOEModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  delete() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM CodigosOE");

    return res;
  }
}
