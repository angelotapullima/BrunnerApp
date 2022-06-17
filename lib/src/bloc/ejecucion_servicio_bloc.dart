import 'package:new_brunner_app/src/api/Residuo%20Solido/ejecucion_servicio_api.dart';
import 'package:new_brunner_app/src/model/Empresa/clientes_model.dart';
import 'package:new_brunner_app/src/model/Empresa/departamento_model.dart';
import 'package:new_brunner_app/src/model/Empresa/empresas_model.dart';
import 'package:new_brunner_app/src/model/Empresa/sede_model.dart';
import 'package:rxdart/rxdart.dart';

class EjecucionServicioBloc {
  final _api = EjecucionServicioApi();

  final _empresasController = BehaviorSubject<List<EmpresasModel>>();
  Stream<List<EmpresasModel>> get empresasStream => _empresasController.stream;

  final _departamentosController = BehaviorSubject<List<DepartamentoModel>>();
  Stream<List<DepartamentoModel>> get departamentosStream => _departamentosController.stream;

  final _sedesController = BehaviorSubject<List<SedeModel>>();
  Stream<List<SedeModel>> get sedesStream => _sedesController.stream;

  final _clientesController = BehaviorSubject<List<ClientesModel>?>();
  Stream<List<ClientesModel>?> get clientesStream => _clientesController.stream;

  //Controlador para mostrar que se está cargando la consulta
  final _cargandoController = BehaviorSubject<bool>();
  Stream<bool> get cargandoStream => _cargandoController.stream;

  dispose() {
    _empresasController.close();
    _departamentosController.close();
    _sedesController.close();
    _clientesController.close();
    _cargandoController.close();
  }

  void getDataFiltro() async {
    _empresasController.sink.add(await _api.empresaDB.getEmpresas());
    _departamentosController.sink.add(await _api.departamentoDB.getDepartamentos());
    _sedesController.sink.add(await _api.sedeDB.getSedes());
    await _api.getFiltrosApi();
    _empresasController.sink.add(await _api.empresaDB.getEmpresas());
    _departamentosController.sink.add(await _api.departamentoDB.getDepartamentos());
    _sedesController.sink.add(await _api.sedeDB.getSedes());
  }

  void getActividadesClientes(String idEmpresa, String idDepartamento, String idSede) async {
    _clientesController.sink.add(null);
    _cargandoController.sink.add(true);
    _clientesController.sink.add(await _api.getActividadesORDEJEC(idEmpresa, idDepartamento, idSede));
    _cargandoController.sink.add(false);
  }
}
