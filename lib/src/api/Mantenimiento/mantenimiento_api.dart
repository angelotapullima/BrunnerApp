import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/vehiculo_database.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/vehiculo_model.dart';

class MantenimientoApi {
  final vehiculosDB = VehiculoDatabase();

  Future<bool> getVehiculos() async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/ListaVerificacion/listar_vehiculos_app');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'parametro': '',
        },
      );
      final decodedData = json.decode(resp.body);

      for (var i = 0; i < decodedData["result"].length; i++) {
        var data = decodedData["result"][i];

        final vehiculo = VehiculoModel();

        vehiculo.idVehiculo = data["id_vehiculo"];
        vehiculo.tipoUnidad = data["tipo_unidad"];
        vehiculo.carroceriaVehiculo = data["vehiculo_carroceria_nombre"];
        vehiculo.placaVehiculo = data["vehiculo_placa"];
        vehiculo.rucVehiculo = data["vehiculo_ruc"];
        vehiculo.razonSocialVehiculo = data["vehiculo_razonsocial"];
        vehiculo.partidaVehiculo = data["vehiculo_partida"];
        vehiculo.oficinaVehiculo = data["vehiculo_oficina"];
        vehiculo.marcaVehiculo = data["vehiculo_marca"];
        vehiculo.modeloVehiculo = data["vehiculo_modelo"];
        vehiculo.yearVehiculo = data["vehiculo_anho"];
        vehiculo.serieVehiculo = data["vehiculo_serie"];
        vehiculo.motorVehiculo = data["vehiculo_motor"];
        vehiculo.combustibleVehiculo = data["vehiculo_combustible"];
        vehiculo.potenciaMotorVehiculo = data["vehiculo_potencia_motor"];
        vehiculo.estadoInspeccionVehiculo = data["vehiculo_estado_inspeccion"];
        vehiculo.imagenVehiculo = data["vehiculo_foto_izquierdo"];
        vehiculo.estadoVehiculo = data["vehiculo_estado"];

        await vehiculosDB.insertarVehiculo(vehiculo);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
