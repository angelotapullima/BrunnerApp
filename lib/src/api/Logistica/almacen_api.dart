import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/database/Logistica/Almacen/personal_dni_database.dart';
import 'package:new_brunner_app/src/database/Logistica/Almacen/recurso_logistica_database.dart';
import 'package:new_brunner_app/src/database/Logistica/Almacen/recursos_almacen_database.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/detalle_recurso_logistica_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/personal_dni_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/recurso_logistica_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/recursos_almacen_model.dart';

class AlmacenApi {
  final recursosDB = RecursosAlmacenDatabase();
  final personsDB = PersonalDNIDatabase();
  final recuLogisticaDB = RecursoLogisticaDatabase();

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
        await recursosDB.deleteRecurso(idSede);
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
        await personsDB.deletePersons();
        final decodedData = json.decode(resp.body);

        for (var i = 0; i < decodedData["result"]["personas"].length; i++) {
          var p = decodedData["result"]["personas"][i];
          final person = PersonalDNIModel();
          person.name = p["person_name"];
          person.surname = p["person_surname"];
          person.surname2 = p["person_surname2"];
          person.dni = p["person_dni"];

          await personsDB.insertarPerson(person);
        }
      }
      return 1;
    } catch (e) {
      return 2;
    }
  }

  Future<int> generarOrden({
    required String idSede,
    required String idAlmacenDestino,
    required String tipoRegistro,
    required String dniSolicitante,
    required String nombreSolicitante,
    String? comentarios,
    required String datos,
  }) async {
    try {
      String? token = await Preferences.readData('token');
      String? idUser = await Preferences.readData('id_user');

      final url = Uri.parse('$apiBaseURL/api/Almacen/generar_orden_app');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id_user': idUser,
          'id_sede': idSede,
          'id_almacen_destino': idAlmacenDestino,
          'tipo_registro': tipoRegistro,
          'almacen_log_dni_solicitante': dniSolicitante,
          'almacen_log_nombre_solicitante': nombreSolicitante,
          'almacen_log_comentarios': comentarios,
          'almacen_log_datos': datos,
        },
      );

      if (resp.statusCode == 200) {
        await personsDB.deletePersons();

        final decodedData = json.decode(resp.body);
        print(decodedData);
        return decodedData["result"]["code"];
      } else {
        return 2;
      }
    } catch (e) {
      print('ERROR $e');
      return 2;
    }
  }

  Future<int> getRecursosIngreso(String idSede, String val) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/Almacen/buscar_recursos_app');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id_sede': idSede,
          'recurso_buscar': val,
        },
      );

      if (resp.statusCode == 200) {
        await recuLogisticaDB.deleteRecurso(idSede);
        final decodedData = json.decode(resp.body);

        for (var i = 0; i < decodedData["result"]["recurso"].length; i++) {
          var datito = decodedData["result"]["recurso"][i];
          final recurso = RecursoLogisticaModel();
          recurso.idRecursoLogistica = datito["id_logistica_recurso"];
          recurso.idSede = idSede;
          recurso.nombreClaseLogistica = datito["logistica_clase_nombre"];
          recurso.nombreRecursoLogistica = datito["logistica_recurso_nombre"];
          recurso.cantidadAlmacen = datito["cantidad_almacen"];

          await recuLogisticaDB.insertarRecurso(recurso);
        }
        return decodedData["result"]["code"];
      } else {
        return 10;
      }
    } catch (e) {
      return 10;
    }
  }

  Future<List<DetalleRecursoLogisticaModel>> getDetalleRecurso(String idRecursoLogistica) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/Almacen/buscar_detalle_recursos_app');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id_logistica_recurso': idRecursoLogistica,
        },
      );

      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        if (decodedData["result"]["code"] == 1) {
          final List<DetallesRLModel> listD = [];

          for (var i = 0; i < decodedData["result"]["detalles"].length; i++) {
            var details = decodedData["result"]["detalles"][i];
            final detalle = DetallesRLModel();
            detalle.idTipoRecurso = details["id_recurso_tipo"];
            detalle.nombreTipoRecurso = details["recurso_tipo_nombre"];
            listD.add(detalle);
          }

          if (listD.isNotEmpty) {
            final List<DetalleRecursoLogisticaModel> listita = [
              DetalleRecursoLogisticaModel(
                unidad: decodedData["result"]["unidad"]["logistica_recurso_unidad"],
                listDetalles: listD,
              ),
            ];
            return listita;
          } else {
            return [];
          }
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
