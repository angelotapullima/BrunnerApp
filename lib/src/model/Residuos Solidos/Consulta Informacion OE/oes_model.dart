class OESModel {
  String? idEjecucion;
  String? descripcionEjecucion;
  String? fechaEjecucion;
  String? idUser;
  String? idPerson;
  String? nameCreated;
  String? surmaneCreated;
  String? dniCreated;
  String? idEmpresa;
  String? nombreEmpresa;
  String? rucEmpresa;
  String? idDepartamento;
  String? nombreDepartamento;
  String? idSede;
  String? nombreSede;

  OESModel({
    this.idEjecucion,
    this.descripcionEjecucion,
    this.fechaEjecucion,
    this.idUser,
    this.idPerson,
    this.nameCreated,
    this.surmaneCreated,
    this.dniCreated,
    this.idEmpresa,
    this.nombreEmpresa,
    this.rucEmpresa,
    this.idDepartamento,
    this.nombreDepartamento,
    this.idSede,
    this.nombreSede,
  });

  static List<OESModel> fromJsonList(List<dynamic> json) => json.map((i) => OESModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idEjecucion': idEjecucion,
        'descripcionEjecucion': descripcionEjecucion,
        'fechaEjecucion': fechaEjecucion,
        'idUser': idUser,
        'idPerson': idPerson,
        'nameCreated': nameCreated,
        'surmaneCreated': surmaneCreated,
        'dniCreated': dniCreated,
        'idEmpresa': idEmpresa,
        'nombreEmpresa': nombreEmpresa,
        'rucEmpresa': rucEmpresa,
        'idDepartamento': idDepartamento,
        'nombreDepartamento': nombreDepartamento,
        'idSede': idSede,
        'nombreSede': nombreSede,
      };

  factory OESModel.fromJson(Map<String, dynamic> json) => OESModel(
        idEjecucion: json["idEjecucion"],
        descripcionEjecucion: json["descripcionEjecucion"],
        fechaEjecucion: json["fechaEjecucion"],
        idUser: json["idUser"],
        idPerson: json["idPerson"],
        nameCreated: json["nameCreated"],
        surmaneCreated: json["surmaneCreated"],
        dniCreated: json["dniCreated"],
        idEmpresa: json["idEmpresa"],
        nombreEmpresa: json["nombreEmpresa"],
        rucEmpresa: json["rucEmpresa"],
        idDepartamento: json["idDepartamento"],
        nombreDepartamento: json["nombreDepartamento"],
        idSede: json["idSede"],
        nombreSede: json["nombreSede"],
      );
}
