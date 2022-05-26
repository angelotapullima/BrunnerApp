import 'dart:convert';
import 'dart:io';

import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/database/Menu/modulo_database.dart';
import 'package:new_brunner_app/src/database/Menu/submodulo_database.dart';
import 'package:new_brunner_app/src/model/Menu/modulos_model.dart';
import 'package:new_brunner_app/src/model/Menu/submodulo_model.dart';
import 'package:new_brunner_app/src/model/api_result_model.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  final moduloDB = ModuloDatabase();
  final submoduloDB = SubModuloDatabase();
  Future<ApiResultModel> login(String user, String pass) async {
    final res = ApiResultModel();
    try {
      final url = Uri.parse('$apiBaseURL/api/login/singIn');
      final resp = await http.post(
        url,
        body: {
          'app': 'true',
          'user': user,
          'pass': pass,
        },
      );
      final decodedData = json.decode(resp.body);

      if (resp.statusCode == 200) {
        res.code = decodedData['result']['code'];
        res.message = decodedData['result']['message'];

        if (res.code == 1) {
          var data = decodedData['data'];

          Preferences.saveData('id_user', data['c_u']);
          Preferences.saveData('id_person', data['c_p']);
          Preferences.saveData('user_nickname', data['_n']);
          Preferences.saveData('user_email', data['u_e']);
          Preferences.saveData('image', data['u_i']);
          Preferences.saveData('person_name', data['p_n']);
          Preferences.saveData('person_surname', data['p_s']);
          Preferences.saveData('id_rol', data['ru']);
          Preferences.saveData('rol_nombre', data['rn']);
          Preferences.saveData('token', data['tn']);

          //Guardar Modulos
          for (var i = 0; i < decodedData['modulos'].length; i++) {
            var datos = decodedData['modulos'][i];

            if (datos['agrupacion_app'] == '1') {
              final modulo = ModulosModel();

              modulo.idModulo = datos['id_agrupacion'];
              modulo.nombreModulo = datos['agrupacion_nombre'];
              modulo.ordenModulo = datos['agrupacion_orden'];
              modulo.estadoModulo = datos['agrupacion_estado'];
              modulo.visibleAppModulo = datos['agrupacion_app'];

              await moduloDB.insertarModulo(modulo);
            }
          }

          //Guardar SubModulos
          for (var i = 0; i < decodedData['submodulos'].length; i++) {
            var datos = decodedData['submodulos'][i];

            if (datos['menu_app'] == '1') {
              final subModulo = SubModuloModel();

              subModulo.idSubModulo = datos['id_menu'];
              subModulo.idModulo = datos['id_agrupacion'];
              subModulo.nameSubModulo = datos['menu_name'];
              subModulo.estadoSubModulo = datos['menu_status'];
              subModulo.visibleAppSubModulo = datos['menu_app'];

              await submoduloDB.insertarSubModulo(subModulo);
            }
          }
        }

        return res;
      } else {
        res.code = 200;
        res.message = 'Problemas con la conexión a Internet, inténtelo nuevamente';
        return res;
      }
    } catch (e) {
      print(e);
      if (e is SocketException) {
        res.code = e.port;
        res.message = 'Asegúrese que el dispositivo cuente con una conexión a Internet';
        return res;
      }
      res.code = 2;
      res.message = 'Ocurrió un error, inténtelo nuevamente';
      return res;
    }
  }
}
