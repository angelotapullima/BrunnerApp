class EmpresasModel {
  String? idEmpresa;
  String? nombreEmpresa;
  String? rucEmpresa;
  String? direccionEmpresa;
  String? departamentoEmpresa;
  String? provinciaEmpresa;
  String? distritoEmpresa;
  String? estadoEmpresa;

  EmpresasModel({
    this.idEmpresa,
    this.nombreEmpresa,
    this.rucEmpresa,
    this.direccionEmpresa,
    this.departamentoEmpresa,
    this.provinciaEmpresa,
    this.distritoEmpresa,
    this.estadoEmpresa,
  });

  static List<EmpresasModel> fromJsonList(List<dynamic> json) => json.map((i) => EmpresasModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idEmpresa': idEmpresa,
        'nombreEmpresa': nombreEmpresa,
        'rucEmpresa': rucEmpresa,
        'direccionEmpresa': direccionEmpresa,
        'departamentoEmpresa': departamentoEmpresa,
        'provinciaEmpresa': provinciaEmpresa,
        'distritoEmpresa': distritoEmpresa,
        'estadoEmpresa': estadoEmpresa,
      };

  factory EmpresasModel.fromJson(Map<String, dynamic> json) => EmpresasModel(
        idEmpresa: json["idEmpresa"],
        nombreEmpresa: json["nombreEmpresa"],
        rucEmpresa: json["rucEmpresa"],
        direccionEmpresa: json["direccionEmpresa"],
        departamentoEmpresa: json["departamentoEmpresa"],
        provinciaEmpresa: json["provinciaEmpresa"],
        distritoEmpresa: json["distritoEmpresa"],
        estadoEmpresa: json["estadoEmpresa"],
      );
}
