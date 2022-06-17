class ClientesModel {
  String? idCliente;
  String? nombreCliente;

  ClientesModel({
    this.idCliente,
    this.nombreCliente,
  });

  static List<ClientesModel> fromJsonList(List<dynamic> json) => json.map((i) => ClientesModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idCliente': idCliente,
        'nombreCliente': nombreCliente,
      };

  factory ClientesModel.fromJson(Map<String, dynamic> json) => ClientesModel(
        idCliente: json["idCliente"],
        nombreCliente: json["nombreCliente"],
      );
}
