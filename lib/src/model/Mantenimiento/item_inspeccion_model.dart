class ItemInspeccionModel {
  String? id;
  String? idItemInspeccion;
  String? idVehiculo;
  String? idCatInspeccion;
  String? conteoItemInspeccion;
  String? descripcionItemInspeccion;
  String? estadoMantenimientoItemInspeccion;
  String? estadoItemInspeccion;

  ItemInspeccionModel({
    this.id,
    this.idItemInspeccion,
    this.idVehiculo,
    this.idCatInspeccion,
    this.conteoItemInspeccion,
    this.descripcionItemInspeccion,
    this.estadoMantenimientoItemInspeccion,
    this.estadoItemInspeccion,
  });

  static List<ItemInspeccionModel> fromJsonList(List<dynamic> json) => json.map((i) => ItemInspeccionModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'idItemInspeccion': idItemInspeccion,
        'idVehiculo': idVehiculo,
        'idCatInspeccion': idCatInspeccion,
        'conteoItemInspeccion': conteoItemInspeccion,
        'descripcionItemInspeccion': descripcionItemInspeccion,
        'estadoMantenimientoItemInspeccion': estadoMantenimientoItemInspeccion,
        'estadoItemInspeccion': estadoItemInspeccion,
      };

  factory ItemInspeccionModel.fromJson(Map<String, dynamic> json) => ItemInspeccionModel(
        id: json["id"],
        idItemInspeccion: json["idItemInspeccion"],
        idVehiculo: json["idVehiculo"],
        idCatInspeccion: json["idCatInspeccion"],
        conteoItemInspeccion: json["conteoItemInspeccion"],
        descripcionItemInspeccion: json["descripcionItemInspeccion"],
        estadoMantenimientoItemInspeccion: json["estadoMantenimientoItemInspeccion"],
        estadoItemInspeccion: json["estadoItemInspeccion"],
      );
}
