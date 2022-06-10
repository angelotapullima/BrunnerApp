class DetalleOPModel {
  String? idDetalleOP;
  String? idOP;
  String? idDetalleSI;
  String? precioUnitario;
  String? precioTotal;
  String? idSI;
  String? idRecurso;
  String? idTipoRecurso;
  String? descripcionSI;
  String? umSI;
  String? cantidadSI;
  String? estadoSI;
  String? atentidoSI;
  String? cajaAlmacenSI;
  String? tipoNombreRecurso;
  String? logisticaNombreRecurso;

  DetalleOPModel({
    this.idDetalleOP,
    this.idOP,
    this.idDetalleSI,
    this.precioUnitario,
    this.precioTotal,
    this.idSI,
    this.idRecurso,
    this.idTipoRecurso,
    this.descripcionSI,
    this.umSI,
    this.cantidadSI,
    this.estadoSI,
    this.atentidoSI,
    this.cajaAlmacenSI,
    this.tipoNombreRecurso,
    this.logisticaNombreRecurso,
  });

  static List<DetalleOPModel> fromJsonList(List<dynamic> json) => json.map((i) => DetalleOPModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idDetalleOP': idDetalleOP,
        'idOP': idOP,
        'idDetalleSI': idDetalleSI,
        'precioUnitario': precioUnitario,
        'precioTotal': precioTotal,
        'idSI': idSI,
        'idRecurso': idRecurso,
        'idTipoRecurso': idTipoRecurso,
        'descripcionSI': descripcionSI,
        'umSI': umSI,
        'cantidadSI': cantidadSI,
        'estadoSI': estadoSI,
        'atentidoSI': atentidoSI,
        'cajaAlmacenSI': cajaAlmacenSI,
        'tipoNombreRecurso': tipoNombreRecurso,
        'logisticaNombreRecurso': logisticaNombreRecurso,
      };

  factory DetalleOPModel.fromJson(Map<String, dynamic> json) => DetalleOPModel(
        idDetalleOP: json["idDetalleOP"],
        idOP: json["idOP"],
        idDetalleSI: json["idDetalleSI"],
        precioUnitario: json["precioUnitario"],
        precioTotal: json["precioTotal"],
        idSI: json["idSI"],
        idRecurso: json["idRecurso"],
        idTipoRecurso: json["idTipoRecurso"],
        descripcionSI: json["descripcionSI"],
        umSI: json["umSI"],
        cantidadSI: json["cantidadSI"],
        estadoSI: json["estadoSI"],
        atentidoSI: json["atentidoSI"],
        cajaAlmacenSI: json["cajaAlmacenSI"],
        tipoNombreRecurso: json["tipoNombreRecurso"],
        logisticaNombreRecurso: json["logisticaNombreRecurso"],
      );
}
