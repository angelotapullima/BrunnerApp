class VehiculoModel {
  String? idVehiculo;
  String? tipoUnidad;
  String? carroceriaVehiculo;
  String? placaVehiculo;
  String? rucVehiculo;
  String? razonSocialVehiculo;
  String? partidaVehiculo;
  String? oficinaVehiculo;
  String? marcaVehiculo;
  String? modeloVehiculo;
  String? yearVehiculo;
  String? serieVehiculo;
  String? motorVehiculo;
  String? combustibleVehiculo;
  String? potenciaMotorVehiculo;
  String? estadoInspeccionVehiculo;
  String? imagenVehiculo;
  String? estadoVehiculo;
  String? color1;
  String? color2;
  String? cargaUtil;

  VehiculoModel({
    this.idVehiculo,
    this.tipoUnidad,
    this.carroceriaVehiculo,
    this.placaVehiculo,
    this.rucVehiculo,
    this.razonSocialVehiculo,
    this.partidaVehiculo,
    this.oficinaVehiculo,
    this.marcaVehiculo,
    this.modeloVehiculo,
    this.yearVehiculo,
    this.serieVehiculo,
    this.motorVehiculo,
    this.combustibleVehiculo,
    this.potenciaMotorVehiculo,
    this.estadoInspeccionVehiculo,
    this.imagenVehiculo,
    this.estadoVehiculo,
    this.color1,
    this.color2,
    this.cargaUtil,
  });

  static List<VehiculoModel> fromJsonList(List<dynamic> json) => json.map((i) => VehiculoModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idVehiculo': idVehiculo,
        'tipoUnidad': tipoUnidad,
        'carroceriaVehiculo': carroceriaVehiculo,
        'placaVehiculo': placaVehiculo,
        'rucVehiculo': rucVehiculo,
        'razonSocialVehiculo': razonSocialVehiculo,
        'partidaVehiculo': partidaVehiculo,
        'oficinaVehiculo': oficinaVehiculo,
        'marcaVehiculo': marcaVehiculo,
        'modeloVehiculo': modeloVehiculo,
        'yearVehiculo': yearVehiculo,
        'serieVehiculo': serieVehiculo,
        'motorVehiculo': motorVehiculo,
        'combustibleVehiculo': combustibleVehiculo,
        'potenciaMotorVehiculo': potenciaMotorVehiculo,
        'estadoInspeccionVehiculo': estadoInspeccionVehiculo,
        'imagenVehiculo': imagenVehiculo,
        'estadoVehiculo': estadoVehiculo,
        'color1': color1,
        'color2': color2,
        'cargaUtil': cargaUtil,
      };

  factory VehiculoModel.fromJson(Map<String, dynamic> json) => VehiculoModel(
        idVehiculo: json["idVehiculo"],
        tipoUnidad: json["tipoUnidad"],
        carroceriaVehiculo: json["carroceriaVehiculo"],
        placaVehiculo: json["placaVehiculo"],
        rucVehiculo: json["rucVehiculo"],
        razonSocialVehiculo: json["razonSocialVehiculo"],
        partidaVehiculo: json["partidaVehiculo"],
        oficinaVehiculo: json["oficinaVehiculo"],
        marcaVehiculo: json["marcaVehiculo"],
        modeloVehiculo: json["modeloVehiculo"],
        yearVehiculo: json["yearVehiculo"],
        serieVehiculo: json["serieVehiculo"],
        motorVehiculo: json["motorVehiculo"],
        combustibleVehiculo: json["combustibleVehiculo"],
        potenciaMotorVehiculo: json["potenciaMotorVehiculo"],
        estadoInspeccionVehiculo: json["estadoInspeccionVehiculo"],
        imagenVehiculo: json["imagenVehiculo"],
        estadoVehiculo: json["estadoVehiculo"],
        color1: json["color1"],
        color2: json["color2"],
        cargaUtil: json["cargaUtil"],
      );
}
