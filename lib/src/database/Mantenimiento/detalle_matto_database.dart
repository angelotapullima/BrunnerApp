import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/mantto_detalle_model.dart';
import 'package:sqflite/sqlite_api.dart';

class DetalleManttoDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarDetalleMantto(ManttoDetalleModel detalleMantto) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'DetalleMantto',
        detalleMantto.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<ManttoDetalleModel>> getDetalleByIdMantenimiento(String idMantenimiento) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ManttoDetalleModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM DetalleMantto WHERE idMantenimiento='$idMantenimiento'");
      if (maps.isNotEmpty) list = ManttoDetalleModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteDetalleMantenimiento() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM DetalleMantto");

    return res;
  }
}
