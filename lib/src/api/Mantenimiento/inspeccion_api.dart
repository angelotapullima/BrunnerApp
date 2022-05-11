import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/inspeccion_vehiculo_database.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_model.dart';

class InspeccionApi {
  final inspeccionDB = InspeccionVehiculoDatabase();

  Future<int> getInspeccionesVehiculos(String fechaIncial, String fechaFinal) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/ListaVerificacion/listar_reportes_generados_app');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'parametro': '',
        },
      );
      final decodedData = json.decode(resp.body);

      for (var i = 0; i < decodedData["code"]["inspecciones"].length; i++) {
        var data = decodedData["code"]["inspecciones"][i];

        final inspeccion = InspeccionVehiculoModel();
        inspeccion.idInspeccionVehiculo = data["id_inspeccion_vehiculo"];
        inspeccion.fechaInspeccionVehiculo = data["inspeccion_vehiculo_fecha"];
        inspeccion.numeroInspeccionVehiculo = data["inspeccion_vehiculo_numero"];
        inspeccion.estadoCheckInspeccionVehiculo = data["inspeccion_vehiculo_estado_checkList"];
        inspeccion.placaVehiculo = data["vehiculo_placa"];
        inspeccion.rucVehiculo = data["vehiculo_ruc"];
        inspeccion.razonSocialVehiculo = data["vehiculo_razonsocial"];
        inspeccion.imageVehiculo = data["vehiculo_foto_izquierdo"];
        inspeccion.idchofer = data["id_chofer"];
        inspeccion.nombreChofer = data["nombre_chofer"];
        inspeccion.nombreUsuario = data["nombre_usuario"];
        inspeccion.tipoUnidad = data["tipo_unidad"];

        await inspeccionDB.insertarInspeccion(inspeccion);
      }
      return 1;
    } catch (e) {
      e;
      return 2;
    }
  }
}
