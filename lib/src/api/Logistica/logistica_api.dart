import 'dart:convert';

import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/database/Logistica/detalle_op_database.dart';
import 'package:new_brunner_app/src/database/Empresa/empresas_database.dart';
import 'package:new_brunner_app/src/database/Logistica/orden_pedido_database.dart';
import 'package:new_brunner_app/src/database/Logistica/proveedores_database.dart';
import 'package:new_brunner_app/src/model/Logistica/detalle_op_model.dart';
import 'package:new_brunner_app/src/model/Empresa/empresas_model.dart';
import 'package:new_brunner_app/src/model/Logistica/orden_pedido_model.dart';
import 'package:new_brunner_app/src/model/Logistica/proveedores_model.dart';

class LogisticaApi {
  final empresaDB = EmpresasDatabase();
  final proveedoresDB = ProveedoresDatabase();
  final opDB = OrdenPedidoDatabase();
  final detalleOPDB = DetalleOPDatabase();

  Future<int> getEmpresasProveedores() async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/OrdenPedido/listar_empresas_proveedores');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
        },
      );

      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);

        //Insertar Empresas
        for (var i = 0; i < decodedData["empresas"].length; i++) {
          final data = decodedData["empresas"][i];

          final empresa = EmpresasModel();
          empresa.idEmpresa = data["id_empresa"];
          empresa.nombreEmpresa = data["empresa_nombre"];
          empresa.rucEmpresa = data["empresa_ruc"];
          empresa.direccionEmpresa = data["empresa_direccion"];
          empresa.departamentoEmpresa = data["empresa_departamento"];
          empresa.provinciaEmpresa = data["empresa_provincia"];
          empresa.distritoEmpresa = data["empresa_distrito"];
          empresa.estadoEmpresa = data["empresa_estado"];

          await empresaDB.insertarEmpresa(empresa);
        }

        //Insertar Proveedores
        for (var i = 0; i < decodedData["proveedores"].length; i++) {
          final data = decodedData["proveedores"][i];

          final proveedor = ProveedoresModel();
          proveedor.idProveedor = data["id_proveedor"];
          proveedor.nombreProveedor = data["proveedor_nombre"];
          proveedor.rucProveedor = data["proveedor_ruc"];
          proveedor.direccionProveedor = data["proveedor_direccion"];
          proveedor.telefonoProveedor = data["proveedor_telefono"];
          proveedor.contactoProveedor = data["proveedor_contacto"];
          proveedor.emailProveedor = data["proveedor_email"];
          proveedor.clase1Proveedor = data["proveedor_clase1"];
          proveedor.clase2Proveedor = data["proveedor_clase2"];
          proveedor.clase3Proveedor = data["proveedor_clase3"];
          proveedor.clase4Proveedor = data["proveedor_clase4"];
          proveedor.clase5Proveedor = data["proveedor_clase5"];
          proveedor.clase6Proveedor = data["proveedor_clase6"];
          proveedor.banco1Proveedor = data["proveedor_banco1"];
          proveedor.banco2Proveedor = data["proveedor_banco2"];
          proveedor.banco3Proveedor = data["proveedor_banco3"];
          proveedor.estadoProveedor = data["proveedor_estado"];

          await proveedoresDB.insertarProveedor(proveedor);
        }
      }

      return 1;
    } catch (e) {
      return 2;
    }
  }

  Future<int> getOrdenesPedido(String fechaIni, String fechaFin, String op) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/OrdenPedido/listar_ops_ws');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'fecha_inicio': fechaIni,
          'fecha_fin': fechaFin,
          'op_numero': op,
        },
      );

      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);

        //Insertar Ordenes Pedido
        for (var i = 0; i < decodedData["ops"].length; i++) {
          final data = decodedData["ops"][i];

          final orden = OrdenPedidoModel();
          orden.idOP = data["id_op"];
          orden.numeroOP = data["op_numero"];
          orden.nombreEmpresa = data["empresa_nombre"];
          orden.nombreSede = data["sede_nombre"];
          orden.idProveedor = data["id_proveedor"];
          orden.nombreProveedor = data["proveedor_nombre"];
          orden.monedaOP = data["op_moneda"];
          orden.totalOP = data["op_total"];
          orden.fechaCreacion = data["fecha_creacion"];
          orden.fechaOP = data["fecha_op"];
          orden.nombrePerson = data["person_name"];
          orden.surnamePerson = data["person_surname"];
          orden.surname2Person = data["person_surname2"];
          orden.nombreApro = data["persona_nombre_aprob"];
          orden.surnameApro = data["persona_apellido1_aprob"];
          orden.surname2Apro = data["persona_apellido2_aprob"];
          orden.estado = data["estado"];
          orden.rendido = data["rendido"];
          orden.departamento = data["departamento_nombre"];
          orden.condicionesOP = data["op_condiciones"];
          orden.rucProveedor = data["proveedor_ruc"];
          orden.opVencimiento = data["op_vencimiento"];

          await opDB.insertarOrden(orden);
        }
      }

      return 1;
    } catch (e) {
      return 2;
    }
  }

  Future<int> listarOPPendientes() async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/OrdenPedido/listar_ops_pendientes_ws');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
        },
      );
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);

        for (var i = 0; i < decodedData["ops"].length; i++) {
          final data = decodedData["ops"][i];

          final orden = OrdenPedidoModel();
          orden.idOP = data["id_op"];
          orden.numeroOP = data["op_numero"];
          orden.nombreEmpresa = data["empresa_nombre"];
          orden.nombreSede = data["sede_nombre"];
          orden.idProveedor = data["id_proveedor"];
          orden.nombreProveedor = data["proveedor_nombre"];
          orden.monedaOP = data["op_moneda"];
          orden.totalOP = data["op_total"];
          orden.fechaCreacion = data["fecha_creacion"];
          orden.fechaOP = data["fecha_op"];
          orden.nombrePerson = data["person_name"];
          orden.surnamePerson = data["person_surname"];
          orden.surname2Person = data["person_surname2"];
          orden.nombreApro = data["persona_nombre_aprob"];
          orden.surnameApro = data["persona_apellido1_aprob"];
          orden.surname2Apro = data["persona_apellido2_aprob"];
          orden.estado = data["op_estado"];
          orden.departamento = data["departamento_nombre"];
          orden.condicionesOP = data["op_condiciones"];
          orden.rendido = '0';
          orden.rucProveedor = data["proveedor_ruc"];
          orden.opVencimiento = data["op_vencimiento"];

          await opDB.insertarOrden(orden);
        }
      }

      return 1;
    } catch (e) {
      return 2;
    }
  }

  Future<int> getDetalleOP(String idOP, String rendido) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/OrdenPedido/listar_op_detalles_ws');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id_op': idOP,
        },
      );

      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);

        for (var i = 0; i < decodedData["ops"].length; i++) {
          final data = decodedData["ops"][i];

          final orden = OrdenPedidoModel();
          orden.idOP = data["id_op"];
          orden.numeroOP = data["op_numero"];
          orden.nombreEmpresa = data["empresa_nombre"];
          orden.nombreSede = data["sede_nombre"];
          orden.idProveedor = data["id_proveedor"];
          orden.nombreProveedor = data["proveedor_nombre"];
          orden.monedaOP = data["op_moneda"];
          orden.totalOP = data["op_total"];
          orden.fechaCreacion = data["fecha_creacion"];
          orden.fechaOP = data["fecha_op"];
          orden.nombrePerson = data["person_name"];
          orden.surnamePerson = data["person_surname"];
          orden.surname2Person = data["person_surname2"];
          orden.nombreApro = data["persona_nombre_aprob"];
          orden.surnameApro = data["persona_apellido1_aprob"];
          orden.surname2Apro = data["persona_apellido2_aprob"];
          orden.estado = data["op_estado"];
          orden.departamento = data["departamento_nombre"];
          orden.condicionesOP = data["op_condiciones"];
          orden.rendido = rendido;
          orden.rucProveedor = data["proveedor_ruc"];
          orden.opVencimiento = data["op_vencimiento"];

          await opDB.insertarOrden(orden);

          //Insertar Detalle
          for (var x = 0; x < data["detalle"].length; x++) {
            final dato = data["detalle"][x];
            final detalle = DetalleOPModel();

            detalle.idDetalleOP = dato["id_detalleop"];
            detalle.idOP = dato["id_op"];
            detalle.idDetalleSI = dato["id_detallesi"];
            detalle.precioUnitario = dato["detalleop_prec_unit"];
            detalle.precioTotal = dato["detalleop_prec_tot"];
            detalle.idSI = dato["id_si"];
            detalle.idRecurso = dato["id_recurso"];
            detalle.idTipoRecurso = dato["id_recurso_tipo"];
            detalle.descripcionSI = dato["detallesi_descripcion"];
            detalle.umSI = dato["detallesi_um"];
            detalle.cantidadSI = dato["detallesi_cantidad"];
            detalle.estadoSI = dato["detallesi_estado"];
            detalle.atentidoSI = dato["detallesi_atendido"];
            detalle.cajaAlmacenSI = dato["detallesi_caja_almacen"];
            detalle.tipoNombreRecurso = dato["recurso_tipo_nombre"];
            detalle.logisticaNombreRecurso = dato["logistica_recurso_nombre"];
            detalle.nroSI = dato["si_numero"];

            await detalleOPDB.insertarDetalleOP(detalle);
          }
        }
      }

      return 1;
    } catch (e) {
      return 2;
    }
  }

  Future<int> aprobarOP(String idOP) async {
    try {
      String? token = await Preferences.readData('token');
      String? idUser = await Preferences.readData('id_user');

      final url = Uri.parse('$apiBaseURL/api/OrdenPedido/aprobacion_op');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id_op': idOP,
          'id_user': idUser,
        },
      );

      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        return decodedData["result"];
      } else {
        return 3;
      }
    } catch (e) {
      return 2;
    }
  }

  Future<int> elimarOP(String idOP, String eliminar) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/OrdenPedido/eliminacion_op');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id_op': idOP,
          'eliminar': eliminar,
        },
      );

      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        if (decodedData["result"] == 1) {
          await opDB.deleteOP(idOP);
          await detalleOPDB.deleteDetalle(idOP);
        }
        return decodedData["result"];
      } else {
        return 3;
      }
    } catch (e) {
      return 2;
    }
  }
}
