class PersonasModel {
  String? idPerson;
  String? nombrePerson;
  String? dniPerson;
  String? idCargo;

  PersonasModel({
    this.idPerson,
    this.nombrePerson,
    this.dniPerson,
    this.idCargo,
  });

  static List<PersonasModel> fromJsonList(List<dynamic> json) => json.map((i) => PersonasModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idPerson': idPerson,
        'nombrePerson': nombrePerson,
        'dniPerson': dniPerson,
        'idCargo': idCargo,
      };

  factory PersonasModel.fromJson(Map<String, dynamic> json) => PersonasModel(
        idPerson: json["idPerson"],
        nombrePerson: json["nombrePerson"],
        dniPerson: json["dniPerson"],
        idCargo: json["idCargo"],
      );
}
