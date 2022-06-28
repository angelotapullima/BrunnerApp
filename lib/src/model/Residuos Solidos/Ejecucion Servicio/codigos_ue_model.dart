class CodigosOEModel {
  String? idCod;
  String? idCliente;
  String? periodoCod;

  CodigosOEModel({
    this.idCod,
    this.idCliente,
    this.periodoCod,
  });

  static List<CodigosOEModel> fromJsonList(List<dynamic> json) => json.map((i) => CodigosOEModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idCod': idCod,
        'idCliente': idCliente,
        'periodoCod': periodoCod,
      };

  factory CodigosOEModel.fromJson(Map<String, dynamic> json) => CodigosOEModel(
        idCod: json["idCod"],
        idCliente: json["idCliente"],
        periodoCod: json["periodoCod"],
      );
}
