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
}
