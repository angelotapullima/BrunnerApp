class ClientesOEModel {
  String? idCliente;
  String? id;
  String? nombreCliente;
  String? logoCliente;

  ClientesOEModel({
    this.idCliente,
    this.id,
    this.nombreCliente,
    this.logoCliente,
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
