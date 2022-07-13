import 'package:new_brunner_app/src/core/ConfigDatabase/consulta_oe_db.dart';
import 'package:new_brunner_app/src/core/ConfigDatabase/empresa_db.dart';
import 'package:new_brunner_app/src/core/ConfigDatabase/logistica_db.dart';
import 'package:new_brunner_app/src/core/ConfigDatabase/mantenimiento_db.dart';
import 'package:new_brunner_app/src/core/ConfigDatabase/modulos_db.dart';
import 'package:new_brunner_app/src/core/ConfigDatabase/orden_ejecucion_db.dart';
import 'package:new_brunner_app/src/core/ConfigDatabase/vehiculos_db.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await getDatabase();

  Future<Database> getDatabase() async {
    final String path = join(await getDatabasesPath(), 'brunner.db');
    return openDatabase(path, onCreate: (db, version) {
      //Menu
      db.execute(ModulosDB.modulosTableSql);
      db.execute(ModulosDB.submodulosTableSql);

      //Mantenimiento
      db.execute(VehiculosDB.vehiculosTableSql);
      db.execute(VehiculosDB.peronasTableSql);
      db.execute(VehiculosDB.categoriasInspeccionTableSql);
      db.execute(VehiculosDB.itemInspeccionTableSql);
      db.execute(MantenimientoDB.checkItemInspeccionTableSql);
      db.execute(MantenimientoDB.inspeccionVehiculosTableSql);
      db.execute(MantenimientoDB.inspeccionVehiculoItemTableSql);

      //Mantenimiento Correctivo
      db.execute(MantenimientoDB.inspeccionVehiculoDetalleTableSql);
      db.execute(MantenimientoDB.mantenimientoCorrectivoTableSql);

      //Empresa
      db.execute(EmpresaDB.empresasTableSql);
      db.execute(EmpresaDB.departamentoTableSql);
      db.execute(EmpresaDB.sedeTableSql);
      db.execute(EmpresaDB.tipoDocTableSql);

      //Logistica
      //--> Orden Pedido
      db.execute(LogisticaDB.proveedoresTableSql);
      db.execute(LogisticaDB.ordenPedidoTableSql);
      db.execute(LogisticaDB.detalleOrdenPedidoTableSql);

      //--> Almacen
      db.execute(LogisticaDB.recursosAlmacenTableSql);
      db.execute(LogisticaDB.dniPersonalAlmacenTableSql);
      db.execute(LogisticaDB.recursoLogisticaTableSql);
      db.execute(LogisticaDB.ordenAlmacenTableSql);
      db.execute(LogisticaDB.productosOrdenTableSql);

      //Residuos Solidos - Orden Ejecucion
      db.execute(OrdenEjecucionDB.clientesOETableSql);
      db.execute(OrdenEjecucionDB.contactosOETableSql);
      db.execute(OrdenEjecucionDB.codigosOETableSql);
      db.execute(OrdenEjecucionDB.lugaresOETableSql);
      db.execute(OrdenEjecucionDB.actividadesOETableSql);
      db.execute(OrdenEjecucionDB.ordenEjecucionTableSql);
      db.execute(OrdenEjecucionDB.personalOETableSql);
      db.execute(OrdenEjecucionDB.unidadesOETableSql);
      db.execute(ConsultaOEDB.oesTableSql);
      db.execute(ConsultaOEDB.posTableSql);
      //
    }, version: 1, onDowngrade: onDatabaseDowngradeDelete);
  }
}
