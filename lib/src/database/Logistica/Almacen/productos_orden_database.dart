import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/productos_orden_model.dart';

import 'package:sqflite/sqlite_api.dart';

class ProductosOrdenDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarProducto(ProductosOrdenModel product) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'ProductosOrden',
        product.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<ProductosOrdenModel>> getProductosOrden(String idAlmacenLog) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ProductosOrdenModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM ProductosOrden WHERE idAlmacenLog='$idAlmacenLog'");

      if (maps.isNotEmpty) list = ProductosOrdenModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteProductosById(String idAlmacenLog) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM ProductosOrden WHERE idAlmacenLog='$idAlmacenLog'");

    return res;
  }
}
