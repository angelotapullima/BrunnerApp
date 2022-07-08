import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Logistica/Orden%20Pedido/detalle_op_model.dart';
import 'package:sqflite/sqlite_api.dart';

class DetalleOPDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarDetalleOP(DetalleOPModel detalle) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'DetalleOrdenPedido',
        detalle.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<DetalleOPModel>> getDetalleOPByidOP(String idOP) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<DetalleOPModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM DetalleOrdenPedido WHERE idOP='$idOP'");

      if (maps.isNotEmpty) list = DetalleOPModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteDetalle(String idOP) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM DetalleOrdenPedido WHERE idOP='$idOP'");

    return res;
  }
}
