import 'package:new_brunner_app/src/api/Logistica/orden_pedido_api.dart';
import 'package:new_brunner_app/src/model/Empresa/empresas_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Orden%20Pedido/orden_pedido_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Orden%20Pedido/proveedores_model.dart';
import 'package:rxdart/subjects.dart';

class LogisticaOPBloc {
  final _api = LogisticaApi();

  final _empresasController = BehaviorSubject<List<EmpresasModel>>();
  Stream<List<EmpresasModel>> get empresasStream => _empresasController.stream;

  final _proveedoresController = BehaviorSubject<List<ProveedoresModel>>();
  Stream<List<ProveedoresModel>> get proveedoresStream => _proveedoresController.stream;

  final _opsController = BehaviorSubject<List<OrdenPedidoModel>>();
  Stream<List<OrdenPedidoModel>> get opsStream => _opsController.stream;

  final _detalleOPController = BehaviorSubject<List<OrdenPedidoModel>>();
  Stream<List<OrdenPedidoModel>> get detalleOPStream => _detalleOPController.stream;

  final _opsPendientesController = BehaviorSubject<List<OrdenPedidoModel>>();
  Stream<List<OrdenPedidoModel>> get opsPendientesStream => _opsPendientesController.stream;

  //Controlador para mostrar que se está cargando la consulta
  final _cargandoController = BehaviorSubject<bool>();
  Stream<bool> get cargandoStream => _cargandoController.stream;

  final _cargando2Controller = BehaviorSubject<bool>();
  Stream<bool> get cargando2Stream => _cargando2Controller.stream;

  dispose() {
    _empresasController.close();
    _proveedoresController.close();
    _opsController.close();
    _cargandoController.close();
    _detalleOPController.close();
    _cargando2Controller.close();
    _opsPendientesController.close();
  }

  void getDataFiltro() async {
    _empresasController.sink.add(await _api.empresaDB.getEmpresas());
    _proveedoresController.sink.add(await _api.proveedoresDB.getProveedores());
    await _api.getEmpresasProveedores();
    _empresasController.sink.add(await _api.empresaDB.getEmpresas());
    _proveedoresController.sink.add(await _api.proveedoresDB.getProveedores());
  }

  void getProveedoresByQuery(String query) async {
    if (query.isEmpty) {
      _proveedoresController.sink.add(await _api.proveedoresDB.getProveedores());
    } else {
      _proveedoresController.sink.add(await _api.proveedoresDB.getProveedoresByQuery(query));
    }
  }

  void getDetalleOP(String idOP, String rendido) async {
    _detalleOPController.sink.add(await detalleOP(idOP));
    _cargando2Controller.sink.add(true);
    await _api.getDetalleOP(idOP, rendido);
    _cargando2Controller.sink.add(false);
    _detalleOPController.sink.add(await detalleOP(idOP));
  }

  void getOPSFiltro(
      String empresa, String proveedor, String numberOP, String estado, String rendicion, String fechaInicial, String fechaFinal) async {
    if (numberOP.isEmpty) {
      final data = await _api.opDB.getOPSFiltro(empresa, proveedor, estado, rendicion, fechaInicial, fechaFinal);
      _opsController.sink.add(data);
      if (data.isEmpty) _cargandoController.sink.add(true);
      await _api.getOrdenesPedido(fechaInicial, fechaFinal, numberOP);
      _cargandoController.sink.add(false);
      _opsController.sink.add(await _api.opDB.getOPSFiltro(empresa, proveedor, estado, rendicion, fechaInicial, fechaFinal));
    } else {
      final data = await _api.opDB.getOPSByNumber(numberOP);
      _opsController.sink.add(data);

      if (data.isEmpty) _cargandoController.sink.add(true);
      await _api.getOrdenesPedido(fechaInicial, fechaFinal, numberOP);
      _cargandoController.sink.add(false);
      _opsController.sink.add(await _api.opDB.getOPSByNumber(numberOP));
    }
  }

  void clearOPS() async {
    _opsController.sink.add([]);
  }

  void getOPSQuery() async {
    _opsController.sink.add([]);
    _opsController.sink.add(await _api.opDB.getOPSQuery());
  }

  void searchOPSQuery(String query) async {
    if (query.isEmpty) {
      _opsController.sink.add(await _api.opDB.getOPSQuery());
    } else {
      _opsController.sink.add(await _api.opDB.searchOPSQuery(query));
    }
  }

  void getOPSPendientes() async {
    final data = await _api.opDB.getOPSPendientes();
    _opsPendientesController.sink.add(data);
    _cargandoController.sink.add(true);
    await _api.listarOPPendientes();
    _cargandoController.sink.add(false);
    _opsPendientesController.sink.add(await _api.opDB.getOPSPendientes());
  }

  void searchOPSPendientes(String query) async {
    if (query.isEmpty) {
      _opsPendientesController.sink.add(await _api.opDB.getOPSPendientes());
    } else {
      _opsPendientesController.sink.add(await _api.opDB.searchOPSPendientes(query));
    }
  }

  Future<List<OrdenPedidoModel>> detalleOP(String idOP) async {
    final List<OrdenPedidoModel> result = [];
    final _opDB = await _api.opDB.getOPSByidOP(idOP);
    if (_opDB.isNotEmpty) {
      final proveedorDB = await _api.proveedoresDB.getProveedorById(_opDB[0].idProveedor.toString());
      final empresaDB = await _api.empresaDB.getEmpresaByName(_opDB[0].nombreEmpresa.toString());

      final op = OrdenPedidoModel();

      op.idOP = _opDB[0].idOP;
      op.numeroOP = _opDB[0].numeroOP;
      op.nombreEmpresa = _opDB[0].nombreEmpresa;
      op.nombreSede = _opDB[0].nombreSede;
      op.idProveedor = _opDB[0].idProveedor;
      op.nombreProveedor = _opDB[0].nombreProveedor;
      op.monedaOP = _opDB[0].monedaOP;
      op.totalOP = _opDB[0].totalOP;
      op.fechaOP = _opDB[0].fechaOP;
      op.nombrePerson = _opDB[0].nombrePerson;
      op.surnamePerson = _opDB[0].surnamePerson;
      op.surname2Person = _opDB[0].surname2Person;
      op.nombreApro = _opDB[0].nombreApro;
      op.surnameApro = _opDB[0].surnameApro;
      op.surname2Apro = _opDB[0].surname2Apro;
      op.fechaCreacion = _opDB[0].fechaCreacion;
      op.estado = _opDB[0].estado;
      op.rendido = _opDB[0].rendido;
      op.departamento = _opDB[0].departamento;
      op.condicionesOP = _opDB[0].condicionesOP;
      op.detalle = await _api.detalleOPDB.getDetalleOPByidOP(idOP);
      if (empresaDB.isNotEmpty) {
        op.empresa = empresaDB[0];
      }
      if (proveedorDB.isNotEmpty) {
        op.proveedor = proveedorDB[0];
      }

      result.add(op);
    }
    return result;
  }
}
