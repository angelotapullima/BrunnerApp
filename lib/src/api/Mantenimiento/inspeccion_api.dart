import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/inspeccion_vehiculo_database.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/inspeccion_vehiculo_item_database.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/item_inspeccion_database.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_item_model.dart';
import 'package:new_brunner_app/src/model/api_result_model.dart';

class InspeccionApi {
  final inspeccionDB = InspeccionVehiculoDatabase();
  final itemInspeccionDB = ItemInspeccionDatabase();
  final checkItemInspDB = InspeccionVehiculoItemDatabase();

  Future<int> getInspeccionesVehiculos(String fechaInicial, String fechaFinal) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/ListaVerificacion/listar_reportes_generados_app');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'fecha_ini': fechaInicial,
          'fecha_fin': fechaFinal,
        },
      );
      final decodedData = json.decode(resp.body);

      for (var i = 0; i < decodedData["code"]["inspecciones"].length; i++) {
        var data = decodedData["code"]["inspecciones"][i];

        final inspeccion = InspeccionVehiculoModel();

        var fechix = data["inspeccion_vehiculo_fecha"].toString().split(' ');
        inspeccion.idInspeccionVehiculo = data["id_inspeccion_vehiculo"];
        inspeccion.fechaInspeccionVehiculo = fechix[0].trim();
        inspeccion.horaInspeccionVehiculo = fechix[1].trim();
        inspeccion.numeroInspeccionVehiculo = data["inspeccion_vehiculo_numero"];
        inspeccion.estadoCheckInspeccionVehiculo = data["inspeccion_vehiculo_estado_checkList"];
        inspeccion.placaVehiculo = data["vehiculo_placa"];
        inspeccion.marcaVehiculo = data["vehiculo_marca"];
        inspeccion.rucVehiculo = data["vehiculo_ruc"];
        inspeccion.razonSocialVehiculo = data["vehiculo_razonsocial"];
        inspeccion.imageVehiculo = data["vehiculo_foto_izquierdo"];
        inspeccion.idchofer = data["id_chofer"];
        inspeccion.documentoChofer = '';
        inspeccion.nombreChofer = data["nombre_chofer"];
        inspeccion.nombreUsuario = data["nombre_usuario"];
        inspeccion.tipoUnidad = data["tipo_unidad"];
        inspeccion.hidrolinaVehiculo = '';
        inspeccion.kilometrajeVehiculo = '';
        inspeccion.estadoFinal = data["inspeccion_vehiculo_estadoFinal"];
        inspeccion.observacionInspeccion = data["inspeccion_vehiculo_observacion"];
        inspeccion.estado = data["inspeccion_vehiculo_estado"];

        await inspeccionDB.insertarInspeccion(inspeccion);
      }
      return 1;
    } catch (e) {
      e;
      return 2;
    }
  }

  Future<int> getDetalleInspeccion(String idInspeccion) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/ListaVerificacion/ver_detalle_checklist_app');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id_inspeccion': idInspeccion,
        },
      );
      final decodedData = json.decode(resp.body);

      if (decodedData["code"]["inspecciones"][0]["id_inspeccion_vehiculo"] != null) {
        final inspeccion = InspeccionVehiculoModel();
        var data = decodedData["code"]["inspecciones"][0];
        var fechix = data["inspeccion_vehiculo_fecha"].split(' ');
        inspeccion.idInspeccionVehiculo = data["id_inspeccion_vehiculo"];
        inspeccion.fechaInspeccionVehiculo = fechix[0].trim();
        inspeccion.horaInspeccionVehiculo = fechix[1].trim();
        inspeccion.numeroInspeccionVehiculo = data["inspeccion_vehiculo_numero"];
        inspeccion.estadoCheckInspeccionVehiculo = data["inspeccion_vehiculo_estado_checkList"];
        inspeccion.placaVehiculo = data["vehiculo_placa"];
        inspeccion.marcaVehiculo = data["vehiculo_marca"];
        inspeccion.rucVehiculo = data["vehiculo_ruc"];
        inspeccion.razonSocialVehiculo = data["vehiculo_razonsocial"];
        inspeccion.imageVehiculo = data["vehiculo_foto_izquierdo"];
        inspeccion.idchofer = data["id_chofer"];
        inspeccion.documentoChofer = data["person_dni"];
        inspeccion.nombreChofer = data["nombre_chofer"];
        inspeccion.nombreUsuario = data["nombre_usuario"];
        inspeccion.tipoUnidad = data["tipo_unidad"];
        inspeccion.hidrolinaVehiculo = data["inspeccion_vehiculo_hidrolina_inicial"];
        inspeccion.kilometrajeVehiculo = data["inspeccion_vehiculo_kilometro_inicial"];
        inspeccion.estadoFinal = data["inspeccion_vehiculo_estadoFinal"];
        inspeccion.observacionInspeccion = data["inspeccion_vehiculo_observacion"];
        inspeccion.estado = data["inspeccion_vehiculo_estado"];

        await inspeccionDB.insertarInspeccion(inspeccion);
      }

      if (decodedData["code"]["inspeccion_detalle"].length > 0) {
        final listItemsInspecion = await itemInspeccionDB.getItemsInspeccion();
        if (listItemsInspecion.isNotEmpty) {
          for (var i = 0; i < listItemsInspecion.length; i++) {
            final checkItem = InspeccionVehiculoItemModel();
            checkItem.idCheckItemInsp = '${listItemsInspecion[i].idItemInspeccion}$idInspeccion';
            checkItem.idCatInspeccion = listItemsInspecion[i].idCatInspeccion;
            checkItem.idItemInspeccion = listItemsInspecion[i].idItemInspeccion;
            checkItem.idInspeccionVehiculo = idInspeccion;
            checkItem.conteoCheckItemInsp = listItemsInspecion[i].conteoItemInspeccion;
            checkItem.descripcionCheckItemInsp = listItemsInspecion[i].descripcionItemInspeccion;
            checkItem.estadoMantenimientoCheckItemInsp = listItemsInspecion[i].estadoMantenimientoItemInspeccion;
            checkItem.estadoCheckItemInsp = listItemsInspecion[i].estadoItemInspeccion;
            checkItem.valueCheckItemInsp = '';
            checkItem.ckeckItemHabilitado = '0';
            checkItem.observacionCkeckItemInsp = '';
            checkItem.responsableCheckItemInsp = '';
            checkItem.atencionCheckItemInsp = '';
            checkItem.conclusionCheckItemInsp = '';
            checkItem.nombreCategoria = '';

            await checkItemInspDB.insertarCheckItemInspeccion(checkItem);
          }
        }

        for (var x = 0; x < decodedData["code"]["inspeccion_detalle"].length; x++) {
          var data = decodedData["code"]["inspeccion_detalle"][x];
          final checkItem = InspeccionVehiculoItemModel();
          checkItem.idCheckItemInsp = '${data["id_vehiculo_inspeccion_item"]}$idInspeccion';
          checkItem.idCatInspeccion = data["id_vehiculo_inspeccion_categoria"];
          checkItem.idItemInspeccion = data["id_vehiculo_inspeccion_item"];
          checkItem.idInspeccionVehiculo = idInspeccion;
          checkItem.conteoCheckItemInsp = data["vehiculo_inspeccion_item_conteo"];
          checkItem.descripcionCheckItemInsp = data["vehiculo_inspeccion_item_descripcion"];
          checkItem.valueCheckItemInsp = data["inspeccion_vehiculo_detalle_estado"];
          checkItem.ckeckItemHabilitado = '0';
          checkItem.observacionCkeckItemInsp = _verificarNull(data["inspeccion_vehiculo_detalle_observacion"]);
          checkItem.responsableCheckItemInsp = data["responsable"];
          checkItem.atencionCheckItemInsp = data["atencion"];
          checkItem.conclusionCheckItemInsp = data["conclusion"];
          checkItem.nombreCategoria = data["vehiculo_inspeccion_categoria_descripcion"];

          //await checkItemInspDB.updateCheckInspeccion(checkItem);
          await checkItemInspDB.insertarCheckItemInspeccion(checkItem);
        }
      }

      return 1;
    } catch (e) {
      e;
      return 2;
    }
  }

  _verificarNull(var data) {
    if (data == null || data == 'null') {
      return '';
    } else {
      return data;
    }
  }

  Future<ApiResultModel> getPDF(String idInspeccion) async {
    final result = ApiResultModel();
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/ListaVerificacion/imprimir_pdf_checkList_app');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id': idInspeccion,
        },
      );
      final decodedData = json.decode(resp.body);

      result.code = decodedData["code"]["result"];
      result.message = decodedData["code"]["ruta"];

      return result;
    } catch (e) {
      result.code = 2;
      result.message = 'Ocurrió un error, inténtelo nuevamente';
      return result;
    }
  }

  Future<int> anularInspeccion(String idInspeccion, String observacion) async {
    try {
      String? token = await Preferences.readData('token');
      String? fechaInicial = await Preferences.readData('fechaInicial');
      String? fechaFinal = await Preferences.readData('fechaFinal');

      final url = Uri.parse('$apiBaseURL/api/ListaVerificacion/anular_inspeccion_vehiculo');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id': idInspeccion,
          'observacion': observacion,
        },
      );
      final decodedData = json.decode(resp.body);
      if (decodedData["result"] == 1) {
        await getInspeccionesVehiculos(fechaInicial.toString(), fechaFinal.toString());
        return 1;
      } else {
        return 3;
      }
    } catch (e) {
      return 2;
    }
  }
}
