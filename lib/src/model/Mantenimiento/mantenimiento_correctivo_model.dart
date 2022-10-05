import 'package:new_brunner_app/src/model/Mantenimiento/mantto_detalle_model.dart';

class MantenimientoCorrectivoModel {
  String? idMantenimiento;
  String? idInspeccionDetalle;
  String? responsable;
  String? idResponsable;
  String? estado;
  String? dateTimeMantenimiento;
  String? estadoFinal;
  String? fechaFinalMantenimiento;

  //No DB
  List<ManttoDetalleModel>? listDetails;

  MantenimientoCorrectivoModel({
    this.idMantenimiento,
    this.idInspeccionDetalle,
    this.responsable,
    this.idResponsable,
    this.estado,
    this.dateTimeMantenimiento,
    this.estadoFinal,
    this.fechaFinalMantenimiento,
    this.listDetails,
  });

  static List<MantenimientoCorrectivoModel> fromJsonList(List<dynamic> json) => json.map((i) => MantenimientoCorrectivoModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idMantenimiento': idMantenimiento,
        'idInspeccionDetalle': idInspeccionDetalle,
        'responsable': responsable,
        'idResponsable': idResponsable,
        'estado': estado,
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
        dateTimeMantenimiento: json["dateTimeMantenimiento"],
        estadoFinal: json["estadoFinal"],
        fechaFinalMantenimiento: json["fechaFinalMantenimiento"],
      );
}
