import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_brunner_app/src/core/routes_constanst.dart';

import 'package:new_brunner_app/src/model/api_result_model.dart';

class ConsultaExternaApi {
  Future<ApiResultModel> searchDNI(String dni) async {
    ApiResultModel result = ApiResultModel();
    try {
      final url = 'https://api.migo.pe/api/v1/dni';

      final response = await http.post(Uri.parse(url),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'token': tokenBrunner,
            'dni': dni,
          }));

      final decodedData = json.decode(response.body);
      if (response.statusCode == 200) {
        result.code = 200;
        result.message = '${decodedData['nombre']}';
      } else {
        result.code = 2;
        result.message = 'Inténtelo Nuevamente';
      }

      return result;
    } catch (e) {
      print(e);
      result.code = 2;
      result.message = 'Ocurrió un error';
      return result;
    }
  }

  Future<ApiResultModel> searchRUC(String ruc) async {
    ApiResultModel result = ApiResultModel();
    try {
      final url = 'https://api.migo.pe/api/v1/ruc';
      final response = await http.post(Uri.parse(url),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'token': tokenBrunner,
            'ruc': ruc,
          }));

      final decodedData = json.decode(response.body);
      if (response.statusCode == 200) {
        result.code = 200;
        result.message = '${decodedData['nombre_o_razon_social']}';
      } else {
        result.code = 2;
        result.message = 'Inténtelo Nuevamente';
      }

      return result;
    } catch (e) {
      print(e);
      result.code = 2;
      result.message = 'Ocurrió un error';
      return result;
    }
  }

  Future<ApiResultModel> getTipoCambio(String date) async {
    ApiResultModel result = ApiResultModel();
    try {
      final url = 'https://api.migo.pe/api/v1/exchange/date';
      final response = await http.post(Uri.parse(url),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'token': tokenBrunner,
            'ruc': date,
          }));

      final decodedData = json.decode(response.body);
      if (response.statusCode == 200) {
        result.code = 200;
        result.message = '${decodedData['precio_compra']}';
      } else {
        result.code = 2;
        result.message = 'Inténtelo Nuevamente';
      }

      return result;
    } catch (e) {
      print(e);
      result.code = 2;
      result.message = 'Ocurrió un error';
      return result;
    }
  }
}
