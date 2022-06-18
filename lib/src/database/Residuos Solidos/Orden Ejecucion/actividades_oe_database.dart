import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Orden%20Ejecucion/actividades_oe_model.dart';
import 'package:sqflite/sqlite_api.dart';

class ActividadesOEDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarActividadOE(ActividadesOEModel actividad) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'ActividadesOE',
        actividad.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<ActividadesOEModel>> getActividadesOEByIdCliente(String idCliente) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ActividadesOEModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM ActividadesOE WHERE idCliente = '$idCliente'");

      if (maps.isNotEmpty) list = ActividadesOEModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }
}
