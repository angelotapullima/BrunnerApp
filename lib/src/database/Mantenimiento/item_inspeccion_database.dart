import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/item_inspeccion_model.dart';
import 'package:sqflite/sqlite_api.dart';

class ItemInspeccionDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarItemInspeccion(ItemInspeccionModel item) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'ItemInspeccion',
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<ItemInspeccionModel>> getItemsInspeccion() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ItemInspeccionModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM ItemInspeccion");

      if (maps.isNotEmpty) list = ItemInspeccionModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<ItemInspeccionModel>> getItemInspeccionByIdCatInsp(String idCatInspeccion) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ItemInspeccionModel> list = [];
      List<Map> maps =
          await db.rawQuery("SELECT * FROM ItemInspeccion WHERE idCatInspeccion='$idCatInspeccion' ORDER BY CAST(idItemInspeccion AS INTEGER)");

      if (maps.isNotEmpty) list = ItemInspeccionModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteItemInspeccion() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM ItemInspeccion");

    return res;
  }
}
