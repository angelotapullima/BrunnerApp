import 'package:new_brunner_app/src/api/Mantenimiento/inspeccion_api.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_model.dart';
import 'package:rxdart/rxdart.dart';

class ConsultaInspeccionBloc {
  final _api = InspeccionApi();

  final _inpeccionesController = BehaviorSubject<List<InspeccionVehiculoModel>>();
  Stream<List<InspeccionVehiculoModel>> get inspeccionesStream => _inpeccionesController.stream;

  final _cargandoController = BehaviorSubject<bool>();
  Stream<bool> get cargandoStream => _cargandoController.stream;

  dispose() {
    _inpeccionesController.close();
    _cargandoController.close();
  }

  void getInspeccionesVehiculo(String fechaInicial, String fechaFinal, String placaMarca, String operario, String estado, String nroCheck) async {
    _inpeccionesController.sink.add([]);
    //_inpeccionesController.sink.add(await _api.inspeccionDB.getInspeccionFiltro(fechaInicial, fechaFinal, placaMarca, operario, estado, nroCheck));
    _cargandoController.sink.add(true);
    await _api.getInspeccionesVehiculos(fechaInicial, fechaFinal);
    _cargandoController.sink.add(false);
    _inpeccionesController.sink.add(await _api.inspeccionDB.getInspeccionFiltro(fechaInicial, fechaFinal, placaMarca, operario, estado, nroCheck));
  }

  void limpiarSearch() {
    _inpeccionesController.sink.add([]);
  }
}
