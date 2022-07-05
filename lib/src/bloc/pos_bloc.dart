import 'package:new_brunner_app/src/api/Residuo%20Solido/ejecucion_servicio_api.dart';
import 'package:new_brunner_app/src/api/Residuo%20Solido/pos_api.dart';
import 'package:new_brunner_app/src/model/Empresa/departamento_model.dart';
import 'package:new_brunner_app/src/model/Empresa/empresas_model.dart';
import 'package:new_brunner_app/src/model/Empresa/sede_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/clientes_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/orden_ejecucion_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/personal_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/unidades_oe_model.dart';
import 'package:rxdart/rxdart.dart';

class POSBloc {
  final _apiES = EjecucionServicioApi();
  final _api = POSApi();

  final _empresasController = BehaviorSubject<List<EmpresasModel>>();
  Stream<List<EmpresasModel>> get empresasStream => _empresasController.stream;

  final _departamentosController = BehaviorSubject<List<DepartamentoModel>>();
  Stream<List<DepartamentoModel>> get departamentosStream => _departamentosController.stream;

  final _sedesController = BehaviorSubject<List<SedeModel>>();
  Stream<List<SedeModel>> get sedesStream => _sedesController.stream;

  //Controlador para mostrar que se está cargando la consulta
  final _cargandoController = BehaviorSubject<bool>();
  Stream<bool> get cargandoStream => _cargandoController.stream;

  //Streams para Generar Parte Operativa de Servicio
  final _clientesController = BehaviorSubject<List<ClientesOEModel>?>();
  Stream<List<ClientesOEModel>?> get clientesStream => _clientesController.stream;

  final _unidadesController = BehaviorSubject<List<UnidadesOEModel>>();
  Stream<List<UnidadesOEModel>> get unidadesStream => _unidadesController.stream;

  final _personalController = BehaviorSubject<List<PersonalOEModel>>();
  Stream<List<PersonalOEModel>> get personalStream => _personalController.stream;

  final _oeController = BehaviorSubject<List<OrdenEjecucionModel>>();
  Stream<List<OrdenEjecucionModel>> get oesStream => _oeController.stream;

  void dispose() {
    _empresasController.close();
    _departamentosController.close();
    _sedesController.close();
    _cargandoController.close();
    _clientesController.close();
    _unidadesController.close();
    _personalController.close();
    _oeController.close();
  }

  void clearData() {
    _clientesController.sink.add(null);
  }

  void getDataFiltro() async {
    _empresasController.sink.add(await _apiES.empresaDB.getEmpresas());
    _departamentosController.sink.add(await _apiES.departamentoDB.getDepartamentos());
    _sedesController.sink.add(await _apiES.sedeDB.getSedes());
    await _apiES.getFiltrosApi();
    _empresasController.sink.add(await _apiES.empresaDB.getEmpresas());
    _departamentosController.sink.add(await _apiES.departamentoDB.getDepartamentos());
    _sedesController.sink.add(await _apiES.sedeDB.getSedes());
  }

  void getOEClientes(String idEmpresa, String idDepartamento, String idSede) async {
    _clientesController.sink.add([]);
    _cargandoController.sink.add(true);
    _clientesController.sink.add(await _api.getDataPOS(idEmpresa, idDepartamento, idSede));
    _unidadesController.sink.add(await _api.unidadesOEDB.getUnidadesOEByid('${idEmpresa}${idDepartamento}${idSede}'));
    _personalController.sink.add(await _api.personalOEDB.getPersonalOEByid('${idEmpresa}${idDepartamento}${idSede}'));
    _cargandoController.sink.add(false);
  }

  void searchUnidades(String id, String query) async {
    if (query.isNotEmpty) {
      _unidadesController.sink.add(await _api.unidadesOEDB.getUnidadesOEByQuery(id, query));
    } else {
      _unidadesController.sink.add(await _api.unidadesOEDB.getUnidadesOEByid(id));
    }
  }

  void searchOES(String idCliente, String query) async {
    if (query.isNotEmpty) {
      _oeController.sink.add(await _api.oeDB.getOEByQuery(idCliente, query));
    } else {
      _oeController.sink.add(await _api.oeDB.getOEByidCliente(idCliente));
    }
  }

  void searchPersonal(String id, String query) async {
    if (query.isNotEmpty) {
      _personalController.sink.add(await _api.personalOEDB.getPersonalsOEByQuery(id, query));
    } else {
      _personalController.sink.add(await _api.personalOEDB.getPersonalOEByid(id));
    }
  }
}
