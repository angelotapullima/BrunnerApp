class DepartamentoModel {
  String? idDepartamento;
  String? nombreDepartamento;
  String? estadoDepartamento;

  DepartamentoModel({
    this.idDepartamento,
    this.nombreDepartamento,
    this.estadoDepartamento,
  });

  static List<DepartamentoModel> fromJsonList(List<dynamic> json) => json.map((i) => DepartamentoModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idDepartamento': idDepartamento,
        'nombreDepartamento': nombreDepartamento,
        'estadoDepartamento': estadoDepartamento,
      };

  factory DepartamentoModel.fromJson(Map<String, dynamic> json) => DepartamentoModel(
        idDepartamento: json["idDepartamento"],
        nombreDepartamento: json["nombreDepartamento"],
        estadoDepartamento: json["estadoDepartamento"],
      );
}
