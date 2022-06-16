class SedeModel {
  String? idSede;
  String? nombreSede;
  String? estadoSede;

  SedeModel({
    this.idSede,
    this.nombreSede,
    this.estadoSede,
  });

  static List<SedeModel> fromJsonList(List<dynamic> json) => json.map((i) => SedeModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idSede': idSede,
        'nombreSede': nombreSede,
        'estadoSede': estadoSede,
      };

  factory SedeModel.fromJson(Map<String, dynamic> json) => SedeModel(
        idSede: json["idSede"],
        nombreSede: json["nombreSede"],
        estadoSede: json["estadoSede"],
      );
}
