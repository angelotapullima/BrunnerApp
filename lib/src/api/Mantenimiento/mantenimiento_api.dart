import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/categoria_inspeccion_vehiculo_database.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/check_item_inspeccion_database.dart';
import 'package:new_brunner_app/src/database/personas_database.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/item_inspeccion_database.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/vehiculo_database.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_vehiculo_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/check_item_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/personas_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/item_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/vehiculo_model.dart';
import 'package:new_brunner_app/src/model/api_result_model.dart';

class MantenimientoApi {
  final vehiculosDB = VehiculoDatabase();
  final choferesDB = PersonasDatabase();
  final catInspeccionDB = CategoriaInspeccionDatabase();
  final itemInspeccionDB = ItemInspeccionDatabase();
  final checkItemInspDB = CheckItemInspeccionDatabase();

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

      //Insertar Vehiculos
      for (var i = 0; i < decodedData["result"]["vehiculo"].length; i++) {
        var data = decodedData["result"]["vehiculo"][i];

        final vehiculo = VehiculoModel();

        vehiculo.idVehiculo = data["id_vehiculo"];
        vehiculo.tipoUnidad = data["tipo_unidad"];
        vehiculo.tipoInspeccion = data["tipo_inspeccion"];
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
        vehiculo.color1 = data["vehiculo_color1"];
        vehiculo.color2 = data["vehiculo_color2"];
        vehiculo.cargaUtil = data["vehiculo_carga_util"];

        await vehiculosDB.insertarVehiculo(vehiculo);

        //Insertar Categorias Inspeccion
        for (var m = 0; m < data["categoria"].length; m++) {
          var datios = data["categoria"][m];

          final categoria = CategoriaInspeccionModel();
          categoria.id = '${datios["id_vehiculo_inspeccion_categoria"]}-${data["id_vehiculo"]}';
          categoria.idCatInspeccion = datios["id_vehiculo_inspeccion_categoria"];
          categoria.idVehiculo = data["id_vehiculo"];
          categoria.tipoUnidad = datios["tipo_unidad"];
          categoria.tipoInspeccion = datios["tipo_inspeccion"];
          categoria.descripcionCatInspeccion = datios["vehiculo_inspeccion_categoria_descripcion"];
          categoria.estadoCatInspeccion = datios["vehiculo_inspeccion_categoria_estado"];

          await catInspeccionDB.insertarCategoriaInspeccion(categoria);

          // Insertar Items Inspeccion

          for (var x = 0; x < datios["vehiculo_inspeccion_items"].length; x++) {
            var dataItem = datios["vehiculo_inspeccion_items"][x];

            final item = ItemInspeccionModel();

            item.id = '${dataItem["id_vehiculo_inspeccion_item"]}-${data["id_vehiculo"]}';
            item.idItemInspeccion = dataItem["id_vehiculo_inspeccion_item"];
            item.idCatInspeccion = dataItem["id_vehiculo_inspeccion_categoria"];
            item.idVehiculo = data["id_vehiculo"];
            item.conteoItemInspeccion = dataItem["vehiculo_inspeccion_item_conteo"];
            item.descripcionItemInspeccion = dataItem["vehiculo_inspeccion_item_descripcion"];
            item.estadoMantenimientoItemInspeccion = dataItem["vehiculo_inspeccion_item_estadoMantto"];
            item.estadoItemInspeccion = dataItem["vehiculo_inspeccion_item_estado"];

            await itemInspeccionDB.insertarItemInspeccion(item);
          }
        }
      }

