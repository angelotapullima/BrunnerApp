import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Ejecucion%20Servicio/clientes_oe_database.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Ejecucion%20Servicio/orden_ejecucion_database.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Ejecucion%20Servicio/personal_oe_database.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Ejecucion%20Servicio/unidades_oe_database.dart';
import 'package:new_brunner_app/src/model/Empresa/clientes_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/clientes_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/orden_ejecucion_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/personal_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/unidades_oe_model.dart';

class POSApi {
  final clientesDB = ClientesOEDatabase();
  final oeDB = OrdenEjecucionDatabase();
  final personalOEDB = PersonalOEDatabase();
  final unidadesOEDB = UnidadesOEDatabase();

  Future<List<ClientesOEModel>?> getDataPOS(String idEmpresa, String idDepartamento, String idSede) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/Ejecucion/buscar_datos_pos');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id_empresa': idEmpresa,
          'id_departamento': idDepartamento,
          'id_sede': idSede,
        },
      );

      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);

        final List<ClientesOEModel> lista = [];

        //Insertar Clientes
        for (var i = 0; i < decodedData["datos_clientes"].length; i++) {
          var data = decodedData["datos_clientes"][i];
          final cliente = ClientesOEModel();
          cliente.idCliente = data["id_cliente"];
          cliente.nombreCliente = data["cliente_nombre"];
          cliente.logoCliente = data["cliente_logo"];
          lista.add(cliente);
          await clientesDB.insertarClienteOE(cliente);

          //Insertar Ordenes de Ejecucion
          for (var x = 0; x < data["oes"]; x++) {
            var oes = data["oes"][x];
            final oe = OrdenEjecucionModel();

            oe.idOE = oes["id_ejecucion"];
            oe.idCliente = data["id_cliente"];
            oe.idEmpresa = oes["id_empresa"];
            oe.idDepartamento = oes["id_departamento"];
            oe.idSede = oes["id_sede"];
            oe.numeroOE = oes["ejecucion_numero"];
            oe.descripcionOE = oes["ejecucion_descripcion"];
            oe.fechaOE = oes["ejecucion_fecha"];
            oe.cipRTOE = oes["ejecucion_cip_rt"];
            oe.rtOE = oes["ejecucion_rt"];
            oe.contactoOE = oes["periodoc_contacto"];
            oe.telefonoContactoOE = oes["periodoc_telefono"];
            oe.emailContactoOE = oes["periodoc_email"];
            oe.idUserCreacionOE = oes["id_user_creacion"];
            oe.fechaCreacionOE = oes["datetime_creacion"];
            oe.estadoOE = oes["ejecucion_estado"];
            oe.mtOE = oes["ejecucion_mt"];
            oe.idUserAprobacion = oes["id_user_aprobacion"];
            oe.fechaAprobacionOE = oes["datetime_aprobacion"];
            oe.enviadoFacturacion = oes["enviado_facturacion"];
            oe.idLugarOE = oes["id_lugar_ejecucion"];
            oe.condicionOE = oes["ejecucion_condicion"];

            await oeDB.insertarOE(oe);
          }
        }

        //Insertar Unidades
        for (var i = 0; i < decodedData["dato_unidad"].length; i++) {
          var data = decodedData["dato_unidad"][i];
          final unidad = UnidadesOEModel();

          unidad.idVehiculo = data["id_vehiculo"];
          unidad.id = '${idEmpresa}${idDepartamento}${idSede}';
          unidad.placaVehiculo = data["vehiculo_placa"];

          await unidadesOEDB.insertarUnidadOE(unidad);
        }

        //Insertar Personal
        for (var i = 0; i < decodedData["array_operador"].length; i++) {
          var data = decodedData["array_operador"][i];
          final persona = PersonalOEModel();

          persona.idPersona = data["id_vehiculo"];
          persona.id = '${idEmpresa}${idDepartamento}${idSede}';
          persona.nombre = data["nombre"];
          persona.dni = data["datos_person"][0]["person_dni"];
          persona.fechaPeriodo = data["datos_person"][0]["periodo_fechafin"];
          persona.image = data["datos_person"][0]["person_photo"];
          persona.idCargo = data["datos_person"][0]["id_cargo"];
          persona.cargo = data["datos_person"][0]["cargo_nombre"];
          persona.detalleCargo = data["datos_person"][0]["detalle_cargo_nombre"];
          persona.valueAsistencia = data["datos_person"][0]["asistencia_proyectada"];
          persona.asistenciaProyectada = data["datos_person"][0]["person_dni"];

          await personalOEDB.insertarPersonalOE(persona);
        }

        return lista;
      } else {
        return [];
      }
    } catch (e) {
      return null;
    }
  }
}
