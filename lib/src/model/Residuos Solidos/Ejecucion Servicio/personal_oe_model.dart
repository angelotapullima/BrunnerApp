class PersonalOEModel {
  String? idPersona;
  String? id;
  String? nombre;
  String? dni;
  String? fechaPeriodo;
  String? image;
  String? idCargo;
  String? cargo;
  String? detalleCargo;
  String? valueAsistencia;
  String? asistenciaProyectada;

  PersonalOEModel({
    this.idPersona,
    this.id,
    this.nombre,
    this.dni,
    this.fechaPeriodo,
    this.image,
    this.idCargo,
    this.cargo,
    this.detalleCargo,
    this.valueAsistencia,
    this.asistenciaProyectada,
  });

  static List<PersonalOEModel> fromJsonList(List<dynamic> json) => json.map((i) => PersonalOEModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idPersona': idPersona,
        'id': id,
        'nombre': nombre,
        'dni': dni,
        'fechaPeriodo': fechaPeriodo,
        'image': image,
        'idCargo': idCargo,
        'cargo': cargo,
        'detalleCargo': detalleCargo,
        'valueAsistencia': valueAsistencia,
        'asistenciaProyectada': asistenciaProyectada,
      };

  factory PersonalOEModel.fromJson(Map<String, dynamic> json) => PersonalOEModel(
        idPersona: json["idPersona"],
        id: json["id"],
        nombre: json["nombre"],
        dni: json["dni"],
        fechaPeriodo: json["fechaPeriodo"],
        image: json["image"],
        idCargo: json["idCargo"],
        cargo: json["cargo"],
        detalleCargo: json["detalleCargo"],
        valueAsistencia: json["valueAsistencia"],
        asistenciaProyectada: json["asistenciaProyectada"],
      );
}
