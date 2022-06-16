import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Empresa/departamento_model.dart';
import 'package:sqflite/sqlite_api.dart';

class DepartamentoDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarDepartamento(DepartamentoModel departamento) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Departamento',
        departamento.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<DepartamentoModel>> getDepartamentos() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<DepartamentoModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Departamento");

      if (maps.isNotEmpty) list = DepartamentoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }
}
