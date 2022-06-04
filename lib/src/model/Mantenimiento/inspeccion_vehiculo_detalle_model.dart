import 'package:new_brunner_app/src/model/Mantenimiento/mantenimiento_correctivo_model.dart';

class InspeccionVehiculoDetalleModel {
  String? idInspeccionDetalle;
  String? tipoUnidad;
  String? idVehiculo;
  String? plavaVehiculo;
  String? nroCheckList;
  String? fechaInspeccion;
  String? horaInspeccion;
  String? idCategoria;
  String? descripcionCategoria;
  String? idItemInspeccion;
  String? descripcionItem;
  String? idInspeccionVehiculo;
  String? estadoInspeccionDetalle;
  String? observacionInspeccionDetalle;
  String? estadoFinalInspeccionDetalle;
  String? observacionFinalInspeccionDetalle;
  //No en DB
  List<MantenimientoCorrectivoModel>? mantCorrectivos;

  InspeccionVehiculoDetalleModel({
    this.idInspeccionDetalle,
    this.tipoUnidad,
    this.idVehiculo,
    this.plavaVehiculo,
    this.nroCheckList,
    this.fechaInspeccion,
    this.horaInspeccion,
    this.idCategoria,
    this.descripcionCategoria,
    this.idItemInspeccion,
    this.descripcionItem,
    this.idInspeccionVehiculo,
    this.estadoInspeccionDetalle,
    this.observacionInspeccionDetalle,
    this.estadoFinalInspeccionDetalle,
    this.observacionFinalInspeccionDetalle,
    //No en DB
    this.mantCorrectivos,
  });

  static List<InspeccionVehiculoDetalleModel> fromJsonList(List<dynamic> json) =>
      json.map((i) => InspeccionVehiculoDetalleModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idInspeccionDetalle': idInspeccionDetalle,
        'tipoUnidad': tipoUnidad,
        'idVehiculo': idVehiculo,
        'plavaVehiculo': plavaVehiculo,
        'nroCheckList': nroCheckList,
        'fechaInspeccion': fechaInspeccion,
        'horaInspeccion': horaInspeccion,
        'idCategoria': idCategoria,
        'descripcionCategoria': descripcionCategoria,
        'idItemInspeccion': idItemInspeccion,
        'descripcionItem': descripcionItem,
        'idInspeccionVehiculo': idInspeccionVehiculo,
        'estadoInspeccionDetalle': estadoInspeccionDetalle,
        'observacionInspeccionDetalle': observacionInspeccionDetalle,
        'estadoFinalInspeccionDetalle': estadoFinalInspeccionDetalle,
        'observacionFinalInspeccionDetalle': observacionFinalInspeccionDetalle,
      };

  factory InspeccionVehiculoDetalleModel.fromJson(Map<String, dynamic> json) => InspeccionVehiculoDetalleModel(
        idInspeccionDetalle: json["idInspeccionDetalle"],
        tipoUnidad: json["tipoUnidad"],
        idVehiculo: json["idVehiculo"],
        plavaVehiculo: json["plavaVehiculo"],
        nroCheckList: json["nroCheckList"],
        fechaInspeccion: json["fechaInspeccion"],
        horaInspeccion: json["horaInspeccion"],
        idCategoria: json["idCategoria"],
        descripcionCategoria: json["descripcionCategoria"],
        idItemInspeccion: json["idItemInspeccion"],
        descripcionItem: json["descripcionItem"],
        idInspeccionVehiculo: json["idInspeccionVehiculo"],
        estadoInspeccionDetalle: json["estadoInspeccionDetalle"],
        observacionInspeccionDetalle: json["observacionInspeccionDetalle"],
        estadoFinalInspeccionDetalle: json["estadoFinalInspeccionDetalle"],
        observacionFinalInspeccionDetalle: json["observacionFinalInspeccionDetalle"],
      );
}
