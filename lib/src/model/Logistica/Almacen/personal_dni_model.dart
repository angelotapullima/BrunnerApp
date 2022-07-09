class PersonalDNIModel {
  String? dni;
  String? name;
  String? surname;
  String? surname2;
  PersonalDNIModel({
    this.dni,
    this.name,
    this.surname,
    this.surname2,
  });

  static List<PersonalDNIModel> fromJsonList(List<dynamic> json) => json.map((i) => PersonalDNIModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'dni': dni,
        'name': name,
        'surname': surname,
        'surname2': surname2,
      };
  factory PersonalDNIModel.fromJson(Map<String, dynamic> json) => PersonalDNIModel(
        dni: json["dni"],
        name: json["name"],
        surname: json["surname"],
        surname2: json["surname2"],
      );
}
