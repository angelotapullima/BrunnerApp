class ClientesOEModel {
  String? idCliente;
  String? id;
  String? nombreCliente;

  ClientesOEModel({
    this.idCliente,
    this.id,
    this.nombreCliente,
  });

  static List<ClientesOEModel> fromJsonList(List<dynamic> json) => json.map((i) => ClientesOEModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idCliente': idCliente,
        'id': id,
        'nombreCliente': nombreCliente,
      };

  factory ClientesOEModel.fromJson(Map<String, dynamic> json) => ClientesOEModel(
        idCliente: json["idCliente"],
        id: json["id"],
        nombreCliente: json["nombreCliente"],
      );
}
