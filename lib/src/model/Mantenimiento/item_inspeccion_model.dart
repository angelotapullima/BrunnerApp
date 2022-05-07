class ItemInspeccionModel {
  String? idItemInspeccion;
  String? idCatInspeccion;
  String? conteoItemInspeccion;
  String? descripcionItemInspeccion;
  String? estadoMantenimientoItemInspeccion;
  String? estadoItemInspeccion;

  ItemInspeccionModel({
    this.idItemInspeccion,
    this.idCatInspeccion,
    this.conteoItemInspeccion,
    this.descripcionItemInspeccion,
    this.estadoMantenimientoItemInspeccion,
    this.estadoItemInspeccion,
  });

  static List<ItemInspeccionModel> fromJsonList(List<dynamic> json) => json.map((i) => ItemInspeccionModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idItemInspeccion': idItemInspeccion,
        'idCatInspeccion': idCatInspeccion,
        'conteoItemInspeccion': conteoItemInspeccion,
        'descripcionItemInspeccion': descripcionItemInspeccion,
        'estadoMantenimientoItemInspeccion': estadoMantenimientoItemInspeccion,
        'estadoItemInspeccion': estadoItemInspeccion,
      };

  factory ItemInspeccionModel.fromJson(Map<String, dynamic> json) => ItemInspeccionModel(
        idItemInspeccion: json["idItemInspeccion"],
        idCatInspeccion: json["idCatInspeccion"],
        conteoItemInspeccion: json["conteoItemInspeccion"],
        descripcionItemInspeccion: json["descripcionItemInspeccion"],
        estadoMantenimientoItemInspeccion: json["estadoMantenimientoItemInspeccion"],
        estadoItemInspeccion: json["estadoItemInspeccion"],
      );
}
