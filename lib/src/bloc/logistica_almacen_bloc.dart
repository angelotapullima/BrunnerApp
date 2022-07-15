import 'package:new_brunner_app/src/api/Logistica/almacen_api.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/orden_almacen_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/personal_dni_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/productos_orden_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/recurso_logistica_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/recursos_almacen_model.dart';
import 'package:rxdart/rxdart.dart';

class LogisticaAlmacenBloc {
  final _api = AlmacenApi();

  final _recursosController = BehaviorSubject<List<RecursosAlmacenModel>>();
  Stream<List<RecursosAlmacenModel>> get recursosStream => _recursosController.stream;

  final _personasController = BehaviorSubject<List<PersonalDNIModel>>();
  Stream<List<PersonalDNIModel>> get personasStream => _personasController.stream;

  final _recursosIngresoController = BehaviorSubject<List<RecursoLogisticaModel>>();
  Stream<List<RecursoLogisticaModel>> get recuLogicticaStream => _recursosIngresoController.stream;

  //Notas Pendientes de Aprobacion
  final _notasPendientesController = BehaviorSubject<List<OrdenAlmacenModel>>();
  Stream<List<OrdenAlmacenModel>> get notasPStrean => _notasPendientesController.stream;

  //Ordenes Generadas
  final _ordenesGeneradasController = BehaviorSubject<List<OrdenAlmacenModel>>();
  Stream<List<OrdenAlmacenModel>> get ordenGeneradasStrean => _ordenesGeneradasController.stream;

  //Detalle Orden
  final _detalleOrdenController = BehaviorSubject<List<OrdenAlmacenModel>>();
  Stream<List<OrdenAlmacenModel>> get detalleOrdenStrean => _detalleOrdenController.stream;

  //Respuesta recursos disponibles
  final _respController = BehaviorSubject<int>();
  Stream<int> get respStream => _respController.stream;

  final _respPendientesController = BehaviorSubject<int>();
  Stream<int> get respPendientesStream => _respPendientesController.stream;

  final _respGeneradasController = BehaviorSubject<int>();
  Stream<int> get respGeneradasStream => _respGeneradasController.stream;

  final _respDetalleController = BehaviorSubject<int>();
  Stream<int> get respDetalleStream => _respDetalleController.stream;

  //Respuesta recursos disponibles
  final _respRecursoControlller = BehaviorSubject<int>();
  Stream<int> get respRecursoStream => _respRecursoControlller.stream;

  dispose() {
    _recursosController.close();
    _personasController.close();
    _respController.close();
    _respRecursoControlller.close();
    _recursosIngresoController.close();
    _notasPendientesController.close();
    _respPendientesController.close();
    _detalleOrdenController.close();
    _respDetalleController.close();
    _respGeneradasController.close();
    _ordenesGeneradasController.close();
  }

  void getDataSalidaAlmacen(String idSede) async {
    _recursosController.sink.add(await _api.recursosDB.getRecursosAlmacenByIDSede(idSede));

    _respController.sink.add(10); //Cargando
    _respController.sink.add(await _api.getRecursosDisponibles(idSede));
    _recursosController.sink.add(await _api.recursosDB.getRecursosAlmacenByIDSede(idSede));
    _personasController.sink.add(await _api.personsDB.getPersons());
  }

  void searchPersons(String query) async {
    if (query.isNotEmpty) {
      _personasController.sink.add(await _api.personsDB.getPersonByQuery(query));
    } else {
      _personasController.sink.add(await _api.personsDB.getPersons());
    }
  }

  void searchRecurso(String idSede, String query) async {
    if (query.isNotEmpty) {
      _recursosController.sink.add(await _api.recursosDB.getRecursosAlmacenByIDSedeANDQuery(idSede, query));
    } else {
      _recursosController.sink.add(await _api.recursosDB.getRecursosAlmacenByIDSede(idSede));
    }
  }

  void updateResp(int v) async {
    _respController.sink.add(v);
    await _api.getPersonas();
  }

  void updateRespGeneradas(int v) async {
    _respGeneradasController.sink.add(v);
  }

  void getRecursosIngreso(String idSede, String val) async {
    _respRecursoControlller.sink.add(10);
    _respRecursoControlller.sink.add(await _api.getRecursosIngreso(idSede, val));
    _recursosIngresoController.sink.add(await _api.recuLogisticaDB.getRecursosLogisticaByIDSede(idSede));
  }

