import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/check_item_inspeccion_model.dart';
import 'package:sqflite/sqlite_api.dart';

class CheckItemInspeccionDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarCheckItemInspeccion(CheckItemInspeccionModel checkItem) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'CheckItemInspeccion',
        checkItem.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<CheckItemInspeccionModel>> getCheckItemsInspeccion() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<CheckItemInspeccionModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM CheckItemInspeccion");

      if (maps.isNotEmpty) list = CheckItemInspeccionModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<CheckItemInspeccionModel>> getCheckItemInspeccionByIdVehiculoANDIdCat(String idVehiculo, String idCatInspeccion) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<CheckItemInspeccionModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM CheckItemInspeccion WHERE idVehiculo='$idVehiculo' AND idCatInspeccion='$idCatInspeccion' ORDER BY CAST(idCheckItemInsp AS INTEGER)");

      if (maps.isNotEmpty) list = CheckItemInspeccionModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<CheckItemInspeccionModel>> getCheckItemInspeccionByIdVehiculo(String idVehiculo) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<CheckItemInspeccionModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM CheckItemInspeccion WHERE idVehiculo='$idVehiculo' AND valueCheckItemInsp!=''  ORDER BY CAST(idCheckItemInsp AS INTEGER)");

      if (maps.isNotEmpty) list = CheckItemInspeccionModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<CheckItemInspeccionModel>> getCheckItemInspeccionFALTANTESByIdVehiculo(String idVehiculo) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<CheckItemInspeccionModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM CheckItemInspeccion WHERE idVehiculo='$idVehiculo' AND valueCheckItemInsp=='0' AND ckeckItemHabilitado=='0'  ORDER BY CAST(idCheckItemInsp AS INTEGER)");

      if (maps.isNotEmpty) list = CheckItemInspeccionModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<CheckItemInspeccionModel>> getObservacionesItemInspeccionByIdVehiculo(String idVehiculo) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<CheckItemInspeccionModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM CheckItemInspeccion WHERE idVehiculo='$idVehiculo' AND observacionCkeckItemInsp!='' ORDER BY CAST(idCheckItemInsp AS INTEGER)");

      if (maps.isNotEmpty) list = CheckItemInspeccionModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<CheckItemInspeccionModel>> getCHECKItemInspeccionSELECCIONADOSByIdVehiculo(String idVehiculo) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<CheckItemInspeccionModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM CheckItemInspeccion WHERE idVehiculo='$idVehiculo' AND valueCheckItemInsp!='' AND valueCheckItemInsp!='0' ORDER BY CAST(idCheckItemInsp AS INTEGER)");

      if (maps.isNotEmpty) list = CheckItemInspeccionModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<CheckItemInspeccionModel>> getCheckItemInspeccionByIdCheckItem(String idCheckItemInsp) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<CheckItemInspeccionModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM CheckItemInspeccion WHERE idCheckItemInsp='$idCheckItemInsp'");

      if (maps.isNotEmpty) list = CheckItemInspeccionModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteCheckItemInspeccion() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM CheckItemInspeccion");

    return res;
  }

  updateCheckInspeccion(CheckItemInspeccionModel checkItem) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate("UPDATE CheckItemInspeccion SET "
        "valueCheckItemInsp='${checkItem.valueCheckItemInsp}', "
        "observacionCkeckItemInsp='${checkItem.observacionCkeckItemInsp}' "
        "WHERE idCheckItemInsp='${checkItem.idCheckItemInsp}'");
    return res;
  }

  updateCheck(String valueCheckItemInsp, String idCheckItemInsp) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate("UPDATE CheckItemInspeccion SET "
        "valueCheckItemInsp='$valueCheckItemInsp', "
        "observacionCkeckItemInsp='' "
        "WHERE idCheckItemInsp='$idCheckItemInsp'");
    return res;
  }

  updateHabilitarCheck(String idCheckItemInsp, String ckeckItemHabilitado) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate("UPDATE CheckItemInspeccion SET "
        "ckeckItemHabilitado='$ckeckItemHabilitado' "
        "WHERE idCheckItemInsp='$idCheckItemInsp'");
    return res;
  }

  deleteCheckItemInspeccionByIdVehiculo(String idVehiculo) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM CheckItemInspeccion WHERE idVehiculo='$idVehiculo'");

    return res;
  }
}
