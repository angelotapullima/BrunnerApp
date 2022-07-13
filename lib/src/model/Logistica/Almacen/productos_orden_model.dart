class ProductosOrdenModel {
  String? idDetalleAlmacen;
  String? idAlmacenLog;
  String? idRecursoLogistica;
  String? idTipoRecurso;
  String? unidadDetalleAlmacen;
  String? stockDetalleAlmacen;
  String? tipoDetalleAlmacen;
  String? descripcionDetalleAlmacen;
  String? ubicacionDetalleAlmacen;
  String? nombreClaseLogistica;
  String? tipoAlmacenLogistica;
  String? nombreTipoRecurso;
  String? nombreRecursoLogistica;
  String? fechaRecursoLog;
  String? horaRecursoLog;

  ProductosOrdenModel({
    this.idDetalleAlmacen,
    this.idAlmacenLog,
    this.idRecursoLogistica,
    this.idTipoRecurso,
    this.unidadDetalleAlmacen,
    this.stockDetalleAlmacen,
    this.tipoDetalleAlmacen,
    this.descripcionDetalleAlmacen,
    this.ubicacionDetalleAlmacen,
    this.nombreClaseLogistica,
    this.tipoAlmacenLogistica,
    this.nombreTipoRecurso,
    this.nombreRecursoLogistica,
    this.fechaRecursoLog,
    this.horaRecursoLog,
  });

  static List<ProductosOrdenModel> fromJsonList(List<dynamic> json) => json.map((i) => ProductosOrdenModel.fromJson(i)).toList();
  Map<String, dynamic> toJson() => {
        'idDetalleAlmacen': idDetalleAlmacen,
        'idAlmacenLog': idAlmacenLog,
        'idRecursoLogistica': idRecursoLogistica,
        'idTipoRecurso': idTipoRecurso,
        'unidadDetalleAlmacen': unidadDetalleAlmacen,
        'stockDetalleAlmacen': stockDetalleAlmacen,
        'tipoDetalleAlmacen': tipoDetalleAlmacen,
        'descripcionDetalleAlmacen': descripcionDetalleAlmacen,
        'ubicacionDetalleAlmacen': ubicacionDetalleAlmacen,
        'nombreClaseLogistica': nombreClaseLogistica,
        'tipoAlmacenLogistica': tipoAlmacenLogistica,
        'nombreTipoRecurso': nombreTipoRecurso,
        'nombreRecursoLogistica': nombreRecursoLogistica,
        'fechaRecursoLog': fechaRecursoLog,
        'horaRecursoLog': horaRecursoLog,
      };

  factory ProductosOrdenModel.fromJson(Map<String, dynamic> json) => ProductosOrdenModel(
        idDetalleAlmacen: json["idDetalleAlmacen"],
        idAlmacenLog: json["idAlmacenLog"],
        idRecursoLogistica: json["idRecursoLogistica"],
        idTipoRecurso: json["idTipoRecurso"],
        unidadDetalleAlmacen: json["unidadDetalleAlmacen"],
        stockDetalleAlmacen: json["stockDetalleAlmacen"],
        tipoDetalleAlmacen: json["tipoDetalleAlmacen"],
        descripcionDetalleAlmacen: json["descripcionDetalleAlmacen"],
        ubicacionDetalleAlmacen: json["ubicacionDetalleAlmacen"],
        nombreClaseLogistica: json["nombreClaseLogistica"],
        tipoAlmacenLogistica: json["tipoAlmacenLogistica"],
        nombreTipoRecurso: json["nombreTipoRecurso"],
        nombreRecursoLogistica: json["nombreRecursoLogistica"],
        fechaRecursoLog: json["fechaRecursoLog"],
        horaRecursoLog: json["horaRecursoLog"],
      );
}
