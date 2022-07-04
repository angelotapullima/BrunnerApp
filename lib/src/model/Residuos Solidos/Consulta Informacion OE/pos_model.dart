class POSModel {
  String? idPOS;
  String? fechaServicio;
  String? fechaFin;
  String? idEmpresa;
  String? nombreEmpresa;
  String? rucEmpresa;
  String? direccionEmpresa;
  String? departamentoEmpresa;
  String? provinciaEmpresa;
  String? distritoEmpresa;
  String? idDepartamento;
  String? nombreDepartamento;
  String? idSede;
  String? nombreSede;
  String? idVehiculo;
  String? placaVehiculo;
  String? idUser;
  String? idPerson;
  String? nameCreated;
  String? surmaneCreated;
  String? dniCreated;

  POSModel({
    this.idPOS,
    this.fechaServicio,
    this.fechaFin,
    this.idEmpresa,
    this.nombreEmpresa,
    this.rucEmpresa,
    this.direccionEmpresa,
    this.departamentoEmpresa,
    this.provinciaEmpresa,
    this.distritoEmpresa,
    this.idDepartamento,
    this.nombreDepartamento,
    this.idSede,
    this.nombreSede,
    this.idVehiculo,
    this.placaVehiculo,
    this.idUser,
    this.idPerson,
    this.nameCreated,
    this.surmaneCreated,
    this.dniCreated,
  });

  static List<POSModel> fromJsonList(List<dynamic> json) => json.map((i) => POSModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idPOS': idPOS,
        'fechaServicio': fechaServicio,
        'fechaFin': fechaFin,
        'idEmpresa': idEmpresa,
        'nombreEmpresa': nombreEmpresa,
        'rucEmpresa': rucEmpresa,
        'direccionEmpresa': direccionEmpresa,
        'departamentoEmpresa': departamentoEmpresa,
        'provinciaEmpresa': provinciaEmpresa,
        'distritoEmpresa': distritoEmpresa,
        'idDepartamento': idDepartamento,
        'nombreDepartamento': nombreDepartamento,
        'idSede': idSede,
        'nombreSede': nombreSede,
        'idVehiculo': idVehiculo,
        'placaVehiculo': placaVehiculo,
        'idUser': idUser,
        'idPerson': idPerson,
        'nameCreated': nameCreated,
        'surmaneCreated': surmaneCreated,
        'dniCreated': dniCreated,
      };

  factory POSModel.fromJson(Map<String, dynamic> json) => POSModel(
        idPOS: json["idPOS"],
        fechaServicio: json["fechaServicio"],
        fechaFin: json["fechaFin"],
        idEmpresa: json["idEmpresa"],
        nombreEmpresa: json["nombreEmpresa"],
        rucEmpresa: json["rucEmpresa"],
        direccionEmpresa: json["direccionEmpresa"],
        departamentoEmpresa: json["departamentoEmpresa"],
        provinciaEmpresa: json["provinciaEmpresa"],
        distritoEmpresa: json["distritoEmpresa"],
        idDepartamento: json["idDepartamento"],
        nombreDepartamento: json["nombreDepartamento"],
        idSede: json["idSede"],
        nombreSede: json["nombreSede"],
        idVehiculo: json["idVehiculo"],
        placaVehiculo: json["placaVehiculo"],
        idUser: json["idUser"],
        idPerson: json["idPerson"],
        nameCreated: json["nameCreated"],
        surmaneCreated: json["surmaneCreated"],
        dniCreated: json["dniCreated"],
      );
}
