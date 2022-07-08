import 'package:new_brunner_app/src/api/Logistica/almacen_api.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/personal_dni_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/recursos_almacen_model.dart';
import 'package:rxdart/rxdart.dart';

class LogisticaAlmacenBloc {
  final _api = AlmacenApi();

  final _recursosController = BehaviorSubject<List<RecursosAlmacenModel>>();
  Stream<List<RecursosAlmacenModel>> get recursosStream => _recursosController.stream;

  final _personasController = BehaviorSubject<List<PersonalDNIModel>>();
  Stream<List<PersonalDNIModel>> get personasStream => _personasController.stream;

  dispose() {
    _recursosController.close();
    _personasController.close();
  }

  void getDataSalidaAlmacen(String idSede) async {
    _recursosController.sink.add(await _api.recursosDB.getRecursosAlmacenByIDSede(idSede));
    await _api.getRecursosDisponibles(idSede);
    _recursosController.sink.add(await _api.recursosDB.getRecursosAlmacenByIDSede(idSede));
  }
}
