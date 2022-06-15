import 'package:new_brunner_app/src/api/Mantenimiento/mantenimiento_correctivo_api.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/personas_model.dart';
import 'package:rxdart/rxdart.dart';

class PersonasBloc {
  final _api = MantenimientoCorrectivoApi();

  final _searchController = BehaviorSubject<List<PersonasModel>>();
  Stream<List<PersonasModel>> get searchStream => _searchController.stream;

  dispose() {
    _searchController.close();
  }

  void searchPersons(String query) async {
    _searchController.sink.add([]);
    if (query.isNotEmpty) {
      _searchController.sink.add(await _api.personaDB.getPersonasByQuery(query));
    } else {
      _searchController.sink.add(await _api.personaDB.getPersonas());
    }
  }

  void searchPersonasMantenimiento(String query) async {
    if (query.isEmpty) {
      _searchController.sink.add(await _api.personaDB.getPersonasMantenimiento());
      await _api.getData(query);
      _searchController.sink.add(await _api.personaDB.getPersonasMantenimiento());
    } else {
      _searchController.sink.add(await _api.personaDB.getPersonasMantenimientoByQuery(query));
    }
  }
}
