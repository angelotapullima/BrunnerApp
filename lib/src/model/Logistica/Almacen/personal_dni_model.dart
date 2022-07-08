class PersonalDNIModel {
  String? dni;
  String? name;
  String? surname;
  String? surmane2;
  PersonalDNIModel({
    this.dni,
    this.name,
    this.surname,
    this.surmane2,
  });

  static List<PersonalDNIModel> fromJsonList(List<dynamic> json) => json.map((i) => PersonalDNIModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'dni': dni,
        'name': name,
        'surname': surname,
        'surmane2': surmane2,
      };
  factory PersonalDNIModel.fromJson(Map<String, dynamic> json) => PersonalDNIModel(
        dni: json["dni"],
        name: json["name"],
        surname: json["surname"],
        surmane2: json["surmane2"],
      );
}
