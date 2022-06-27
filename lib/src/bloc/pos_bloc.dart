import 'package:new_brunner_app/src/api/Residuo%20Solido/ejecucion_servicio_api.dart';
import 'package:new_brunner_app/src/model/Empresa/departamento_model.dart';
import 'package:new_brunner_app/src/model/Empresa/empresas_model.dart';
import 'package:new_brunner_app/src/model/Empresa/sede_model.dart';
import 'package:rxdart/rxdart.dart';

class POSBloc {
  final _apiES = EjecucionServicioApi();

  final _empresasController = BehaviorSubject<List<EmpresasModel>>();
  Stream<List<EmpresasModel>> get empresasStream => _empresasController.stream;

  final _departamentosController = BehaviorSubject<List<DepartamentoModel>>();
  Stream<List<DepartamentoModel>> get departamentosStream => _departamentosController.stream;

  final _sedesController = BehaviorSubject<List<SedeModel>>();
  Stream<List<SedeModel>> get sedesStream => _sedesController.stream;

  //Controlador para mostrar que se está cargando la consulta
  final _cargandoController = BehaviorSubject<bool>();
  Stream<bool> get cargandoStream => _cargandoController.stream;

  void dispose() {
    _empresasController.close();
    _departamentosController.close();
    _sedesController.close();
    _cargandoController.close();
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
}
