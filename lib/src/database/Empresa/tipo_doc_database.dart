import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Empresa/tipo_doc_model.dart';
import 'package:sqflite/sqlite_api.dart';

class TipoDocDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarTipoDoc(TipoDocModel doc) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'TipoDoc',
        doc.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<TipoDocModel>> getTiposDoc() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<TipoDocModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM TipoDoc");

      if (maps.isNotEmpty) list = TipoDocModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  updateHabilitarCheck(String idTipoDoc, String valueCheck) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate("UPDATE TipoDoc SET "
        "valueCheck='$valueCheck' "
        "WHERE idTipoDoc='$idTipoDoc'");
    return res;
  }

  updateHabilitarAll() async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate("UPDATE TipoDoc SET valueCheck='0' ");
    return res;
  }
}
