import 'package:new_brunner_app/src/database/Residuos%20Solidos/Ejecucion%20Servicio/clientes_oe_database.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/clientes_oe_model.dart';
import 'package:rxdart/rxdart.dart';

class ClientesOESearchBloc {
  final clientesDB = ClientesOEDatabase();
  final _clientesSearchController = BehaviorSubject<List<ClientesOEModel>>();
  Stream<List<ClientesOEModel>> get clientesSearchStream => _clientesSearchController.stream;

  void sarchClientesByQuery(String query, String id) async {
    if (query.isEmpty) {
      _clientesSearchController.sink.add(await clientesDB.getClientesOE(id));
    } else {
      _clientesSearchController.sink.add(await clientesDB.getClientesOEByQuery(query, id));
    }
  }
}
