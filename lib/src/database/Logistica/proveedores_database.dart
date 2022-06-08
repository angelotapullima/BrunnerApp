import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Logistica/proveedores_model.dart';
import 'package:sqflite/sqlite_api.dart';

class ProveedoresDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarProveedor(ProveedoresModel proveedor) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Proveedores',
        proveedor.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<ProveedoresModel>> getProveedores() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ProveedoresModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Proveedores");

      if (maps.isNotEmpty) list = ProveedoresModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<ProveedoresModel>> getProveedoresByQuery(String query) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ProveedoresModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Proveedores WHERE nombreProveedor LIKE '%$query%' ");

      if (maps.isNotEmpty) list = ProveedoresModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }
}
