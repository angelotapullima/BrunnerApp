class InspeccionVehiculoItemModel {
  String? idCheckItemInsp;
  String? idCatInspeccion;
  String? idItemInspeccion;
  String? idInspeccionVehiculo;
  String? conteoCheckItemInsp;
  String? descripcionCheckItemInsp;
  String? estadoMantenimientoCheckItemInsp;
  String? estadoCheckItemInsp;
  String? valueCheckItemInsp;
  String? ckeckItemHabilitado;
  String? observacionCkeckItemInsp;
  String? responsableCheckItemInsp;
  String? atencionCheckItemInsp;
  String? nombreCategoria;
  String? conclusionCheckItemInsp;

  InspeccionVehiculoItemModel({
    this.idCheckItemInsp,
    this.idCatInspeccion,
    this.idInspeccionVehiculo,
    this.conteoCheckItemInsp,
    this.descripcionCheckItemInsp,
    this.estadoMantenimientoCheckItemInsp,
    this.estadoCheckItemInsp,
    this.valueCheckItemInsp,
    this.idItemInspeccion,
    this.ckeckItemHabilitado,
    this.observacionCkeckItemInsp,
    this.responsableCheckItemInsp,
    this.atencionCheckItemInsp,
    this.conclusionCheckItemInsp,
    this.nombreCategoria,
  });

  static List<InspeccionVehiculoItemModel> fromJsonList(List<dynamic> json) => json.map((i) => InspeccionVehiculoItemModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idCheckItemInsp': idCheckItemInsp,
        'idCatInspeccion': idCatInspeccion,
        'idInspeccionVehiculo': idInspeccionVehiculo,
        'conteoCheckItemInsp': conteoCheckItemInsp,
        'descripcionCheckItemInsp': descripcionCheckItemInsp,
        'estadoMantenimientoCheckItemInsp': estadoMantenimientoCheckItemInsp,
        'estadoCheckItemInsp': estadoCheckItemInsp,
        'valueCheckItemInsp': valueCheckItemInsp,
        'idItemInspeccion': idItemInspeccion,
        'ckeckItemHabilitado': ckeckItemHabilitado,
        'observacionCkeckItemInsp': observacionCkeckItemInsp,
        'responsableCheckItemInsp': responsableCheckItemInsp,
        'atencionCheckItemInsp': atencionCheckItemInsp,
        'conclusionCheckItemInsp': conclusionCheckItemInsp,
        'nombreCategoria': nombreCategoria,
      };

  factory InspeccionVehiculoItemModel.fromJson(Map<String, dynamic> json) => InspeccionVehiculoItemModel(
        idCheckItemInsp: json["idCheckItemInsp"],
        idCatInspeccion: json["idCatInspeccion"],
        idInspeccionVehiculo: json["idInspeccionVehiculo"],
        conteoCheckItemInsp: json["conteoCheckItemInsp"],
        descripcionCheckItemInsp: json["descripcionCheckItemInsp"],
        estadoMantenimientoCheckItemInsp: json["estadoMantenimientoCheckItemInsp"],
        estadoCheckItemInsp: json["estadoCheckItemInsp"],
        valueCheckItemInsp: json["valueCheckItemInsp"],
        idItemInspeccion: json["idItemInspeccion"],
        ckeckItemHabilitado: json["ckeckItemHabilitado"],
        observacionCkeckItemInsp: json["observacionCkeckItemInsp"],
        responsableCheckItemInsp: json["responsableCheckItemInsp"],
        atencionCheckItemInsp: json["atencionCheckItemInsp"],
        conclusionCheckItemInsp: json["conclusionCheckItemInsp"],
        nombreCategoria: json["nombreCategoria"],
      );
}
