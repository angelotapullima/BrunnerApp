import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Menu/submodulo_model.dart';
import 'package:sqflite/sqlite_api.dart';

class SubModuloDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarSubModulo(SubModuloModel subModulo) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'SubModulos',
        subModulo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<SubModuloModel>> getSubModulosByIdModulo(String idModulo) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<SubModuloModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM SubModulos WHERE idModulo='$idModulo'");

      if (maps.isNotEmpty) list = SubModuloModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteSubModulos() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM SubModulos");

    return res;
  }
}
