class LugaresOEModel {
  String? idLugarEjecucion;
  String? idPeriodo;
  String? establecimientoLugar;
  String? idLugar;

  LugaresOEModel({
    this.idLugarEjecucion,
    this.idPeriodo,
    this.establecimientoLugar,
    this.idLugar,
  });

  static List<LugaresOEModel> fromJsonList(List<dynamic> json) => json.map((i) => LugaresOEModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idLugarEjecucion': idLugarEjecucion,
        'idPeriodo': idPeriodo,
        'establecimientoLugar': establecimientoLugar,
        'idLugar': idLugar,
      };

  factory LugaresOEModel.fromJson(Map<String, dynamic> json) => LugaresOEModel(
        idLugarEjecucion: json["idLugarEjecucion"],
        idPeriodo: json["idPeriodo"],
        establecimientoLugar: json["establecimientoLugar"],
        idLugar: json["idLugar"],
      );
}
