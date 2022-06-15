import 'dart:convert';

import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/database/Mantenimiento/categorias_inspeccion_database.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/inspeccion_vehiculo_detalle_database.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/item_inspeccion_database.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/mantenimiento_correctivo_database.dart';
import 'package:new_brunner_app/src/database/personas_database.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/item_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/mantenimiento_correctivo_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/personas_model.dart';
import 'package:new_brunner_app/src/model/api_result_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Orden%20Habilitacion/new_observaciones_model.dart';

class MantenimientoCorrectivoApi {
  final catInspeccionDB = CategoriaInspeccionDatabase();
  final itemInspeccionDB = ItemInspeccionDatabase();
  final personaDB = PersonasDatabase();
  final detalleInspDB = InspeccionVehiculoDetalleDatabase();
  final mantCorrectivoDB = MantenimientoCorrectivoDatabase();

  Future<int> getData(String tipoUnidad) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/ListaVerificacion/mantenimiento_correctivo_app');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'unidad': tipoUnidad,
        },
      );
      final decodedData = json.decode(resp.body);

      //Insertar Categorias Inspeccion
      for (var i = 0; i < decodedData["code"]["categoria"].length; i++) {
        var data = decodedData["code"]["categoria"][i];

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

      //Insertar Detalle Inspecciones y Mantenimiento Correctivo

      if (decodedData["code"]["inspeccion_detalle"].length > 0) {
        await detalleInspDB.deleteDetalleInspeccion();
        await mantCorrectivoDB.deleteMantenimiento();
      }

      for (var i = 0; i < decodedData["code"]["inspeccion_detalle"].length; i++) {
        var data = decodedData["code"]["inspeccion_detalle"][i];

        final detalle = InspeccionVehiculoDetalleModel();
        detalle.idInspeccionDetalle = data["id_inspeccion_vehiculo_detalle"];
        detalle.tipoUnidad = data["tipo_unidad"];
        detalle.idVehiculo = data["id_vehiculo"];
        detalle.plavaVehiculo = data["vehiculo_placa"];
        detalle.nroCheckList = data["numero_checklist"];
        var fechix = data["inspeccion_vehiculo_fecha"].split(' ');
        detalle.fechaInspeccion = fechix[0].trim();
        detalle.horaInspeccion = fechix[1].trim();
        detalle.idCategoria = data["id_vehiculo_inspeccion_categoria"];
        detalle.descripcionCategoria = data["vehiculo_inspeccion_categoria_descripcion"];
        detalle.idItemInspeccion = data["id_vehiculo_inspeccion_item"];
        detalle.descripcionItem = data["vehiculo_inspeccion_item_descripcion"];
        detalle.idInspeccionVehiculo = data["id_inspeccion_vehiculo"];
        detalle.estadoInspeccionDetalle = data["inspeccion_vehiculo_detalle_estado"];
        detalle.observacionInspeccionDetalle = data["inspeccion_vehiculo_detalle_observacion"];
        detalle.estadoFinalInspeccionDetalle = data["inspeccion_vehiculo_detalle_estadofinal"];
        detalle.observacionFinalInspeccionDetalle = data["inspeccion_vehiculo_detalle_observacionFinal"];
        await detalleInspDB.insertarDetalleInspeccion(detalle);

        for (var x = 0; x < data["mantenimiento_correctivo"].length; x++) {
          var dato = data["mantenimiento_correctivo"][x];

          final mantenimiento = MantenimientoCorrectivoModel();
          mantenimiento.idMantenimiento = dato["id_mantto"];
          mantenimiento.idInspeccionDetalle = data["id_inspeccion_vehiculo_detalle"];
          mantenimiento.responsable = dato["responsable"];
          mantenimiento.idResponsable = dato["id_responsable"];
          mantenimiento.estado = dato["mantenimiento_correctivo_estado"];
          mantenimiento.diagnostico = dato["mantenimiento_correctivo_diagnostico"];
          mantenimiento.fechaDiagnostico = dato["mantenimiento_correctivo_diagnostico_fecha"];
          mantenimiento.conclusion = dato["mantenimiento_correctivo_conclusion"];
          mantenimiento.recomendacion = dato["mantenimiento_correctivo_recomendacion"];
          mantenimiento.dateTimeMantenimiento = dato["mantenimiento_correctivo_datetime"];
          mantenimiento.estadoFinal = dato["mantenimiento_correctivo_estado_final"];
          mantenimiento.fechaFinalMantenimiento = dato["mantenimiento_correctivo_fechafinal"];

          await mantCorrectivoDB.insertarMantenimiento(mantenimiento);
        }
      }

      //Insertar personas

      for (var i = 0; i < decodedData["code"]["personas"].length; i++) {
        var data = decodedData["code"]["personas"][i];

        final persona = PersonasModel();
        persona.idPerson = data["id_person"];
        persona.dniPerson = data["person_dni"];
        persona.nombrePerson = '${data["person_name"]} ${data["person_surname"]} ${data["person_surname2"]}';
        persona.idCargo = data["id_departamento"];

        await personaDB.insertarPerson(persona);
      }

      return 1;
    } catch (e) {
      return 2;
    }
  }

  Future<int> asignarResponsableAInspeccionDetalle(String idDetalle, String idPerson) async {
    try {
      String? token = await Preferences.readData('token');
      String? idUser = await Preferences.readData('id_user');

      final url = Uri.parse('$apiBaseURL/api/MantenimientoCorrectivo/actualizar_responsable');

      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id': idDetalle,
          'valor': idPerson,
          'id_user': idUser,
        },
      );
      final decodedData = json.decode(resp.body);

      return decodedData;
    } catch (e) {
      return 2;
    }
  }

  Future<int> anularInspeccionDetalle(String idDetalle, String observacion) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/MantenimientoCorrectivo/anular_inspeccion');

      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id': idDetalle,
          'observacion': observacion,
        },
      );
      final decodedData = json.decode(resp.body);

      return decodedData;
    } catch (e) {
      return 2;
    }
  }

  Future<int> actualizarAcciones(String id, String valor, String accion) async {
    try {
      String api = '';
      switch (accion) {
        case '1':
          api = 'actualizar_diagnostico';
          break;
        case '2':
          api = 'actualizar_conclusion';
          break;
        case '3':
          api = 'actualizar_recomendacion';

          break;
        default:
      }

      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/MantenimientoCorrectivo/$api');

      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id': id,
          'valor': valor,
        },
      );
      final decodedData = json.decode(resp.body);

      return decodedData["result"]["code"];
    } catch (e) {
      return 1;
    }
  }

  //Orden Habilitación Correctiva
  Future<int> habilitarObservaciones(
      String idVehiculo, List<InspeccionVehiculoDetalleModel> informes, List<NuevasObservacionesModel> observaciones) async {
    try {
      String? token = await Preferences.readData('token');
      String? idUser = await Preferences.readData('id_user');

      String informe = '';
      for (var i = 0; i < informes.length; i++) {
        informe +=
            '${informes[i].mantCorrectivos![0].idMantenimiento}-.-.${informes[i].fechaInspeccion} ${informes[i].horaInspeccion}-.-.${informes[i].nroCheckList}-.-.${informes[i].descripcionCategoria}-.-.${informes[i].descripcionItem}-.-.${informes[i].mantCorrectivos![0].responsable}-.-.${informes[i].idInspeccionDetalle}-.-.${informes[i].mantCorrectivos![0].estado}/./.';
      }
      String observacion = '';

      for (var i = 0; i < observaciones.length; i++) {
        observacion +=
            '${observaciones[i].idCategoria}-.-.${observaciones[i].idItem}-.-.${observaciones[i].descripcionCat}-.-.${observaciones[i].descripcionItem}-.-.${observaciones[i].observacion}/./.';
      }

      final url = Uri.parse('$apiBaseURL/api/MantenimientoCorrectivo/habilitar_observaciones');

      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id_vehiculo': idVehiculo,
          'id_user': idUser,
          'contenido': informe,
          'contenido_hc': observacion,
        },
      );
      final decodedData = json.decode(resp.body);

      return decodedData;
    } catch (e) {
      return 2;
    }
  }

  Future<ApiResultModel> getPDF(String idInspeccionDetalle) async {
    final result = ApiResultModel();
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/ListaVerificacion/pdf_observacion_mantenimiento_c_app');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id': idInspeccionDetalle,
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
}
