import 'package:new_brunner_app/src/model/Mantenimiento/item_inspeccion_model.dart';

class CategoriaInspeccionModel {
  String? idCatInspeccion;
  String? tipoUnidad;
  String? descripcionCatInspeccion;
  String? estadoCatInspeccion;
  //No en db
  List<ItemInspeccionModel>? itemsInspeccion;

  CategoriaInspeccionModel({
    this.idCatInspeccion,
    this.tipoUnidad,
    this.descripcionCatInspeccion,
    this.estadoCatInspeccion,
    this.itemsInspeccion,
  });

  static List<CategoriaInspeccionModel> fromJsonList(List<dynamic> json) => json.map((i) => CategoriaInspeccionModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idCatInspeccion': idCatInspeccion,
        'tipoUnidad': tipoUnidad,
        'descripcionCatInspeccion': descripcionCatInspeccion,
        'estadoCatInspeccion': estadoCatInspeccion,
      };

  factory CategoriaInspeccionModel.fromJson(Map<String, dynamic> json) => CategoriaInspeccionModel(
        idCatInspeccion: json["idCatInspeccion"],
        tipoUnidad: json["tipoUnidad"],
        descripcionCatInspeccion: json["descripcionCatInspeccion"],
        estadoCatInspeccion: json["estadoCatInspeccion"],
      );
}
