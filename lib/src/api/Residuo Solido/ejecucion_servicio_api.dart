import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/database/Empresa/departamento_database.dart';
import 'package:new_brunner_app/src/database/Empresa/empresas_database.dart';
import 'package:new_brunner_app/src/database/Empresa/sede_database.dart';
import 'package:new_brunner_app/src/database/Empresa/tipo_doc_database.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Orden%20Ejecucion/actividades_oe_database.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Orden%20Ejecucion/clientes_oe_database.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Orden%20Ejecucion/codigos_oe_database.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Orden%20Ejecucion/contactos_oe_database.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Orden%20Ejecucion/lugares_oe_database.dart';
import 'package:new_brunner_app/src/model/Empresa/clientes_model.dart';
import 'package:new_brunner_app/src/model/Empresa/departamento_model.dart';
import 'package:new_brunner_app/src/model/Empresa/empresas_model.dart';
import 'package:new_brunner_app/src/model/Empresa/sede_model.dart';
import 'package:new_brunner_app/src/model/Empresa/tipo_doc_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Orden%20Ejecucion/actividades_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Orden%20Ejecucion/clientes_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Orden%20Ejecucion/codigos_ue_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Orden%20Ejecucion/contactos_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Orden%20Ejecucion/lugares_oe_model.dart';

class EjecucionServicioApi {
  final empresaDB = EmpresasDatabase();
  final departamentoDB = DepartamentoDatabase();
  final sedeDB = SedeDatabase();

  final clientesDB = ClientesOEDatabase();
  final contactosDB = ContactosOEDatabase();
  final codigosDB = CodigosOEDatabase();
  final lugaresDB = LugaresOEDatabase();
  final actividadesDB = ActividadesOEDatabase();
  final tipoDocDB = TipoDocDatabase();

  Future<int> getFiltrosApi() async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/Ejecucion/listar_empr_depa_sede_app');
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
        for (var i = 0; i < decodedData["data"]["empresa"].length; i++) {
          final data = decodedData["data"]["empresa"][i];

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

        //Insertar Departamentos
        for (var i = 0; i < decodedData["data"]["departamento"].length; i++) {
          final data = decodedData["data"]["departamento"][i];

          final departamento = DepartamentoModel();
          departamento.idDepartamento = data["id_departamento"];
          departamento.nombreDepartamento = data["departamento_nombre"];
          departamento.estadoDepartamento = data["departamento_estado"];

          await departamentoDB.insertarDepartamento(departamento);
        }

        //Insertar Sedes
        for (var i = 0; i < decodedData["data"]["sede"].length; i++) {
          final data = decodedData["data"]["sede"][i];

          final sede = SedeModel();
          sede.idSede = data["id_sede"];
          sede.nombreSede = data["sede_nombre"];
          sede.estadoSede = data["sede_estado"];

          await sedeDB.insertarSede(sede);
        }
      }
      return 1;
    } catch (e) {
      return 2;
    }
  }

  Future<List<ClientesModel>?> getActividadesORDEJEC(String idEmpresa, String idDepartamento, String idSede) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/Ejecucion/buscar_actividades_clientes');
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

        final List<ClientesModel> lista = [];

        for (var i = 0; i < decodedData["result"].length; i++) {
          var data = decodedData["result"][i];
          final cliente = ClientesModel();
          cliente.idCliente = data["id_cliente"];
          cliente.nombreCliente = data["cliente_nombre"];
          lista.add(cliente);
        }

        return lista;
      } else {
        return [];
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<ClientesOEModel>?> getClientesORDEJEC(String idEmpresa, String idDepartamento, String idSede) async {
    try {
      String? token = await Preferences.readData('token');

      final url = Uri.parse('$apiBaseURL/api/Ejecucion/buscar_actividades_clientes_app');
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

        for (var i = 0; i < decodedData["datos_clientes"].length; i++) {
          var data = decodedData["datos_clientes"][i];
          final cliente = ClientesOEModel();
          cliente.idCliente = data["id_cliente"];
          cliente.id = '$idEmpresa$idDepartamento$idSede';
          cliente.nombreCliente = data["cliente_nombre"];
          lista.add(cliente);
          await clientesDB.insertarClienteOE(cliente);

          //Insertar Contactos
          for (var x = 0; x < data["contactos"].length; x++) {
            var dato = data["contactos"][x];
            final contacto = ContactosOEModel();
            contacto.idContacto = dato["id_cliente_contacto"];
            contacto.idCliente = dato["id_cliente"];
            contacto.contactoCliente = dato["cliente_contacto"];
            contacto.cargoCliente = dato["cliente_cargo"];
            contacto.emailCliente = dato["cliente_email"];
            contacto.telefonoCliente = dato["cliente_telefono"];
            contacto.cipCliente = dato["cliente_cip"];

            await contactosDB.insertarContactoOE(contacto);
          }

          //Insertar Codigos
          for (var x = 0; x < data["codigos"].length; x++) {
            var dato = data["codigos"][x];
            final codigo = CodigosOEModel();
            codigo.idCod = dato["id_periodoc"];
            codigo.idCliente = data["id_cliente"];
            codigo.periodoCod = dato["periodoc_codigo"];

            await codigosDB.insertarCodigoOE(codigo);
          }

          //Insertar Lugares
          for (var x = 0; x < data["lugares"].length; x++) {
            var dato = data["lugares"][x];
            final lugar = LugaresOEModel();
            lugar.idLugarEjecucion = dato["id_clientelugar_ejecucion"];
            lugar.idCliente = data["id_cliente"];
            lugar.establecimientoLugar = dato["cliente_lugar_establecimiento"];
            lugar.idLugar = dato["id_cliente_lugar"];

            await lugaresDB.insertarLugarOE(lugar);
          }

          //Insertar Actividades
          for (var x = 0; x < data["actividades"].length; x++) {
            var dato = data["actividades"][x];
            final actividad = ActividadesOEModel();
            actividad.idDetallePeriodo = dato["id_detalle_periodoc"];
            actividad.idCliente = data["id_cliente"];
            actividad.total = dato["total"];
            actividad.nombreActividad = dato["actividad_nombre"];
            actividad.descripcionDetallePeriodo = dato["detalle_periodoc_descripcion"];
            actividad.cantDetallePeriodo = dato["detalle_periodoc_cant"];
            actividad.umDetallePeriodo = dato["detalle_periodoc_um"];

            await actividadesDB.insertarActividadOE(actividad);
          }
        }

        for (var i = 0; i < decodedData["tipoadjuntos"].length; i++) {
          var datito = decodedData["tipoadjuntos"][i];

          final doc = TipoDocModel();
          doc.idTipoDoc = datito["id_tipo_documentos_ej"];
          doc.nombre = datito["tipo_nombre"];
          doc.estado = datito["tipo_documento_estado"];
          doc.valueCheck = '0';

          await tipoDocDB.insertarTipoDoc(doc);
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
