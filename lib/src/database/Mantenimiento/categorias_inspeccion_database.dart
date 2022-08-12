// import 'package:new_brunner_app/src/core/database_config.dart';
// import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_model.dart';
// import 'package:sqflite/sqlite_api.dart';

// class CategoriaInspeccionDatabase {
//   final dbprovider = DatabaseHelper.instance;

//   Future<void> insertarCategoriaInspeccion(CategoriaInspeccionModel categoria) async {
//     try {
//       final Database db = await dbprovider.getDatabase();

//       await db.insert(
//         'CategoriasInspeccion',
//         categoria.toJson(),
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//     } catch (e) {
//       e;
//     }
//   }

//   Future<List<CategoriaInspeccionModel>> getCategoriasInspeccion() async {
//     try {
//       final Database db = await dbprovider.getDatabase();
//       List<CategoriaInspeccionModel> list = [];
//       List<Map> maps = await db.rawQuery("SELECT * FROM CategoriasInspeccion");

//       if (maps.isNotEmpty) list = CategoriaInspeccionModel.fromJsonList(maps);
//       return list;
//     } catch (e) {
//       e;
//       return [];
//     }
//   }

//   Future<List<CategoriaInspeccionModel>> getCatInspeccionByTipoInspeccion(String tipoInspeccion) async {
//     try {
//       final Database db = await dbprovider.getDatabase();
//       List<CategoriaInspeccionModel> list = [];
//       List<Map> maps =
//           await db.rawQuery("SELECT * FROM CategoriasInspeccion WHERE tipoInspeccion='$tipoInspeccion' ORDER BY CAST(idCatInspeccion AS INTEGER)");

//       if (maps.isNotEmpty) list = CategoriaInspeccionModel.fromJsonList(maps);
//       return list;
//     } catch (e) {
//       e;
//       return [];
//     }
//   }

//   deleteCatInspeccion() async {
//     final db = await dbprovider.database;

//     final res = await db.rawDelete("DELETE FROM CategoriasInspeccion");

//     return res;
//   }
// }
