class ContactosOEModel {
  String? idContacto;
  String? idCliente;
  String? contactoCliente;
  String? cargoCliente;
  String? emailCliente;
  String? telefonoCliente;
  String? cipCliente;

  ContactosOEModel({
    this.idContacto,
    this.idCliente,
    this.contactoCliente,
    this.cargoCliente,
    this.emailCliente,
    this.telefonoCliente,
    this.cipCliente,
  });

  static List<ContactosOEModel> fromJsonList(List<dynamic> json) => json.map((i) => ContactosOEModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idContacto': idContacto,
        'idCliente': idCliente,
        'contactoCliente': contactoCliente,
        'cargoCliente': cargoCliente,
        'emailCliente': emailCliente,
        'telefonoCliente': telefonoCliente,
        'cipCliente': cipCliente,
      };

  factory ContactosOEModel.fromJson(Map<String, dynamic> json) => ContactosOEModel(
        idContacto: json["idContacto"],
        idCliente: json["idCliente"],
        contactoCliente: json["contactoCliente"],
        cargoCliente: json["cargoCliente"],
        emailCliente: json["emailCliente"],
        telefonoCliente: json["telefonoCliente"],
        cipCliente: json["cipCliente"],
      );
}