      //Insertar Choferes
      for (var i = 0; i < decodedData["result"]["choferes"].length; i++) {
        var data = decodedData["result"]["choferes"][i];

        final chofer = PersonasModel();
        chofer.idPerson = data["id_person"];
        chofer.dniPerson = data["person_dni"];
        chofer.nombrePerson = data["nombre"];

        await choferesDB.insertarPerson(chofer);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getCheckItemsVehiculo(String idVehiculo) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/ListaVerificacion/listar_inspeccion_vehiculo_app');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id_vehiculo': idVehiculo,
        },
      );
      final decodedData = json.decode(resp.body);

      final listItemsInspecion = await itemInspeccionDB.getItemInspeccionByIdVehiculo(idVehiculo);

      if (listItemsInspecion.isNotEmpty) {
        for (var i = 0; i < listItemsInspecion.length; i++) {
          final checkItem = CheckItemInspeccionModel();
          checkItem.idCheckItemInsp = '${listItemsInspecion[i].idItemInspeccion}$idVehiculo';
          checkItem.idCatInspeccion = listItemsInspecion[i].idCatInspeccion;
          checkItem.idItemInspeccion = listItemsInspecion[i].idItemInspeccion;
          checkItem.idVehiculo = idVehiculo;
          checkItem.conteoCheckItemInsp = listItemsInspecion[i].conteoItemInspeccion;
          checkItem.descripcionCheckItemInsp = listItemsInspecion[i].descripcionItemInspeccion;
          checkItem.estadoMantenimientoCheckItemInsp = listItemsInspecion[i].estadoMantenimientoItemInspeccion;
          checkItem.estadoCheckItemInsp = listItemsInspecion[i].estadoItemInspeccion;
          checkItem.valueCheckItemInsp = '';
          checkItem.ckeckItemHabilitado = '0';
          checkItem.observacionCkeckItemInsp = '';

          await checkItemInspDB.insertarCheckItemInspeccion(checkItem);
        }

        if (decodedData["result"]["respuesta"] == 1) {
          //Insertar checks previamente seleccionados
          for (var i = 0; i < decodedData["result"]["inspeccion_detalle"].length; i++) {
            var data = decodedData["result"]["inspeccion_detalle"][i];
            final checkItem = CheckItemInspeccionModel();
            checkItem.idCheckItemInsp = '${data["id_vehiculo_inspeccion_item"]}$idVehiculo';
            checkItem.idCatInspeccion = data["id_vehiculo_inspeccion_categoria"];
            checkItem.idItemInspeccion = data["id_vehiculo_inspeccion_item"];
            checkItem.idVehiculo = idVehiculo;
            checkItem.conteoCheckItemInsp = data["vehiculo_inspeccion_item_conteo"];
            checkItem.descripcionCheckItemInsp = data["vehiculo_inspeccion_item_descripcion"];
            checkItem.valueCheckItemInsp = data["inspeccion_vehiculo_detalle_estado"];
            checkItem.ckeckItemHabilitado = '0';
            checkItem.observacionCkeckItemInsp = data["inspeccion_vehiculo_detalle_observacion"];

            await checkItemInspDB.updateCheckInspeccion(checkItem);
          }

          //Insertar checks deshabilitados
          for (var x = 0; x < decodedData["result"]["checklist_deshabilitado"].length; x++) {
            var data = decodedData["result"]["checklist_deshabilitado"][x];
            await checkItemInspDB.updateHabilitarCheck('${data["id_vehiculo_inspeccion_item"]}$idVehiculo', data["checklist_deshabilitado_estado"]);
          }
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ApiResultModel> saveCheckList(VehiculoModel vehiculo, String idChofer, String hidrolina, String kilometraje) async {
    final res = ApiResultModel();
    try {
      String? token = await Preferences.readData('token');
      String? idUser = await Preferences.readData('id_user');
      String checkItems = '';
      String observaciones = '';

      final checksSeleccionados = await checkItemInspDB.getCHECKItemInspeccionSELECCIONADOSByIdVehiculo(vehiculo.idVehiculo.toString());

      for (var i = 0; i < checksSeleccionados.length; i++) {
        checkItems += '${checksSeleccionados[i].idItemInspeccion}-.-.${checksSeleccionados[i].valueCheckItemInsp}/-/-';

        if (checksSeleccionados[i].observacionCkeckItemInsp != '') {
          observaciones += '${checksSeleccionados[i].idItemInspeccion}-.-.${checksSeleccionados[i].observacionCkeckItemInsp}/./.';
        }
      }

      final url = Uri.parse('$apiBaseURL/api/Vehiculo/guardar_checklist');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id_user': idUser,
          'id_vehiculo': vehiculo.idVehiculo,
          'unidad': vehiculo.tipoUnidad,
          'id_chofer': idChofer,
          'hidrolina_inicial': hidrolina,
          'kilometro_inicial': kilometraje,
          'contenido': checkItems,
          'contenido_modal': observaciones,
        },
      );
      final decodedData = json.decode(resp.body);
      if (decodedData == 1) {
        await checkItemInspDB.deleteCheckItemInspeccionByIdVehiculo(vehiculo.idVehiculo.toString());
        res.code = 1;
        res.message = 'Ocurrió un error, inténtelo nuevamente';
      } else {
        res.code = 2;
        res.message = 'Ocurrió un error, inténtelo nuevamente';
      }

      return res;
    } catch (e) {
      res.code = 2;
      res.message = 'Ocurrió un error, inténtelo nuevamente';
      return res;
    }
  }
}
