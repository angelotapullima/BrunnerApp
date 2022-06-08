import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Logistica/empresas_model.dart';
import 'package:sqflite/sqlite_api.dart';

class EmpresasDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarEmpresa(EmpresasModel empresa) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Empresas',
        empresa.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<EmpresasModel>> getEmpresas() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<EmpresasModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Empresas");

      if (maps.isNotEmpty) list = EmpresasModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }
}
