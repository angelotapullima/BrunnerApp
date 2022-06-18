class ActividadesOEModel {
  String? idDetallePeriodo;
  String? idCliente;
  String? total;
  String? nombreActividad;
  String? descripcionDetallePeriodo;
  String? cantDetallePeriodo;
  String? umDetallePeriodo;

  ActividadesOEModel({
    this.idDetallePeriodo,
    this.idCliente,
    this.total,
    this.nombreActividad,
    this.descripcionDetallePeriodo,
    this.cantDetallePeriodo,
    this.umDetallePeriodo,
  });

  static List<ActividadesOEModel> fromJsonList(List<dynamic> json) => json.map((i) => ActividadesOEModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idDetallePeriodo': idDetallePeriodo,
        'idCliente': idCliente,
        'total': total,
        'nombreActividad': nombreActividad,
        'descripcionDetallePeriodo': descripcionDetallePeriodo,
        'cantDetallePeriodo': cantDetallePeriodo,
        'umDetallePeriodo': umDetallePeriodo,
      };

  factory ActividadesOEModel.fromJson(Map<String, dynamic> json) => ActividadesOEModel(
        idDetallePeriodo: json["idDetallePeriodo"],
        idCliente: json["idCliente"],
        total: json["total"],
        nombreActividad: json["nombreActividad"],
        descripcionDetallePeriodo: json["descripcionDetallePeriodo"],
        cantDetallePeriodo: json["cantDetallePeriodo"],
        umDetallePeriodo: json["umDetallePeriodo"],
      );
}
