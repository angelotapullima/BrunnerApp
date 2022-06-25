import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Orden%20Ejecucion/contactos_oe_model.dart';
import 'package:sqflite/sqlite_api.dart';

class ContactosOEDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarContactoOE(ContactosOEModel contacto) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'ContactosOE',
        contacto.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<ContactosOEModel>> getContactosOEByIdCliente(String idCliente) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ContactosOEModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM ContactosOE WHERE idCliente = '$idCliente'");

      if (maps.isNotEmpty) list = ContactosOEModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  delete() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM ContactosOE");

    return res;
  }
}
