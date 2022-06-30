import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/orden_ejecucion_model.dart';

class ClientesOEModel {
  String? idCliente;
  String? id;
  String? nombreCliente;
  String? logoCliente;

  //No en db
  OrdenEjecucionModel? oe;
  String? descripcion;

  ClientesOEModel({
    this.idCliente,
    this.id,
    this.nombreCliente,
    this.logoCliente,
    this.oe,
    this.descripcion,
  });

  static List<ClientesOEModel> fromJsonList(List<dynamic> json) => json.map((i) => ClientesOEModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idCliente': idCliente,
        'id': id,
        'nombreCliente': nombreCliente,
        'logoCliente': logoCliente,
      };

  factory ClientesOEModel.fromJson(Map<String, dynamic> json) => ClientesOEModel(
        idCliente: json["idCliente"],
        id: json["id"],
        nombreCliente: json["nombreCliente"],
        logoCliente: json["logoCliente"],
      );
}
