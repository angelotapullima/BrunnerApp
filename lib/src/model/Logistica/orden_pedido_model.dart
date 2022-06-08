class OrdenPedidoModel {
  String? idOP;
  String? numeroOP;
  String? nombreEmpresa;
  String? nombreSede;
  String? nombreProveedor;
  String? monedaOP;
  String? totalOP;
  String? fechaOP;
  String? nombrePerson;
  String? surnamePerson;
  String? surname2Person;
  String? estado;
  String? rendido;

  OrdenPedidoModel({
    this.idOP,
    this.numeroOP,
    this.nombreEmpresa,
    this.nombreSede,
    this.nombreProveedor,
    this.monedaOP,
    this.totalOP,
    this.fechaOP,
    this.nombrePerson,
    this.surnamePerson,
    this.surname2Person,
    this.estado,
    this.rendido,
  });

  static List<OrdenPedidoModel> fromJsonList(List<dynamic> json) => json.map((i) => OrdenPedidoModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idOP': idOP,
        'numeroOP': numeroOP,
        'nombreEmpresa': nombreEmpresa,
        'nombreSede': nombreSede,
        'nombreProveedor': nombreProveedor,
        'monedaOP': monedaOP,
        'totalOP': totalOP,
        'fechaOP': fechaOP,
        'nombrePerson': nombrePerson,
        'surnamePerson': surnamePerson,
        'surname2Person': surname2Person,
        'estado': estado,
        'rendido': rendido,
      };

  factory OrdenPedidoModel.fromJson(Map<String, dynamic> json) => OrdenPedidoModel(
        idOP: json["idOP"],
        numeroOP: json["numeroOP"],
        nombreEmpresa: json["nombreEmpresa"],
        nombreSede: json["nombreSede"],
        nombreProveedor: json["nombreProveedor"],
        monedaOP: json["monedaOP"],
        totalOP: json["totalOP"],
        fechaOP: json["fechaOP"],
        nombrePerson: json["nombrePerson"],
        surnamePerson: json["surnamePerson"],
        surname2Person: json["surname2Person"],
        estado: json["estado"],
        rendido: json["rendido"],
      );
}
