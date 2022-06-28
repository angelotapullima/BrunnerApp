class UnidadesOEModel {
  String? idVehiculo;
  String? id;
  String? placaVehiculo;

  UnidadesOEModel({
    this.idVehiculo,
    this.id,
    this.placaVehiculo,
  });

  static List<UnidadesOEModel> fromJsonList(List<dynamic> json) => json.map((i) => UnidadesOEModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idVehiculo': idVehiculo,
        'id': id,
        'placaVehiculo': placaVehiculo,
      };

  factory UnidadesOEModel.fromJson(Map<String, dynamic> json) => UnidadesOEModel(
        idVehiculo: json["idVehiculo"],
        id: json["id"],
        placaVehiculo: json["placaVehiculo"],
      );
}
