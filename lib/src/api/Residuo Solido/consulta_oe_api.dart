import 'dart:convert';

import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Ejecucion%20Servicio/oes_database.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Ejecucion%20Servicio/pos_database.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Consulta%20Informacion%20OE/oes_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Consulta%20Informacion%20OE/pos_model.dart';

class ConsultaOEApi {
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
        await oesDB.deleteOES();
        await posDB.deletePOS();
        final decodedData = json.decode(resp.body);

        for (var i = 0; i < decodedData["oes"].length; i++) {
          var data = decodedData["oes"][i];
          final oes = OESModel();
          oes.idEjecucion = data["id_ejecucion"];
          oes.descripcionEjecucion = data["ejecucion_descripcion"];
          oes.fechaEjecucion = data["ejecucion_fecha"];
          oes.idUser = data["id_user"];
          oes.idPerson = data["id_person"];
          oes.nameCreated = data["person_name"];
          oes.surmaneCreated = '${data["person_surname"]} ${data["person_surname2"]}';
          oes.dniCreated = data["person_dni"];
          oes.idEmpresa = data["id_empresa"];
          oes.nombreEmpresa = data["empresa_nombre"];
          oes.rucEmpresa = data["empresa_ruc"];
          oes.idDepartamento = data["id_departamento"];
          oes.nombreDepartamento = data["departamento_nombre"];
          oes.idSede = data["id_sede"];
          oes.nombreSede = data["sede_nombre"];
          oes.clienteNombre = data["cliente_nombre"];
          oes.rucCliente = data["cliente_ruc"];

          await oesDB.insertarOES(oes);
        }

        for (var i = 0; i < decodedData["pos"].length; i++) {
          var data = decodedData["pos"][i];
          final pos = POSModel();
          pos.idPOS = data["id_pos"];
          pos.fechaServicio = data["pos_fecha_servicio"];
          pos.fechaFin = data["pos_fecha_fin"];
          pos.idEmpresa = data["id_empresa"];
          pos.nombreEmpresa = data["empresa_nombre"];
          pos.rucEmpresa = data["empresa_ruc"];
          pos.direccionEmpresa = data["empresa_direccion"];
          pos.departamentoEmpresa = data["empresa_departamento"];
          pos.provinciaEmpresa = data["empresa_provincia"];
          pos.distritoEmpresa = data["empresa_distrito"];
          pos.idDepartamento = data["id_departamento"];
          pos.nombreDepartamento = data["departamento_nombre"];
          pos.idSede = data["id_sede"];
          pos.nombreSede = data["sede_nombre"];
          pos.idVehiculo = data["id_vehiculo"];
          pos.placaVehiculo = data["vehiculo_placa"];
          pos.idUser = data["id_user"];
          pos.idPerson = data["id_person"];
          pos.nameCreated = data["person_name"];
          pos.surmaneCreated = '${data["person_surname"]} ${data["person_surname2"]}';
          pos.dniCreated = data["person_dni"];

          await posDB.insertarPOS(pos);
        }
      }

      return 2;
    } catch (e) {
      return 2;
    }
  }

  Future<int> accionesOE({required String modulo, required String accion, required String id, String? estado}) async {
    try {
      String? token = await Preferences.readData('token');
      String? idUser = await Preferences.readData('id_user');

      final url = Uri.parse('$apiBaseURL/api/Ejecucion/eliminar_aprobar_oes_pos_app');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id_user': idUser,
          'modulo': modulo,
          'accion': accion,
          'id': id,
          'estado': estado,
        },
      );

      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        print(decodedData);
        return decodedData["data"]["result"];
      } else {
        return 2;
      }
    } catch (e) {
      print(e);
      return 2;
    }
  }
}
