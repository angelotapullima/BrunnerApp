import 'dart:convert';

import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/database/Logistica/empresas_database.dart';
import 'package:new_brunner_app/src/database/Logistica/orden_pedido_database.dart';
import 'package:new_brunner_app/src/database/Logistica/proveedores_database.dart';
import 'package:new_brunner_app/src/model/Logistica/empresas_model.dart';
import 'package:new_brunner_app/src/model/Logistica/orden_pedido_model.dart';
import 'package:new_brunner_app/src/model/Logistica/proveedores_model.dart';

class LogisticaApi {
  final empresaDB = EmpresasDatabase();
  final proveedoresDB = ProveedoresDatabase();
  final opDB = OrdenPedidoDatabase();
  Future<int> getOrdenesPedido(String fechaIni, String fechaFin, String op, bool filtro) async {
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

        if (filtro) {
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

        //Insertar Ordenes Pedido
        for (var i = 0; i < decodedData["ops"].length; i++) {
          final data = decodedData["ops"][i];

          final orden = OrdenPedidoModel();
          orden.idOP = data["id_op"];
          orden.numeroOP = data["op_numero"];
          orden.nombreEmpresa = data["empresa_nombre"];
          orden.nombreSede = data["sede_nombre"];
          orden.nombreProveedor = data["proveedor_nombre"];
          orden.monedaOP = data["op_moneda"];
          orden.totalOP = data["op_total"];
          orden.fechaOP = data["fecha_op"];
          orden.nombrePerson = data["person_name"];
          orden.surnamePerson = data["person_surname"];
          orden.surname2Person = data["person_surname2"];
          orden.estado = data["estado"];
          orden.rendido = data["rendido"];

          await opDB.insertarOrden(orden);
        }
      }

      return 1;
    } catch (e) {
      return 2;
    }
  }
}
