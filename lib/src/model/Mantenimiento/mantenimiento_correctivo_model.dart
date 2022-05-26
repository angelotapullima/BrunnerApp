class MantenimientoCorrectivoModel {
  String? idMantenimiento;
  String? idInspeccionDetalle;
  String? responsable;
  String? idResponsable;
  String? estado;
  String? diagnostico;
  String? fechaDiagnostico;
  String? conclusion;
  String? recomendacion;
  String? dateTimeMantenimiento;
  String? estadoFinal;
  String? fechaFinalMantenimiento;

  MantenimientoCorrectivoModel({
    this.idMantenimiento,
    this.idInspeccionDetalle,
    this.responsable,
    this.idResponsable,
    this.estado,
    this.diagnostico,
    this.fechaDiagnostico,
    this.conclusion,
    this.recomendacion,
    this.dateTimeMantenimiento,
    this.estadoFinal,
    this.fechaFinalMantenimiento,
  });

  static List<MantenimientoCorrectivoModel> fromJsonList(List<dynamic> json) => json.map((i) => MantenimientoCorrectivoModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idMantenimiento': idMantenimiento,
        'idInspeccionDetalle': idInspeccionDetalle,
        'responsable': responsable,
        'idResponsable': idResponsable,
        'estado': estado,
        'diagnostico': diagnostico,
        'fechaDiagnostico': fechaDiagnostico,
        'conclusion': conclusion,
        'recomendacion': recomendacion,
        'dateTimeMantenimiento': dateTimeMantenimiento,
        'estadoFinal': estadoFinal,
        'fechaFinalMantenimiento': fechaFinalMantenimiento,
      };

  factory MantenimientoCorrectivoModel.fromJson(Map<String, dynamic> json) => MantenimientoCorrectivoModel(
        idMantenimiento: json["idMantenimiento"],
        idInspeccionDetalle: json["idInspeccionDetalle"],
        responsable: json["responsable"],
        idResponsable: json["idResponsable"],
        estado: json["estado"],
        diagnostico: json["diagnostico"],
        fechaDiagnostico: json["fechaDiagnostico"],
        conclusion: json["conclusion"],
        recomendacion: json["recomendacion"],
        dateTimeMantenimiento: json["dateTimeMantenimiento"],
        estadoFinal: json["estadoFinal"],
        fechaFinalMantenimiento: json["fechaFinalMantenimiento"],
      );
}
