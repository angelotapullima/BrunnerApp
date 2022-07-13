class NotasPendientesModel {
  String? idAlmacenLog;
  String? idSede;
  String? codigoAlmacenLog;
  String? tipoAlmacenLog;
  String? comentarioAlmacenLog;
  String? dniSoliAlmacenLog;
  String? nombreSoliAlmacenLog;
  String? fechaAlmacenLog;
  String? horaAlmacenLog;
  String? aprobacionAlmacenLog;
  String? idUserAprobacion;
  String? estadoAlmacenLog;
  String? entregaAlmacenLog;
  String? horaEntregaAlmacenLog;
  String? personaEntregaAlmacenLog;
  String? idOPAlmacenLog;
  String? idSIAlmacenLog;
  String? destinoAlmacenLog;
  String? nombreSede;

  NotasPendientesModel({
    this.idAlmacenLog,
    this.idSede,
    this.codigoAlmacenLog,
    this.tipoAlmacenLog,
    this.comentarioAlmacenLog,
    this.dniSoliAlmacenLog,
    this.nombreSoliAlmacenLog,
    this.fechaAlmacenLog,
    this.horaAlmacenLog,
    this.aprobacionAlmacenLog,
    this.idUserAprobacion,
    this.estadoAlmacenLog,
    this.entregaAlmacenLog,
    this.horaEntregaAlmacenLog,
    this.personaEntregaAlmacenLog,
    this.idOPAlmacenLog,
    this.idSIAlmacenLog,
    this.destinoAlmacenLog,
    this.nombreSede,
  });

  static List<NotasPendientesModel> fromJsonList(List<dynamic> json) => json.map((i) => NotasPendientesModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idAlmacenLog': idAlmacenLog,
        'idSede': idSede,
        'codigoAlmacenLog': codigoAlmacenLog,
        'tipoAlmacenLog': tipoAlmacenLog,
        'comentarioAlmacenLog': comentarioAlmacenLog,
        'dniSoliAlmacenLog': dniSoliAlmacenLog,
        'nombreSoliAlmacenLog': nombreSoliAlmacenLog,
        'fechaAlmacenLog': fechaAlmacenLog,
        'horaAlmacenLog': horaAlmacenLog,
        'aprobacionAlmacenLog': aprobacionAlmacenLog,
        'idUserAprobacion': idUserAprobacion,
        'estadoAlmacenLog': estadoAlmacenLog,
        'entregaAlmacenLog': entregaAlmacenLog,
        'horaEntregaAlmacenLog': horaEntregaAlmacenLog,
        'personaEntregaAlmacenLog': personaEntregaAlmacenLog,
        'idOPAlmacenLog': idOPAlmacenLog,
        'idSIAlmacenLog': idSIAlmacenLog,
        'destinoAlmacenLog': destinoAlmacenLog,
        'nombreSede': nombreSede,
      };
  factory NotasPendientesModel.fromJson(Map<String, dynamic> json) => NotasPendientesModel(
        idAlmacenLog: json["idAlmacenLog"],
        idSede: json["idSede"],
        codigoAlmacenLog: json["codigoAlmacenLog"],
        tipoAlmacenLog: json["tipoAlmacenLog"],
        comentarioAlmacenLog: json["comentarioAlmacenLog"],
        dniSoliAlmacenLog: json["dniSoliAlmacenLog"],
        nombreSoliAlmacenLog: json["nombreSoliAlmacenLog"],
        fechaAlmacenLog: json["fechaAlmacenLog"],
        horaAlmacenLog: json["horaAlmacenLog"],
        aprobacionAlmacenLog: json["aprobacionAlmacenLog"],
        idUserAprobacion: json["idUserAprobacion"],
        estadoAlmacenLog: json["estadoAlmacenLog"],
        entregaAlmacenLog: json["entregaAlmacenLog"],
        horaEntregaAlmacenLog: json["horaEntregaAlmacenLog"],
        personaEntregaAlmacenLog: json["personaEntregaAlmacenLog"],
        idOPAlmacenLog: json["idOPAlmacenLog"],
        idSIAlmacenLog: json["idSIAlmacenLog"],
        destinoAlmacenLog: json["destinoAlmacenLog"],
        nombreSede: json["nombreSede"],
      );
}
