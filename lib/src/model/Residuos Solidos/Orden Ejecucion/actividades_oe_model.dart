class ActividadesOEModel {
  String? idDetallePeriodo;
  String? idPeriodo;
  String? total;
  String? nombreActividad;
  String? descripcionDetallePeriodo;
  String? cantDetallePeriodo;
  String? umDetallePeriodo;

  ActividadesOEModel({
    this.idDetallePeriodo,
    this.idPeriodo,
    this.total,
    this.nombreActividad,
    this.descripcionDetallePeriodo,
    this.cantDetallePeriodo,
    this.umDetallePeriodo,
  });

  static List<ActividadesOEModel> fromJsonList(List<dynamic> json) => json.map((i) => ActividadesOEModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idDetallePeriodo': idDetallePeriodo,
        'idPeriodo': idPeriodo,
        'total': total,
        'nombreActividad': nombreActividad,
        'descripcionDetallePeriodo': descripcionDetallePeriodo,
        'cantDetallePeriodo': cantDetallePeriodo,
        'umDetallePeriodo': umDetallePeriodo,
      };

  factory ActividadesOEModel.fromJson(Map<String, dynamic> json) => ActividadesOEModel(
        idDetallePeriodo: json["idDetallePeriodo"],
        idPeriodo: json["idPeriodo"],
        total: json["total"],
        nombreActividad: json["nombreActividad"],
        descripcionDetallePeriodo: json["descripcionDetallePeriodo"],
        cantDetallePeriodo: json["cantDetallePeriodo"],
        umDetallePeriodo: json["umDetallePeriodo"],
      );
}
