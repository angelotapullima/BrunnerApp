class InspeccionVehiculoModel {
  String? idInspeccionVehiculo;
  String? fechaInspeccionVehiculo;
  String? horaInspeccionVehiculo;
  String? numeroInspeccionVehiculo;
  String? estadoCheckInspeccionVehiculo;
  String? placaVehiculo;
  String? rucVehiculo;
  String? razonSocialVehiculo;
  String? imageVehiculo;
  String? idchofer;
  String? nombreChofer;
  String? nombreUsuario;
  String? tipoUnidad;

  InspeccionVehiculoModel({
    this.idInspeccionVehiculo,
    this.fechaInspeccionVehiculo,
    this.horaInspeccionVehiculo,
    this.numeroInspeccionVehiculo,
    this.estadoCheckInspeccionVehiculo,
    this.placaVehiculo,
    this.rucVehiculo,
    this.razonSocialVehiculo,
    this.imageVehiculo,
    this.idchofer,
    this.nombreChofer,
    this.nombreUsuario,
    this.tipoUnidad,
  });

  static List<InspeccionVehiculoModel> fromJsonList(List<dynamic> json) => json.map((i) => InspeccionVehiculoModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idInspeccionVehiculo': idInspeccionVehiculo,
        'fechaInspeccionVehiculo': fechaInspeccionVehiculo,
        'horaInspeccionVehiculo': horaInspeccionVehiculo,
        'numeroInspeccionVehiculo': numeroInspeccionVehiculo,
        'estadoCheckInspeccionVehiculo': estadoCheckInspeccionVehiculo,
        'placaVehiculo': placaVehiculo,
        'rucVehiculo': rucVehiculo,
        'razonSocialVehiculo': razonSocialVehiculo,
        'imageVehiculo': imageVehiculo,
        'idchofer': idchofer,
        'nombreChofer': nombreChofer,
        'nombreUsuario': nombreUsuario,
        'tipoUnidad': tipoUnidad,
      };

  factory InspeccionVehiculoModel.fromJson(Map<String, dynamic> json) => InspeccionVehiculoModel(
        idInspeccionVehiculo: json["idInspeccionVehiculo"],
        fechaInspeccionVehiculo: json["fechaInspeccionVehiculo"],
        horaInspeccionVehiculo: json["horaInspeccionVehiculo"],
        numeroInspeccionVehiculo: json["numeroInspeccionVehiculo"],
        estadoCheckInspeccionVehiculo: json["estadoCheckInspeccionVehiculo"],
        placaVehiculo: json["placaVehiculo"],
        rucVehiculo: json["rucVehiculo"],
        razonSocialVehiculo: json["razonSocialVehiculo"],
        imageVehiculo: json["imageVehiculo"],
        idchofer: json["idchofer"],
        nombreChofer: json["nombreChofer"],
        nombreUsuario: json["nombreUsuario"],
        tipoUnidad: json["tipoUnidad"],
      );
}
