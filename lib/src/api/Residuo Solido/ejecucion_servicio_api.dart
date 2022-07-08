import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/database/Empresa/departamento_database.dart';
import 'package:new_brunner_app/src/database/Empresa/empresas_database.dart';
import 'package:new_brunner_app/src/database/Empresa/sede_database.dart';
import 'package:new_brunner_app/src/database/Empresa/tipo_doc_database.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Ejecucion%20Servicio/actividades_oe_database.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Ejecucion%20Servicio/clientes_oe_database.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Ejecucion%20Servicio/codigos_oe_database.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Ejecucion%20Servicio/contactos_oe_database.dart';
import 'package:new_brunner_app/src/database/Residuos%20Solidos/Ejecucion%20Servicio/lugares_oe_database.dart';
import 'package:new_brunner_app/src/model/Empresa/departamento_model.dart';
import 'package:new_brunner_app/src/model/Empresa/empresas_model.dart';
import 'package:new_brunner_app/src/model/Empresa/sede_model.dart';
import 'package:new_brunner_app/src/model/Empresa/tipo_doc_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/actividades_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/clientes_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/codigos_ue_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/contactos_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/lugares_oe_model.dart';

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

        await clientesDB.delete();
        await contactosDB.delete();
        await codigosDB.delete();
        await lugaresDB.delete();
        await actividadesDB.delete();

        final List<ClientesOEModel> lista = [];

        for (var i = 0; i < decodedData["datos_clientes"].length; i++) {
          var data = decodedData["datos_clientes"][i];
          final cliente = ClientesOEModel();
          cliente.idCliente = data["id_cliente"];
          cliente.id = '$idEmpresa$idDepartamento$idSede';
          cliente.nombreCliente = data["cliente_nombre"];
          cliente.logoCliente = '';
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

            //Insertar Lugares
            for (var i = 0; i < dato["lugares"].length; i++) {
              var datos = dato["lugares"][i];
              final lugar = LugaresOEModel();
              lugar.idLugarEjecucion = datos["id_clientelugar_ejecucion"];
              lugar.idPeriodo = dato["id_periodoc"];
              lugar.establecimientoLugar = datos["cliente_lugar_establecimiento"];
              lugar.idLugar = datos["id_cliente_lugar"];

              await lugaresDB.insertarLugarOE(lugar);
            }

            //Insertar Actividades
            for (var r = 0; r < dato["actividades"].length; r++) {
              var datos = dato["actividades"][r];
              final actividad = ActividadesOEModel();
              actividad.idDetallePeriodo = datos["id_detalle_periodoc"];
              actividad.idPeriodo = dato["id_periodoc"];
              actividad.total = datos["total"];
              actividad.nombreActividad = datos["actividad_nombre"];
              actividad.descripcionDetallePeriodo = datos["detalle_periodoc_descripcion"];
              actividad.cantDetallePeriodo = datos["detalle_periodoc_cant"];
              actividad.umDetallePeriodo = datos["detalle_periodoc_um"];

              await actividadesDB.insertarActividadOE(actividad);
            }
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
      print(e);
      return null;
    }
  }

  Future<int> saveOrdenEjecuion(ModelGenerarOE oe) async {
    try {
      String? token = await Preferences.readData('token');
      String? idUser = await Preferences.readData('id_user');

      final url = Uri.parse('$apiBaseURL/api/Ejecucion/save_ejecucion');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'tn': token,
          'id_user_creacion': idUser,
          'id_empresa': oe.idEmpresa,
          'id_departamento': oe.idDepartamento,
          'id_sede': oe.idSede,
          'observaciones': oe.observaciones,
          'ejecucion_cip_rt': oe.responsableCIP,
          'ejecucion_rt': oe.responsable,
          'periodo_contacto': oe.contacto,
          'periodo_telefono': oe.contactoTelefono,
          'periodo_email': oe.contactoEmail,
          'id_lugar': oe.idLugar,
          'select_condicion': oe.condicion,
          'fecha': oe.fecha,
          'contenido': oe.contenido,
          'documento_check': oe.documento,
        },
      );

      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        print(decodedData);

        return decodedData;
      } else {
        return 0;
      }
    } catch (e) {
      print(e);
      return 2;
    }
  }
}

class ModelGenerarOE {
  String? idEmpresa;
  String? idDepartamento;
  String? idSede;
  String? observaciones;
  String? responsableCIP;
  String? responsable;
  String? contacto;
  String? contactoTelefono;
  String? contactoEmail;
  String? idLugar;
  String? condicion;
  String? fecha;
  String? contenido;
  String? documento;
  ModelGenerarOE({
    this.idEmpresa,
    this.idDepartamento,
    this.idSede,
    this.observaciones,
    this.responsableCIP,
    this.responsable,
    this.contacto,
    this.contactoTelefono,
    this.contactoEmail,
    this.idLugar,
    this.condicion,
    this.fecha,
    this.contenido,
    this.documento,
  });
}
