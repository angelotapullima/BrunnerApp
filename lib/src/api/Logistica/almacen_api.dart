import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/database/Logistica/Almacen/personal_dni_database.dart';
import 'package:new_brunner_app/src/database/Logistica/Almacen/recursos_almacen_database.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/personal_dni_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/recursos_almacen_model.dart';

class AlmacenApi {
  final recursosDB = RecursosAlmacenDatabase();
  final personsDB = PersonalDNIDatabase();

  Future<int> getRecursosDisponibles(String idSede) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/Almacen/listar_recursos_existentes_almacen');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id_sede': idSede,
        },
      );

      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);

        for (var i = 0; i < decodedData["result"]["recursos"].length; i++) {
          var r = decodedData["result"]["recursos"][i];
          final recurso = RecursosAlmacenModel();
          recurso.idAlmacen = r["id_almacen"];
          recurso.idSede = r["id_sede"];
          recurso.idRecursoLogistica = r["id_logistica_recurso"];
          recurso.idTipoRecurso = r["id_recurso_tipo"];
          recurso.unidadAlmacen = r["almacen_unidad"];
          recurso.stockAlmacen = r["almacen_stock"];
          recurso.descripcionAlmacen = r["almacen_descripcion"];
          recurso.ubicacionAlmacen = r["almacen_ubicacion"];
          recurso.idClaseLogistica = r["id_logistica_clase"];
          recurso.nombreRecurso = r["logistica_recurso_nombre"];
          recurso.unidadRecurso = r["logistica_recurso_unidad"];
          recurso.idTipoLogistica = r["id_logistica_tipo"];
          recurso.nombreClaseLogistica = r["logistica_clase_nombre"];
          recurso.nombreTipoLogistica = r["logistica_tipo_nombre"];
          recurso.nombreTipoRecurso = r["recurso_tipo_nombre"];
          recurso.estadoTipoRecurso = r["recurso_tipo_estado"];

          await recursosDB.insertarRecurso(recurso);
        }
        return decodedData["result"]["code"];
      } else {
        return 3;
      }
    } catch (e) {
      return 2;
    }
  }

  Future<int> getPersonas() async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/Almacen/listar_dni_personal');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
        },
      );

      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);

        for (var i = 0; i < decodedData["result"]["personas"]; i++) {
          var p = decodedData["result"]["personas"][i];
          final person = PersonalDNIModel();
          person.name = p["person_name"];
          person.surname = p["person_surname"];
          person.surmane2 = p["person_surname2"];
          person.dni = p["person_dni"];

          await personsDB.insertarPerson(person);
        }
      }
      return 1;
    } catch (e) {
      return 2;
    }
  }
}
