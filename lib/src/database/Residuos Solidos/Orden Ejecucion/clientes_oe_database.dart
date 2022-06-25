import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Orden%20Ejecucion/clientes_oe_model.dart';
import 'package:sqflite/sqlite_api.dart';

class ClientesOEDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarClienteOE(ClientesOEModel cliente) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'ClientesOE',
        cliente.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<ClientesOEModel>> getClientesOE(String id) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ClientesOEModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM ClientesOE WHERE id='$id'");

      if (maps.isNotEmpty) list = ClientesOEModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<ClientesOEModel>> getClientesOEByQuery(String query, String id) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ClientesOEModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM ClientesOE WHERE id='$id' AND nombreCliente LIKE '%$query%'");

      if (maps.isNotEmpty) list = ClientesOEModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  delete() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM ClientesOE");

    return res;
  }
}
