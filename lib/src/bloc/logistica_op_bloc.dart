import 'package:new_brunner_app/src/api/Logistica/logistica_api.dart';
import 'package:new_brunner_app/src/model/Logistica/empresas_model.dart';
import 'package:new_brunner_app/src/model/Logistica/orden_pedido_model.dart';
import 'package:new_brunner_app/src/model/Logistica/proveedores_model.dart';
import 'package:rxdart/subjects.dart';

class LogisticaOPBloc {
  final _api = LogisticaApi();

  final _empresasController = BehaviorSubject<List<EmpresasModel>>();
  Stream<List<EmpresasModel>> get empresasStream => _empresasController.stream;

  final _proveedoresController = BehaviorSubject<List<ProveedoresModel>>();
  Stream<List<ProveedoresModel>> get proveedoresStream => _proveedoresController.stream;

  final _opsController = BehaviorSubject<List<OrdenPedidoModel>>();
  Stream<List<OrdenPedidoModel>> get opsStream => _opsController.stream;

  dispose() {
    _empresasController.close();
    _proveedoresController.close();
    _opsController.close();
  }

  void getDataFiltro(String fecha) async {
    _empresasController.sink.add(await _api.empresaDB.getEmpresas());
    _proveedoresController.sink.add(await _api.proveedoresDB.getProveedores());
    await _api.getOrdenesPedido(fecha, fecha, '', true);
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

  void getOPSFiltro(
      String empresa, String proveedor, String numberOP, String estado, String rendicion, String fechaInicial, String fechaFinal) async {
    _opsController.sink.add(await _api.opDB.getOPSFiltro(empresa, proveedor, numberOP, estado, rendicion, fechaInicial, fechaFinal));
    await _api.getOrdenesPedido(fechaInicial, fechaFinal, numberOP, false);
    _opsController.sink.add(await _api.opDB.getOPSFiltro(empresa, proveedor, numberOP, estado, rendicion, fechaInicial, fechaFinal));
  }
}
