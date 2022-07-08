class ProveedoresModel {
  String? idProveedor;
  String? nombreProveedor;
  String? rucProveedor;
  String? direccionProveedor;
  String? telefonoProveedor;
  String? contactoProveedor;
  String? emailProveedor;
  String? clase1Proveedor;
  String? clase2Proveedor;
  String? clase3Proveedor;
  String? clase4Proveedor;
  String? clase5Proveedor;
  String? clase6Proveedor;
  String? banco1Proveedor;
  String? banco2Proveedor;
  String? banco3Proveedor;
  String? estadoProveedor;

  ProveedoresModel({
    this.idProveedor,
    this.nombreProveedor,
    this.rucProveedor,
    this.direccionProveedor,
    this.telefonoProveedor,
    this.contactoProveedor,
    this.emailProveedor,
    this.clase1Proveedor,
    this.clase2Proveedor,
    this.clase3Proveedor,
    this.clase4Proveedor,
    this.clase5Proveedor,
    this.clase6Proveedor,
    this.banco1Proveedor,
    this.banco2Proveedor,
    this.banco3Proveedor,
    this.estadoProveedor,
  });

  static List<ProveedoresModel> fromJsonList(List<dynamic> json) => json.map((i) => ProveedoresModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idProveedor': idProveedor,
        'nombreProveedor': nombreProveedor,
        'rucProveedor': rucProveedor,
        'direccionProveedor': direccionProveedor,
        'telefonoProveedor': telefonoProveedor,
        'contactoProveedor': contactoProveedor,
        'emailProveedor': emailProveedor,
        'clase1Proveedor': clase1Proveedor,
        'clase2Proveedor': clase2Proveedor,
        'clase3Proveedor': clase3Proveedor,
        'clase4Proveedor': clase4Proveedor,
        'clase5Proveedor': clase5Proveedor,
        'clase6Proveedor': clase6Proveedor,
        'banco1Proveedor': banco1Proveedor,
        'banco2Proveedor': banco2Proveedor,
        'banco3Proveedor': banco3Proveedor,
        'estadoProveedor': estadoProveedor,
      };

  factory ProveedoresModel.fromJson(Map<String, dynamic> json) => ProveedoresModel(
        idProveedor: json["idProveedor"],
        nombreProveedor: json["nombreProveedor"],
        rucProveedor: json["rucProveedor"],
        direccionProveedor: json["direccionProveedor"],
        telefonoProveedor: json["telefonoProveedor"],
        contactoProveedor: json["contactoProveedor"],
        emailProveedor: json["emailProveedor"],
        clase1Proveedor: json["clase1Proveedor"],
        clase2Proveedor: json["clase2Proveedor"],
        clase3Proveedor: json["clase3Proveedor"],
        clase4Proveedor: json["clase4Proveedor"],
        clase5Proveedor: json["clase5Proveedor"],
        clase6Proveedor: json["clase6Proveedor"],
        banco1Proveedor: json["banco1Proveedor"],
        banco2Proveedor: json["banco2Proveedor"],
        banco3Proveedor: json["banco3Proveedor"],
        estadoProveedor: json["estadoProveedor"],
      );
}
