class OrdenEjecucionModel {
  String? idOE;
  String? idCliente;
  String? idEmpresa;
  String? idDepartamento;
  String? idSede;
  String? numeroOE;
  String? descripcionOE;
  String? fechaOE;
  String? cipRTOE;
  String? rtOE;
  String? contactoOE;
  String? telefonoContactoOE;
  String? emailContactoOE;
  String? idUserCreacionOE;
  String? fechaCreacionOE;
  String? estadoOE;
  String? mtOE;
  String? idUserAprobacion;
  String? fechaAprobacionOE;
  String? enviadoFacturacion;
  String? idLugarOE;
  String? condicionOE;
  String? codigoPeriodo;
  String? lugarPeriodo;

  OrdenEjecucionModel({
    this.idOE,
    this.idCliente,
    this.idEmpresa,
    this.idDepartamento,
    this.idSede,
    this.numeroOE,
    this.descripcionOE,
    this.fechaOE,
    this.cipRTOE,
    this.rtOE,
    this.contactoOE,
    this.telefonoContactoOE,
    this.emailContactoOE,
    this.idUserCreacionOE,
    this.fechaCreacionOE,
    this.estadoOE,
    this.mtOE,
    this.idUserAprobacion,
    this.fechaAprobacionOE,
    this.enviadoFacturacion,
    this.idLugarOE,
    this.condicionOE,
    this.codigoPeriodo,
    this.lugarPeriodo,
  });

  static List<OrdenEjecucionModel> fromJsonList(List<dynamic> json) => json.map((i) => OrdenEjecucionModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idOE': idOE,
        'idCliente': idCliente,
        'idEmpresa': idEmpresa,
        'idDepartamento': idDepartamento,
        'idSede': idSede,
        'numeroOE': numeroOE,
        'descripcionOE': descripcionOE,
        'fechaOE': fechaOE,
        'cipRTOE': cipRTOE,
        'rtOE': rtOE,
        'contactoOE': contactoOE,
        'telefonoContactoOE': telefonoContactoOE,
        'emailContactoOE': emailContactoOE,
        'idUserCreacionOE': idUserCreacionOE,
        'fechaCreacionOE': fechaCreacionOE,
        'estadoOE': estadoOE,
        'mtOE': mtOE,
        'idUserAprobacion': idUserAprobacion,
        'fechaAprobacionOE': fechaAprobacionOE,
        'enviadoFacturacion': enviadoFacturacion,
        'idLugarOE': idLugarOE,
        'condicionOE': condicionOE,
        'codigoPeriodo': codigoPeriodo,
        'lugarPeriodo': lugarPeriodo,
      };

  factory OrdenEjecucionModel.fromJson(Map<String, dynamic> json) => OrdenEjecucionModel(
        idOE: json["idOE"],
        idCliente: json["idCliente"],
        idEmpresa: json["idEmpresa"],
        idDepartamento: json["idDepartamento"],
        idSede: json["idSede"],
        numeroOE: json["numeroOE"],
        descripcionOE: json["descripcionOE"],
        fechaOE: json["fechaOE"],
        cipRTOE: json["cipRTOE"],
        rtOE: json["rtOE"],
        contactoOE: json["contactoOE"],
        telefonoContactoOE: json["telefonoContactoOE"],
        emailContactoOE: json["emailContactoOE"],
        idUserCreacionOE: json["idUserCreacionOE"],
        fechaCreacionOE: json["fechaCreacionOE"],
        estadoOE: json["estadoOE"],
        mtOE: json["mtOE"],
        idUserAprobacion: json["idUserAprobacion"],
        fechaAprobacionOE: json["fechaAprobacionOE"],
        enviadoFacturacion: json["enviadoFacturacion"],
        idLugarOE: json["idLugarOE"],
        condicionOE: json["condicionOE"],
        codigoPeriodo: json["codigoPeriodo"],
        lugarPeriodo: json["lugarPeriodo"],
      );
}
