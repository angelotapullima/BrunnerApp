import 'package:new_brunner_app/src/api/Mantenimiento/inspeccion_api.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_model.dart';
import 'package:rxdart/rxdart.dart';

class ConsultaInspeccionBloc {
  final _api = InspeccionApi();

  final _inpeccionesController = BehaviorSubject<List<InspeccionVehiculoModel>>();
  Stream<List<InspeccionVehiculoModel>> get inspeccionesStream => _inpeccionesController.stream;

  dispose() {
    _inpeccionesController.close();
  }

  void getInspeccionesVehiculo() async {}
}
