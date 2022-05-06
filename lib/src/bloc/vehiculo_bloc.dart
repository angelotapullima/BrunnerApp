import 'package:new_brunner_app/src/api/Mantenimiento/mantenimiento_api.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/vehiculo_model.dart';
import 'package:rxdart/rxdart.dart';

class VehiculoBloc {
  final _api = MantenimientoApi();

  final _searchVehiculoController = BehaviorSubject<List<VehiculoModel>>();
  Stream<List<VehiculoModel>> get searchVehiculoStream => _searchVehiculoController.stream;

  dispose() {
    _searchVehiculoController.close();
  }

  void cargarVehiculos() async {
    _searchVehiculoController.sink.add([]);
    await _api.getVehiculos();
  }

  void searchVehiculos(String query) async {
    _searchVehiculoController.sink.add([]);
    if (query.isNotEmpty) {
      _searchVehiculoController.sink.add(await _api.vehiculosDB.getVehiculosQuery(query));
    } else {
      _searchVehiculoController.sink.add(await _api.vehiculosDB.getVehiculos());
    }
    await _api.getVehiculos();
  }
}
