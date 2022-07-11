class RecursoLogisticaModel {
  String? idRecursoLogistica;
  String? idSede;
  String? nombreClaseLogistica;
  String? nombreRecursoLogistica;
  String? cantidadAlmacen;

  RecursoLogisticaModel({
    this.idRecursoLogistica,
    this.idSede,
    this.nombreClaseLogistica,
    this.nombreRecursoLogistica,
    this.cantidadAlmacen,
  });

  static List<RecursoLogisticaModel> fromJsonList(List<dynamic> json) => json.map((i) => RecursoLogisticaModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idRecursoLogistica': idRecursoLogistica,
        'idSede': idSede,
        'nombreClaseLogistica': nombreClaseLogistica,
        'nombreRecursoLogistica': nombreRecursoLogistica,
        'cantidadAlmacen': cantidadAlmacen,
      };

  factory RecursoLogisticaModel.fromJson(Map<String, dynamic> json) => RecursoLogisticaModel(
        idRecursoLogistica: json["idRecursoLogistica"],
        idSede: json["idSede"],
        nombreClaseLogistica: json["nombreClaseLogistica"],
        nombreRecursoLogistica: json["nombreRecursoLogistica"],
        cantidadAlmacen: json["cantidadAlmacen"],
      );
}
