class ManttoDetalleModel {
  String? idManttoDetalle;
  String? idMantenimiento;
  String? registrador;
  String? tipoDetalle;
  String? descripcionDetalle;
  String? estadoDetalle;
  String? fechaDetalle;

  ManttoDetalleModel({
    this.idManttoDetalle,
    this.idMantenimiento,
    this.registrador,
    this.tipoDetalle,
    this.descripcionDetalle,
    this.estadoDetalle,
    this.fechaDetalle,
  });

  static List<ManttoDetalleModel> fromJsonList(List<dynamic> json) => json.map((i) => ManttoDetalleModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idManttoDetalle': idManttoDetalle,
        'idMantenimiento': idMantenimiento,
        'registrador': registrador,
        'tipoDetalle': tipoDetalle,
        'descripcionDetalle': descripcionDetalle,
        'estadoDetalle': estadoDetalle,
        'fechaDetalle': fechaDetalle,
      };

  factory ManttoDetalleModel.fromJson(Map<String, dynamic> json) => ManttoDetalleModel(
        idManttoDetalle: json["idManttoDetalle"],
        idMantenimiento: json["idMantenimiento"],
        registrador: json["registrador"],
        tipoDetalle: json["tipoDetalle"],
        descripcionDetalle: json["descripcionDetalle"],
        estadoDetalle: json["estadoDetalle"],
        fechaDetalle: json["fechaDetalle"],
      );
}
