import 'package:new_brunner_app/src/database/Mantenimiento/choferes_database.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/choferes_model.dart';
import 'package:rxdart/rxdart.dart';

class CheckListBloc {
  final _choferesDB = ChoferesDatabase();

  final _choferesController = BehaviorSubject<List<ChoferesModel>>();
  Stream<List<ChoferesModel>> get choferesStream => _choferesController.stream;

  dispose() {
    _choferesController.close();
  }

  void searchVehiculos(String query) async {
    _choferesController.sink.add([]);
    if (query.isNotEmpty) {
      _choferesController.sink.add(await _choferesDB.getChoferesByQuery(query));
    } else {
      _choferesController.sink.add(await _choferesDB.getChoferes());
    }
  }
}
