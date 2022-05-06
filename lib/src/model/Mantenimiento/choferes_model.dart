class ChoferesModel {
  String? idChofer;
  String? nombreChofer;
  String? dniChofer;

  ChoferesModel({
    this.idChofer,
    this.nombreChofer,
    this.dniChofer,
  });

  static List<ChoferesModel> fromJsonList(List<dynamic> json) => json.map((i) => ChoferesModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idChofer': idChofer,
        'nombreChofer': nombreChofer,
        'dniChofer': dniChofer,
      };

  factory ChoferesModel.fromJson(Map<String, dynamic> json) => ChoferesModel(
        idChofer: json["idChofer"],
        nombreChofer: json["nombreChofer"],
        dniChofer: json["dniChofer"],
      );
}
