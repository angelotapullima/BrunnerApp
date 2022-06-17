import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/database/Empresa/departamento_database.dart';
import 'package:new_brunner_app/src/database/Empresa/empresas_database.dart';
import 'package:new_brunner_app/src/database/Empresa/sede_database.dart';
import 'package:new_brunner_app/src/model/Empresa/clientes_model.dart';
import 'package:new_brunner_app/src/model/Empresa/departamento_model.dart';
import 'package:new_brunner_app/src/model/Empresa/empresas_model.dart';
import 'package:new_brunner_app/src/model/Empresa/sede_model.dart';

class EjecucionServicioApi {
  final empresaDB = EmpresasDatabase();
  final departamentoDB = DepartamentoDatabase();
  final sedeDB = SedeDatabase();

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
}
