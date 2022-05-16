import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_item_model.dart';
import 'package:sqflite/sqlite_api.dart';

class InspeccionVehiculoItemDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarCheckItemInspeccion(InspeccionVehiculoItemModel checkItem) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'InspeccionVehiculoItem',
        checkItem.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<InspeccionVehiculoItemModel>> getCheckItemsInspeccion() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoItemModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM InspeccionVehiculoItem");

      if (maps.isNotEmpty) list = InspeccionVehiculoItemModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<InspeccionVehiculoItemModel>> getCheckItemInspeccionByIdInspeccionANDIdCat(String idInspeccionVehiculo, String idCatInspeccion) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoItemModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM InspeccionVehiculoItem WHERE idInspeccionVehiculo='$idInspeccionVehiculo' AND idCatInspeccion='$idCatInspeccion' ORDER BY CAST(idCheckItemInsp AS INTEGER)");

      if (maps.isNotEmpty) list = InspeccionVehiculoItemModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<InspeccionVehiculoItemModel>> getCheckItemInspeccionByIdInspeccion(String idInspeccionVehiculo) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoItemModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM InspeccionVehiculoItem WHERE idInspeccionVehiculo='$idInspeccionVehiculo' AND valueCheckItemInsp!=''  ORDER BY CAST(idCheckItemInsp AS INTEGER)");

      if (maps.isNotEmpty) list = InspeccionVehiculoItemModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<InspeccionVehiculoItemModel>> getCheckItemInspeccionFALTANTESByIdinspeccion(String idInspeccionVehiculo) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoItemModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM InspeccionVehiculoItem WHERE idInspeccionVehiculo='$idInspeccionVehiculo' AND valueCheckItemInsp=='0' AND ckeckItemHabilitado=='0'  ORDER BY CAST(idCheckItemInsp AS INTEGER)");

      if (maps.isNotEmpty) list = InspeccionVehiculoItemModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<InspeccionVehiculoItemModel>> getObservacionesItemInspeccionByIdInspeccion(String idInspeccionVehiculo) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoItemModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM InspeccionVehiculoItem WHERE idInspeccionVehiculo='$idInspeccionVehiculo' AND (valueCheckItemInsp=='2' OR valueCheckItemInsp=='3')   ORDER BY CAST(idCheckItemInsp AS INTEGER)");

      if (maps.isNotEmpty) list = InspeccionVehiculoItemModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<InspeccionVehiculoItemModel>> getCHECKItemInspeccionSELECCIONADOSByIdInspeccion(String idInspeccionVehiculo) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoItemModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM InspeccionVehiculoItem WHERE idInspeccionVehiculo='$idInspeccionVehiculo' AND valueCheckItemInsp!='' AND valueCheckItemInsp!='0' ORDER BY CAST(idCheckItemInsp AS INTEGER)");

      if (maps.isNotEmpty) list = InspeccionVehiculoItemModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<InspeccionVehiculoItemModel>> getCheckItemInspeccionByIdCheckItem(String idCheckItemInsp) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<InspeccionVehiculoItemModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM InspeccionVehiculoItem WHERE idCheckItemInsp='$idCheckItemInsp'");

      if (maps.isNotEmpty) list = InspeccionVehiculoItemModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteCheckItemInspeccion() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM InspeccionVehiculoItem");

    return res;
  }

  updateCheckInspeccion(InspeccionVehiculoItemModel checkItem) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate("UPDATE InspeccionVehiculoItem SET "
        "valueCheckItemInsp='${checkItem.valueCheckItemInsp}', "
        "observacionCkeckItemInsp='${checkItem.observacionCkeckItemInsp}' "
        "WHERE idCheckItemInsp='${checkItem.idCheckItemInsp}'");
    return res;
  }

  updateCheck(String valueCheckItemInsp, String idCheckItemInsp) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate("UPDATE InspeccionVehiculoItem SET "
        "valueCheckItemInsp='$valueCheckItemInsp', "
        "observacionCkeckItemInsp='' "
        "WHERE idCheckItemInsp='$idCheckItemInsp'");
    return res;
  }

  updateHabilitarCheck(String idCheckItemInsp, String ckeckItemHabilitado) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate("UPDATE InspeccionVehiculoItem SET "
        "ckeckItemHabilitado='$ckeckItemHabilitado' "
        "WHERE idCheckItemInsp='$idCheckItemInsp'");
    return res;
  }

  deleteCheckItemInspeccionByIdVehiculo(String idVehiculo) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM InspeccionVehiculoItem WHERE idVehiculo='$idVehiculo'");

    return res;
  }
}
