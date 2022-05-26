class CheckItemInspeccionModel {
  String? idCheckItemInsp;
  String? idCatInspeccion;
  String? idItemInspeccion;
  String? idVehiculo;
  String? conteoCheckItemInsp;
  String? descripcionCheckItemInsp;
  String? estadoMantenimientoCheckItemInsp;
  String? estadoCheckItemInsp;
  String? valueCheckItemInsp;
  String? ckeckItemHabilitado;
  String? observacionCkeckItemInsp;

  CheckItemInspeccionModel({
    this.idCheckItemInsp,
    this.idCatInspeccion,
    this.idVehiculo,
    this.conteoCheckItemInsp,
    this.descripcionCheckItemInsp,
    this.estadoMantenimientoCheckItemInsp,
    this.estadoCheckItemInsp,
    this.valueCheckItemInsp,
    this.idItemInspeccion,
    this.ckeckItemHabilitado,
    this.observacionCkeckItemInsp,
  });

  static List<CheckItemInspeccionModel> fromJsonList(List<dynamic> json) => json.map((i) => CheckItemInspeccionModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idCheckItemInsp': idCheckItemInsp,
        'idCatInspeccion': idCatInspeccion,
        'idVehiculo': idVehiculo,
        'conteoCheckItemInsp': conteoCheckItemInsp,
        'descripcionCheckItemInsp': descripcionCheckItemInsp,
        'estadoMantenimientoCheckItemInsp': estadoMantenimientoCheckItemInsp,
        'estadoCheckItemInsp': estadoCheckItemInsp,
        'valueCheckItemInsp': valueCheckItemInsp,
        'idItemInspeccion': idItemInspeccion,
        'ckeckItemHabilitado': ckeckItemHabilitado,
        'observacionCkeckItemInsp': observacionCkeckItemInsp,
      };

  factory CheckItemInspeccionModel.fromJson(Map<String, dynamic> json) => CheckItemInspeccionModel(
        idCheckItemInsp: json["idCheckItemInsp"],
        idCatInspeccion: json["idCatInspeccion"],
        idVehiculo: json["idVehiculo"],
        conteoCheckItemInsp: json["conteoCheckItemInsp"],
        descripcionCheckItemInsp: json["descripcionCheckItemInsp"],
        estadoMantenimientoCheckItemInsp: json["estadoMantenimientoCheckItemInsp"],
        estadoCheckItemInsp: json["estadoCheckItemInsp"],
        valueCheckItemInsp: json["valueCheckItemInsp"],
        idItemInspeccion: json["idItemInspeccion"],
        ckeckItemHabilitado: json["ckeckItemHabilitado"],
        observacionCkeckItemInsp: json["observacionCkeckItemInsp"],
      );
}
