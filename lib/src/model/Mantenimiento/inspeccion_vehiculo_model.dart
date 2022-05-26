class InspeccionVehiculoModel {
  String? idInspeccionVehiculo;
  String? fechaInspeccionVehiculo;
  String? horaInspeccionVehiculo;
  String? numeroInspeccionVehiculo;
  String? estadoCheckInspeccionVehiculo;
  String? placaVehiculo;
  String? marcaVehiculo;
  String? rucVehiculo;
  String? razonSocialVehiculo;
  String? imageVehiculo;
  String? idchofer;
  String? documentoChofer;
  String? nombreChofer;
  String? nombreUsuario;
  String? hidrolinaVehiculo;
  String? kilometrajeVehiculo;
  String? tipoUnidad;
  String? estadoFinal;
  String? observacionInspeccion;
  String? estado;

  InspeccionVehiculoModel({
    this.idInspeccionVehiculo,
    this.fechaInspeccionVehiculo,
    this.horaInspeccionVehiculo,
    this.numeroInspeccionVehiculo,
    this.estadoCheckInspeccionVehiculo,
    this.placaVehiculo,
    this.marcaVehiculo,
    this.rucVehiculo,
    this.razonSocialVehiculo,
    this.imageVehiculo,
    this.idchofer,
    this.documentoChofer,
    this.nombreChofer,
    this.nombreUsuario,
    this.hidrolinaVehiculo,
    this.kilometrajeVehiculo,
    this.tipoUnidad,
    this.estadoFinal,
    this.observacionInspeccion,
    this.estado,
  });

  static List<InspeccionVehiculoModel> fromJsonList(List<dynamic> json) => json.map((i) => InspeccionVehiculoModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idInspeccionVehiculo': idInspeccionVehiculo,
        'fechaInspeccionVehiculo': fechaInspeccionVehiculo,
        'horaInspeccionVehiculo': horaInspeccionVehiculo,
        'numeroInspeccionVehiculo': numeroInspeccionVehiculo,
        'estadoCheckInspeccionVehiculo': estadoCheckInspeccionVehiculo,
        'placaVehiculo': placaVehiculo,
        'marcaVehiculo': marcaVehiculo,
        'rucVehiculo': rucVehiculo,
        'razonSocialVehiculo': razonSocialVehiculo,
        'imageVehiculo': imageVehiculo,
        'idchofer': idchofer,
        'documentoChofer': documentoChofer,
        'nombreChofer': nombreChofer,
        'nombreUsuario': nombreUsuario,
        'hidrolinaVehiculo': hidrolinaVehiculo,
        'kilometrajeVehiculo': kilometrajeVehiculo,
        'tipoUnidad': tipoUnidad,
        'estadoFinal': estadoFinal,
        'observacionInspeccion': observacionInspeccion,
        'estado': estado,
      };

  factory InspeccionVehiculoModel.fromJson(Map<String, dynamic> json) => InspeccionVehiculoModel(
        idInspeccionVehiculo: json["idInspeccionVehiculo"],
        fechaInspeccionVehiculo: json["fechaInspeccionVehiculo"],
        horaInspeccionVehiculo: json["horaInspeccionVehiculo"],
        numeroInspeccionVehiculo: json["numeroInspeccionVehiculo"],
        estadoCheckInspeccionVehiculo: json["estadoCheckInspeccionVehiculo"],
        placaVehiculo: json["placaVehiculo"],
        marcaVehiculo: json["marcaVehiculo"],
        rucVehiculo: json["rucVehiculo"],
        razonSocialVehiculo: json["razonSocialVehiculo"],
        imageVehiculo: json["imageVehiculo"],
        idchofer: json["idchofer"],
        documentoChofer: json["documentoChofer"],
        nombreChofer: json["nombreChofer"],
        nombreUsuario: json["nombreUsuario"],
        hidrolinaVehiculo: json["hidrolinaVehiculo"],
        kilometrajeVehiculo: json["kilometrajeVehiculo"],
        tipoUnidad: json["tipoUnidad"],
        estadoFinal: json["estadoFinal"],
        observacionInspeccion: json["observacionInspeccion"],
        estado: json["estado"],
      );
}
