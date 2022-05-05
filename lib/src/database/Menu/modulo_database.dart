import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Menu/modulos_model.dart';
import 'package:sqflite/sqlite_api.dart';

class ModuloDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarModulo(ModulosModel modulo) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Modulos',
        modulo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<ModulosModel>> getModulos() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ModulosModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Modulos ORDER BY CAST(ordenModulo AS INTEGER) DESC");

      if (maps.isNotEmpty) list = ModulosModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteModulos() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Modulos");

    return res;
  }
}
