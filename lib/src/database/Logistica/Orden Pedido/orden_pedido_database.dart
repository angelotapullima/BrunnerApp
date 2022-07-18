import 'package:new_brunner_app/src/core/database_config.dart';
import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/model/Logistica/Orden%20Pedido/orden_pedido_model.dart';
import 'package:sqflite/sqlite_api.dart';

class OrdenPedidoDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarOrden(OrdenPedidoModel orden) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'OrdenPedido',
        orden.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      e;
    }
  }

  Future<List<OrdenPedidoModel>> getOPSFiltro(
      String empresa, String proveedor, String estado, String rendicion, String fechaInicial, String fechaFinal) async {
    try {
      String query = "SELECT * FROM OrdenPedido WHERE fechaOP BETWEEN '$fechaInicial' AND '$fechaFinal'";

      if (empresa.isNotEmpty) {
        query += " AND nombreEmpresa = '$empresa'";
      }

      if (proveedor.isNotEmpty) {
        query += " AND nombreProveedor='$proveedor'";
      }

      if (estado.isNotEmpty) {
        query += " AND estado='$estado'";
      }

      if (rendicion.isNotEmpty) {
        query += " AND rendido='$rendicion'";
      }

      String query2 = "$query  AND numeroOP!='0' ";
      Preferences.saveData('queryOP', query2);

      query += " AND numeroOP!='0' ORDER BY CAST(numeroOP AS INTEGER) DESC";

      Preferences.saveData('query', query);
      final Database db = await dbprovider.getDatabase();
      List<OrdenPedidoModel> list = [];
      List<Map> maps = await db.rawQuery(query);

      if (maps.isNotEmpty) list = OrdenPedidoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<OrdenPedidoModel>> getOPSByNumber(String numberOP) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<OrdenPedidoModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM OrdenPedido WHERE numeroOP='$numberOP'");

      if (maps.isNotEmpty) list = OrdenPedidoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<OrdenPedidoModel>> getOPSPendientes() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<OrdenPedidoModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM OrdenPedido WHERE estado='0' AND numeroOP='0'");

      if (maps.isNotEmpty) list = OrdenPedidoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<OrdenPedidoModel>> searchOPSPendientes(String query) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<OrdenPedidoModel> list = [];
      List<Map> maps = await db.rawQuery(
          "SELECT * FROM OrdenPedido WHERE estado='0' AND numeroOP='0' AND (fechaCreacion LIKE '%$query%' OR monedaOP LIKE '%$query%' OR opVencimiento LIKE '%$query%' OR nombreProveedor LIKE '%$query%' OR rucProveedor LIKE '%$query%' OR nombreSede LIKE '%$query%' OR condicionesOP LIKE '%$query%' OR nombrePerson LIKE '%$query%' OR surnamePerson LIKE '%$query%') ");

      if (maps.isNotEmpty) list = OrdenPedidoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<OrdenPedidoModel>> getOPSByidOP(String idOP) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<OrdenPedidoModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM OrdenPedido WHERE idOP='$idOP'");

      if (maps.isNotEmpty) list = OrdenPedidoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<OrdenPedidoModel>> getOPSQuery() async {
    try {
      String? query = await Preferences.readData('query');

      Preferences.saveData('query', query);
      final Database db = await dbprovider.getDatabase();
      List<OrdenPedidoModel> list = [];
      List<Map> maps = await db.rawQuery(query.toString());

      if (maps.isNotEmpty) list = OrdenPedidoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  Future<List<OrdenPedidoModel>> searchOPSQuery(String query) async {
    try {
      String? querys = await Preferences.readData('queryOP');

      final Database db = await dbprovider.getDatabase();
      List<OrdenPedidoModel> list = [];
      List<Map> maps = await db.rawQuery(
          "$querys AND (fechaCreacion LIKE '%$query%' OR monedaOP LIKE '%$query%' OR opVencimiento LIKE '%$query%' OR nombreProveedor LIKE '%$query%' OR rucProveedor LIKE '%$query%' OR nombreSede LIKE '%$query%' OR condicionesOP LIKE '%$query%' OR nombrePerson LIKE '%$query%' OR surnamePerson LIKE '%$query%') ");

      if (maps.isNotEmpty) list = OrdenPedidoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      e;
      return [];
    }
  }

  deleteOP(String idOP) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM OrdenPedido WHERE idOP='$idOP'");

    return res;
  }
}
