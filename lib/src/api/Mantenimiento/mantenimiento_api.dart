import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/categorias_inspeccion_database.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/check_item_inspeccion_database.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/choferes_database.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/item_inspeccion_database.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/vehiculo_database.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/check_item_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/choferes_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/item_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/vehiculo_model.dart';

class MantenimientoApi {
  final vehiculosDB = VehiculoDatabase();
  final choferesDB = ChoferesDatabase();
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

      //Insertar Categorias Inspeccion
      for (var i = 0; i < decodedData["result"]["categoria"].length; i++) {
        var data = decodedData["result"]["categoria"][i];

        final categoria = CategoriaInspeccionModel();
        categoria.idCatInspeccion = data["id_vehiculo_inspeccion_categoria"];
        categoria.tipoUnidad = data["tipo_unidad"];
        categoria.descripcionCatInspeccion = data["vehiculo_inspeccion_categoria_descripcion"];
        categoria.estadoCatInspeccion = data["vehiculo_inspeccion_categoria_estado"];

        await catInspeccionDB.insertarCategoriaInspeccion(categoria);

        // Insertar Items Inspeccion

        for (var x = 0; x < data["vehiculo_inspeccion_items"].length; x++) {
          var dataItem = data["vehiculo_inspeccion_items"][x];

          final item = ItemInspeccionModel();

          item.idItemInspeccion = dataItem["id_vehiculo_inspeccion_item"];
          item.idCatInspeccion = dataItem["id_vehiculo_inspeccion_categoria"];
          item.conteoItemInspeccion = dataItem["vehiculo_inspeccion_item_conteo"];
          item.descripcionItemInspeccion = dataItem["vehiculo_inspeccion_item_descripcion"];
          item.estadoMantenimientoItemInspeccion = dataItem["vehiculo_inspeccion_item_estadoMantto"];
          item.estadoItemInspeccion = dataItem["vehiculo_inspeccion_item_estado"];

          await itemInspeccionDB.insertarItemInspeccion(item);
        }
      }

      //Insertar Choferes
      for (var i = 0; i < decodedData["result"]["choferes"].length; i++) {
        var data = decodedData["result"]["choferes"][i];

        final chofer = ChoferesModel();
        chofer.idChofer = data["id_person"];
        chofer.dniChofer = data["person_dni"];
        chofer.nombreChofer = data["nombre"];

        await choferesDB.insertarChofer(chofer);
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

      final listItemsInspecion = await itemInspeccionDB.getItemsInspeccion();

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
          checkItem.valueCheckItemInsp = '0';
          checkItem.ckeckItemHabilitado = '0';
          checkItem.observacionCkeckItemInsp = '';

          await checkItemInspDB.insertarCheckItemInspeccion(checkItem);
        }
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

      return true;
    } catch (e) {
      return false;
    }
  }
}
