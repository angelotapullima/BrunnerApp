class LugaresOEModel {
  String? idLugarEjecucion;
  String? idCliente;
  String? establecimientoLugar;
  String? idLugar;

  LugaresOEModel({
    this.idLugarEjecucion,
    this.idCliente,
    this.establecimientoLugar,
    this.idLugar,
  });

  static List<LugaresOEModel> fromJsonList(List<dynamic> json) => json.map((i) => LugaresOEModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idLugarEjecucion': idLugarEjecucion,
        'idCliente': idCliente,
        'establecimientoLugar': establecimientoLugar,
        'idLugar': idLugar,
      };

  factory LugaresOEModel.fromJson(Map<String, dynamic> json) => LugaresOEModel(
        idLugarEjecucion: json["idLugarEjecucion"],
        idCliente: json["idCliente"],
        establecimientoLugar: json["establecimientoLugar"],
        idLugar: json["idLugar"],
      );
}
