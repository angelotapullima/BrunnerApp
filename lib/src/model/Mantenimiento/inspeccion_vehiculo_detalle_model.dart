import 'package:new_brunner_app/src/model/Mantenimiento/mantenimiento_correctivo_model.dart';

class InspeccionVehiculoDetalleModel {
  String? idInspeccionDetalle;
  String? tipoUnidad;
  String? plavaVehiculo;
  String? nroCheckList;
  String? fechsInspeccion;
  String? horaInspeccion;
  String? idCategoria;
  String? descripcionCategoria;
  String? idItemInspeccion;
  String? descripcionItem;
  String? idInspeccionVehiculo;
  String? estadoInspeccionDetalle;
  String? observacionInspeccionDetalle;
  String? estadoFinalInspeccionDetalle;
  //No en DB
  List<MantenimientoCorrectivoModel>? mantCorrectivos;

  InspeccionVehiculoDetalleModel({
    this.idInspeccionDetalle,
    this.tipoUnidad,
    this.plavaVehiculo,
    this.nroCheckList,
    this.fechsInspeccion,
    this.horaInspeccion,
    this.idCategoria,
    this.descripcionCategoria,
    this.idItemInspeccion,
    this.descripcionItem,
    this.idInspeccionVehiculo,
    this.estadoInspeccionDetalle,
    this.observacionInspeccionDetalle,
    this.estadoFinalInspeccionDetalle,
    this.mantCorrectivos,
  });

  static List<InspeccionVehiculoDetalleModel> fromJsonList(List<dynamic> json) =>
      json.map((i) => InspeccionVehiculoDetalleModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idInspeccionDetalle': idInspeccionDetalle,
        'tipoUnidad': tipoUnidad,
        'plavaVehiculo': plavaVehiculo,
        'nroCheckList': nroCheckList,
        'fechsInspeccion': fechsInspeccion,
        'horaInspeccion': horaInspeccion,
        'idCategoria': idCategoria,
        'descripcionCategoria': descripcionCategoria,
        'idItemInspeccion': idItemInspeccion,
        'descripcionItem': descripcionItem,
        'idInspeccionVehiculo': idInspeccionVehiculo,
        'estadoInspeccionDetalle': estadoInspeccionDetalle,
        'observacionInspeccionDetalle': observacionInspeccionDetalle,
        'estadoFinalInspeccionDetalle': estadoFinalInspeccionDetalle,
      };

  factory InspeccionVehiculoDetalleModel.fromJson(Map<String, dynamic> json) => InspeccionVehiculoDetalleModel(
        idInspeccionDetalle: json["idInspeccionDetalle"],
        tipoUnidad: json["tipoUnidad"],
        plavaVehiculo: json["plavaVehiculo"],
        nroCheckList: json["nroCheckList"],
        fechsInspeccion: json["fechsInspeccion"],
        horaInspeccion: json["horaInspeccion"],
        idCategoria: json["idCategoria"],
        descripcionCategoria: json["descripcionCategoria"],
        idItemInspeccion: json["idItemInspeccion"],
        descripcionItem: json["descripcionItem"],
        idInspeccionVehiculo: json["idInspeccionVehiculo"],
        estadoInspeccionDetalle: json["estadoInspeccionDetalle"],
        observacionInspeccionDetalle: json["observacionInspeccionDetalle"],
        estadoFinalInspeccionDetalle: json["estadoFinalInspeccionDetalle"],
      );
}
