import 'package:new_brunner_app/src/model/Logistica/detalle_op_model.dart';

class OrdenPedidoModel {
  String? idOP;
  String? numeroOP;
  String? nombreEmpresa;
  String? nombreSede;
  String? idProveedor;
  String? nombreProveedor;
  String? monedaOP;
  String? totalOP;
  String? fechaOP;
  String? nombrePerson;
  String? surnamePerson;
  String? surname2Person;
  String? nombreApro;
  String? surnameApro;
  String? surname2Apro;
  String? fechaCreacion;
  String? estado;
  String? rendido;

  //No en DB
  List<DetalleOPModel>? detalle;

  OrdenPedidoModel({
    this.idOP,
    this.numeroOP,
    this.nombreEmpresa,
    this.nombreSede,
    this.idProveedor,
    this.nombreProveedor,
    this.monedaOP,
    this.totalOP,
    this.fechaOP,
    this.nombrePerson,
    this.surnamePerson,
    this.surname2Person,
    this.nombreApro,
    this.surnameApro,
    this.surname2Apro,
    this.fechaCreacion,
    this.estado,
    this.rendido,
    this.detalle,
  });

  static List<OrdenPedidoModel> fromJsonList(List<dynamic> json) => json.map((i) => OrdenPedidoModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idOP': idOP,
        'numeroOP': numeroOP,
        'nombreEmpresa': nombreEmpresa,
        'nombreSede': nombreSede,
        'idProveedor': idProveedor,
        'nombreProveedor': nombreProveedor,
        'monedaOP': monedaOP,
        'totalOP': totalOP,
        'fechaOP': fechaOP,
        'nombrePerson': nombrePerson,
        'surnamePerson': surnamePerson,
        'surname2Person': surname2Person,
        'nombreApro': nombreApro,
        'surnameApro': surnameApro,
        'surname2Apro': surname2Apro,
        'fechaCreacion': fechaCreacion,
        'estado': estado,
        'rendido': rendido,
      };

  factory OrdenPedidoModel.fromJson(Map<String, dynamic> json) => OrdenPedidoModel(
        idOP: json["idOP"],
        numeroOP: json["numeroOP"],
        nombreEmpresa: json["nombreEmpresa"],
        nombreSede: json["nombreSede"],
        idProveedor: json["idProveedor"],
        nombreProveedor: json["nombreProveedor"],
        monedaOP: json["monedaOP"],
        totalOP: json["totalOP"],
        fechaOP: json["fechaOP"],
        nombrePerson: json["nombrePerson"],
        surnamePerson: json["surnamePerson"],
        surname2Person: json["surname2Person"],
        nombreApro: json["nombreApro"],
        surnameApro: json["surnameApro"],
        surname2Apro: json["surname2Apro"],
        fechaCreacion: json["fechaCreacion"],
        estado: json["estado"],
        rendido: json["rendido"],
      );
}
