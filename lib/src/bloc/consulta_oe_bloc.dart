import 'package:new_brunner_app/src/api/Residuo%20Solido/consulta_oe_api.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Consulta%20Informacion%20OE/oes_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Consulta%20Informacion%20OE/pos_model.dart';
import 'package:rxdart/rxdart.dart';

class ConsultaOEBloc {
  final _api = ConsultaOEApi();

  final _oesController = BehaviorSubject<List<OESModel>>();
  Stream<List<OESModel>> get oesStream => _oesController.stream;

  final _posController = BehaviorSubject<List<POSModel>>();
  Stream<List<POSModel>> get posStream => _posController.stream;

  //Controlador para mostrar que se está cargando la consulta
  final _cargandoController = BehaviorSubject<bool>();
  Stream<bool> get cargandoStream => _cargandoController.stream;

  dispose() {
    _oesController.close();
    _posController.close();
    _cargandoController.close();
  }

  void getOESPendientes() async {
    _oesController.sink.add(await _api.oesDB.getOESPendientes());
    _cargandoController.sink.add(true);
    await _api.getDataPedientes();
    _cargandoController.sink.add(false);
    _oesController.sink.add(await _api.oesDB.getOESPendientes());
  }

  void getPOSPendientes() async {
    _posController.sink.add(await _api.posDB.getPOSPendientes());
    _cargandoController.sink.add(true);
    await _api.getDataPedientes();
    _cargandoController.sink.add(false);
    _posController.sink.add(await _api.posDB.getPOSPendientes());
  }
}
