import 'dart:convert';

import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Ejecucion%20Servicio/oes_database.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Ejecucion%20Servicio/pos_database.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Consulta%20Informacion%20OE/oes_model.dart';

class ConsultaOE {
  final oesDB = OESDatabase();
  final posDB = POSDatabase();
  Future<int> getDataPedientes() async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/Ejecucion/listar_pendientes_oes_pos_app');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
        },
      );

      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);

        for (var i = 0; i < decodedData["oes"].length; i++) {
          var data = decodedData["oes"][i];
          final oes = OESModel();
          oes.idEjecucion = data["id_ejecucion"];
        }
      }

      return 2;
    } catch (e) {
      return 2;
    }
  }
}
