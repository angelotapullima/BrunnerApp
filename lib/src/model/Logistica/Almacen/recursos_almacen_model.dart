class RecursosAlmacenModel {
  String? idAlmacen;
  String? idSede;
  String? idRecursoLogistica;
  String? idTipoRecurso;
  String? unidadAlmacen;
  String? stockAlmacen;
  String? descripcionAlmacen;
  String? ubicacionAlmacen;
  String? idClaseLogistica;
  String? nombreRecurso;
  String? unidadRecurso;
  String? idTipoLogistica;
  String? nombreClaseLogistica;
  String? nombreTipoLogistica;
  String? nombreTipoRecurso;
  String? estadoTipoRecurso;

  RecursosAlmacenModel({
    this.idAlmacen,
    this.idSede,
    this.idRecursoLogistica,
    this.idTipoRecurso,
    this.unidadAlmacen,
    this.stockAlmacen,
    this.descripcionAlmacen,
    this.ubicacionAlmacen,
    this.idClaseLogistica,
    this.nombreRecurso,
    this.unidadRecurso,
    this.idTipoLogistica,
    this.nombreClaseLogistica,
    this.nombreTipoLogistica,
    this.nombreTipoRecurso,
    this.estadoTipoRecurso,
  });

  static List<RecursosAlmacenModel> fromJsonList(List<dynamic> json) => json.map((i) => RecursosAlmacenModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idAlmacen': idAlmacen,
        'idSede': idSede,
        'idRecursoLogistica': idRecursoLogistica,
        'idTipoRecurso': idTipoRecurso,
        'unidadAlmacen': unidadAlmacen,
        'stockAlmacen': stockAlmacen,
        'descripcionAlmacen': descripcionAlmacen,
        'ubicacionAlmacen': ubicacionAlmacen,
        'idClaseLogistica': idClaseLogistica,
        'nombreRecurso': nombreRecurso,
        'unidadRecurso': unidadRecurso,
        'idTipoLogistica': idTipoLogistica,
        'nombreClaseLogistica': nombreClaseLogistica,
        'nombreTipoLogistica': nombreTipoLogistica,
        'nombreTipoRecurso': nombreTipoRecurso,
        'estadoTipoRecurso': estadoTipoRecurso,
      };

  factory RecursosAlmacenModel.fromJson(Map<String, dynamic> json) => RecursosAlmacenModel(
        idAlmacen: json["idAlmacen"],
        idSede: json["idSede"],
        idRecursoLogistica: json["idRecursoLogistica"],
        idTipoRecurso: json["idTipoRecurso"],
        unidadAlmacen: json["unidadAlmacen"],
        stockAlmacen: json["stockAlmacen"],
        descripcionAlmacen: json["descripcionAlmacen"],
        ubicacionAlmacen: json["ubicacionAlmacen"],
        idClaseLogistica: json["idClaseLogistica"],
        nombreRecurso: json["nombreRecurso"],
        unidadRecurso: json["unidadRecurso"],
        idTipoLogistica: json["idTipoLogistica"],
        nombreClaseLogistica: json["nombreClaseLogistica"],
        nombreTipoLogistica: json["nombreTipoLogistica"],
        nombreTipoRecurso: json["nombreTipoRecurso"],
        estadoTipoRecurso: json["estadoTipoRecurso"],
      );
}
