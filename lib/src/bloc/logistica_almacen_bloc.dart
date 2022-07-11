import 'package:new_brunner_app/src/api/Logistica/almacen_api.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/personal_dni_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/recurso_logistica_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/recursos_almacen_model.dart';
import 'package:rxdart/rxdart.dart';

class LogisticaAlmacenBloc {
  final _api = AlmacenApi();

  final _recursosController = BehaviorSubject<List<RecursosAlmacenModel>>();
  Stream<List<RecursosAlmacenModel>> get recursosStream => _recursosController.stream;

  final _personasController = BehaviorSubject<List<PersonalDNIModel>>();
  Stream<List<PersonalDNIModel>> get personasStream => _personasController.stream;

  final _recursosIngresoController = BehaviorSubject<List<RecursoLogisticaModel>>();
  Stream<List<RecursoLogisticaModel>> get recuLogicticaStream => _recursosIngresoController.stream;

  //Respuesta recursos disponibles
  final _respControlller = BehaviorSubject<int>();
  Stream<int> get respStream => _respControlller.stream;

  //Respuesta recursos disponibles
  final _respRecursoControlller = BehaviorSubject<int>();
  Stream<int> get respRecursoStream => _respRecursoControlller.stream;

  dispose() {
    _recursosController.close();
    _personasController.close();
    _respControlller.close();
    _respRecursoControlller.close();
    _recursosIngresoController.close();
  }

  void getDataSalidaAlmacen(String idSede) async {
    _recursosController.sink.add(await _api.recursosDB.getRecursosAlmacenByIDSede(idSede));

    _respControlller.sink.add(10); //Cargando
    _respControlller.sink.add(await _api.getRecursosDisponibles(idSede));
    _recursosController.sink.add(await _api.recursosDB.getRecursosAlmacenByIDSede(idSede));
    _personasController.sink.add(await _api.personsDB.getPersons());
  }

  void searchPersons(String query) async {
    if (query.isNotEmpty) {
      _personasController.sink.add(await _api.personsDB.getPersonByQuery(query));
    } else {
      _personasController.sink.add(await _api.personsDB.getPersons());
    }
  }

  void searchRecurso(String idSede, String query) async {
    if (query.isNotEmpty) {
      _recursosController.sink.add(await _api.recursosDB.getRecursosAlmacenByIDSedeANDQuery(idSede, query));
    } else {
      _recursosController.sink.add(await _api.recursosDB.getRecursosAlmacenByIDSede(idSede));
    }
  }

  void updateResp(int v) async {
    _respControlller.sink.add(v);
    await _api.getPersonas();
  }

  void getRecursosIngreso(String idSede, String val) async {
    _respRecursoControlller.sink.add(10);
    _respRecursoControlller.sink.add(await _api.getRecursosIngreso(idSede, val));
    _recursosIngresoController.sink.add(await _api.recuLogisticaDB.getRecursosLogisticaByIDSede(idSede));
  }

  void searchRecursoIngreso(String idSede, String query) async {
    if (query.isEmpty) {
      _recursosIngresoController.sink.add(await _api.recuLogisticaDB.getRecursosLogisticaByIDSede(idSede));
    } else {
      _recursosIngresoController.sink.add(await _api.recuLogisticaDB.getRecursosLogisticaByIDSedeANDQuery(idSede, query));
    }
  }
}