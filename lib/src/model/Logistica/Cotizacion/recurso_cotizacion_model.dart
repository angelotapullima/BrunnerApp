class RecursoCotizacionModel {
  String? idLogisticaRecurso;
  String? idClase;
  String? nameRecurso;
  String? unidadRecurso;
  String? idTypeLogistica;
  String? nameClase;
  String? nameType;

  RecursoCotizacionModel({
    this.idLogisticaRecurso,
    this.idClase,
    this.nameRecurso,
    this.unidadRecurso,
    this.idTypeLogistica,
    this.nameClase,
    this.nameType,
  });

  static List<RecursoCotizacionModel> fromJsonList(List<dynamic> json) => json.map((i) => RecursoCotizacionModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idLogisticaRecurso': idLogisticaRecurso,
        'idClase': idClase,
        'nameRecurso': nameRecurso,
        'unidadRecurso': unidadRecurso,
        'idTypeLogistica': idTypeLogistica,
        'nameClase': nameClase,
        'nameType': nameType,
      };

  factory RecursoCotizacionModel.fromJson(Map<String, dynamic> json) => RecursoCotizacionModel(
        idLogisticaRecurso: json["idLogisticaRecurso"],
        idClase: json["idClase"],
        nameRecurso: json["nameRecurso"],
        unidadRecurso: json["unidadRecurso"],
        idTypeLogistica: json["idTypeLogistica"],
        nameClase: json["nameClase"],
        nameType: json["nameType"],
      );
}
