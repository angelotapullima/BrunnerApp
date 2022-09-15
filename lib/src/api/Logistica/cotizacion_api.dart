import 'dart:convert';

import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/database/Logistica/Cotizacion/recurso_cotizacion_database.dart';
import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/model/Logistica/Cotizacion/recurso_cotizacion_model.dart';

class CotizacionApi {
  final recursoCotizacionDB = RecursoCotizacionDatabase();

  Future<List<RecursoCotizacionModel>> getOrdenesPedido(String query) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/Cotizacion/buscar_recursos_repuestos_app');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'recurso_buscar': query,
        },
      );

      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        final List<RecursoCotizacionModel> listRecursos = [];

        //Insertar Ordenes Pedido
        for (var i = 0; i < decodedData["result"]["recursos"].length; i++) {
          final data = decodedData["result"]["recursos"][i];

          final recurso = RecursoCotizacionModel();
          recurso.idLogisticaRecurso = data["id_logistica_recurso"];
          recurso.idClase = data["id_logistica_clase"];
          recurso.nameRecurso = data["logistica_recurso_nombre"];
          recurso.unidadRecurso = data["logistica_recurso_unidad"];
          recurso.idTypeLogistica = data["id_logistica_tipo"];
          recurso.nameClase = data["logistica_clase_nombre"];
          recurso.nameType = data["logistica_tipo_nombre"];

          listRecursos.add(recurso);

          //await recursoCotizacionDB.insertarRecurso(recurso);
        }
        return listRecursos;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
