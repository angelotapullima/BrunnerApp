class DetalleRecursoLogisticaModel {
  String? unidad;
  List<DetallesRLModel>? listDetalles;
  DetalleRecursoLogisticaModel({
    this.unidad,
    this.listDetalles,
  });
}

class DetallesRLModel {
  String? idTipoRecurso;
  String? nombreTipoRecurso;
  DetallesRLModel({
    this.idTipoRecurso,
    this.nombreTipoRecurso,
  });
}