  void searchRecursoIngreso(String idSede, String query) async {
    if (query.isEmpty) {
      _recursosIngresoController.sink.add(await _api.recuLogisticaDB.getRecursosLogisticaByIDSede(idSede));
    } else {
      _recursosIngresoController.sink.add(await _api.recuLogisticaDB.getRecursosLogisticaByIDSedeANDQuery(idSede, query));
    }
  }

  //Notas Pendientes Aprobación

  void getNotasPendientes(String idSede, String tipo) async {
    _notasPendientesController.sink.add(await _api.ordenAlmacenDB.getOrdenesPendientesFiltro(idSede, tipo));
    _respPendientesController.sink.add(10);
    _respPendientesController.sink.add(await _api.getNotasPendientesAprobacion(idSede, tipo));
    _notasPendientesController.sink.add(await _api.ordenAlmacenDB.getOrdenesPendientesFiltro(idSede, tipo));
  }

  void getOrdenesGeneradas(String idSede, String tipo, String entrega, String numero, String inicio, String fin) async {
    _ordenesGeneradasController.sink.add(await _api.ordenAlmacenDB.getOrdenesGeneradasFiltro(idSede, tipo, entrega, numero));
    _respGeneradasController.sink.add(10);
    _respGeneradasController.sink.add(await _api.getOrdenesGeneradas(idSede, tipo, entrega, numero, inicio, fin));
    _ordenesGeneradasController.sink.add(await _api.ordenAlmacenDB.getOrdenesGeneradasFiltro(idSede, tipo, entrega, numero));
  }

  void getDetalleOrden(String idAlmacenLog) async {
    _detalleOrdenController.sink.add(await detalle(idAlmacenLog));
    _respDetalleController.sink.add(0);
    _respDetalleController.sink.add(await _api.getDetalleOrden(idAlmacenLog));
    _detalleOrdenController.sink.add(await detalle(idAlmacenLog));
  }

  Future<List<OrdenAlmacenModel>> detalle(String idAlmacenLog) async {
    final List<OrdenAlmacenModel> result = [];

    final detalle = await _api.ordenAlmacenDB.getOrdenById(idAlmacenLog);

    final List<ProductosOrdenModel> products = [];
    final p = await _api.productOrdenDB.getProductosOrden(idAlmacenLog);
    products.addAll(p);

    if (products.isNotEmpty) {
      final r = OrdenAlmacenModel();
      r.idAlmacenLog = detalle[0].idAlmacenLog;
      r.idSede = detalle[0].idSede;
      r.codigoAlmacenLog = detalle[0].codigoAlmacenLog;
      r.tipoAlmacenLog = detalle[0].tipoAlmacenLog;
      r.comentarioAlmacenLog = detalle[0].comentarioAlmacenLog;
      r.dniSoliAlmacenLog = detalle[0].dniSoliAlmacenLog;
      r.nombreSoliAlmacenLog = detalle[0].nombreSoliAlmacenLog;
      r.fechaAlmacenLog = detalle[0].fechaAlmacenLog;
      r.horaAlmacenLog = detalle[0].horaAlmacenLog;
      r.aprobacionAlmacenLog = detalle[0].aprobacionAlmacenLog;
      r.idUserAprobacion = detalle[0].idUserAprobacion;
      r.estadoAlmacenLog = detalle[0].estadoAlmacenLog;
      r.entregaAlmacenLog = detalle[0].entregaAlmacenLog;
      r.horaEntregaAlmacenLog = detalle[0].horaEntregaAlmacenLog;
      r.personaEntregaAlmacenLog = detalle[0].personaEntregaAlmacenLog;
      r.idOPAlmacenLog = detalle[0].idOPAlmacenLog;
      r.idSIAlmacenLog = detalle[0].idSIAlmacenLog;
      r.destinoAlmacenLog = detalle[0].destinoAlmacenLog;
      r.nombreSede = detalle[0].nombreSede;
      r.nombreUserCreacion = detalle[0].nombreUserCreacion;
      r.idUserCreacion = detalle[0].idUserCreacion;
      r.products = products;

      result.add(r);
    }
    return result;
  }
}
