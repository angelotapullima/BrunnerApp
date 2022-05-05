class SubModuloModel {
  String? idSubModulo;
  String? idModulo;
  String? nameSubModulo;
  String? estadoSubModulo;
  String? visibleAppSubModulo;

  SubModuloModel({
    this.idSubModulo,
    this.idModulo,
    this.nameSubModulo,
    this.estadoSubModulo,
    this.visibleAppSubModulo,
  });

  static List<SubModuloModel> fromJsonList(List<dynamic> json) => json.map((i) => SubModuloModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idSubModulo': idSubModulo,
        'idModulo': idModulo,
        'nameSubModulo': nameSubModulo,
        'estadoSubModulo': estadoSubModulo,
        'visibleAppSubModulo': visibleAppSubModulo,
      };

  factory SubModuloModel.fromJson(Map<String, dynamic> json) => SubModuloModel(
        idSubModulo: json["idSubModulo"],
        idModulo: json["idModulo"],
        nameSubModulo: json["nameSubModulo"],
        estadoSubModulo: json["estadoSubModulo"],
        visibleAppSubModulo: json["visibleAppSubModulo"],
      );
}
