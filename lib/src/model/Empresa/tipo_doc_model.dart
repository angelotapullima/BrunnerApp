class TipoDocModel {
  String? idTipoDoc;
  String? nombre;
  String? estado;
  String? valueCheck;

  TipoDocModel({
    this.idTipoDoc,
    this.nombre,
    this.estado,
    this.valueCheck,
  });

  static List<TipoDocModel> fromJsonList(List<dynamic> json) => json.map((i) => TipoDocModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idTipoDoc': idTipoDoc,
        'nombre': nombre,
        'estado': estado,
        'valueCheck': valueCheck,
      };

  factory TipoDocModel.fromJson(Map<String, dynamic> json) => TipoDocModel(
        idTipoDoc: json["idTipoDoc"],
        nombre: json["nombre"],
        estado: json["estado"],
        valueCheck: json["valueCheck"],
      );
}
