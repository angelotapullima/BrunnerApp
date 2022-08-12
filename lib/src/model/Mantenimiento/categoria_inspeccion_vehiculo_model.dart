import 'package:new_brunner_app/src/model/Mantenimiento/check_item_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_item_model.dart';

class CategoriaInspeccionModel {
  String? id;
  String? idCatInspeccion;
  String? idVehiculo;
  String? tipoUnidad;
  String? tipoInspeccion;
  String? descripcionCatInspeccion;
  String? estadoCatInspeccion;
  //No en db
  List<CheckItemInspeccionModel>? checkItemInspeccion;
  List<InspeccionVehiculoItemModel>? checkInspeccionVehiculoItem;

  CategoriaInspeccionModel({
    this.id,
    this.idCatInspeccion,
    this.idVehiculo,
    this.tipoUnidad,
    this.tipoInspeccion,
    this.descripcionCatInspeccion,
    this.estadoCatInspeccion,
    this.checkItemInspeccion,
    this.checkInspeccionVehiculoItem,
  });

  static List<CategoriaInspeccionModel> fromJsonList(List<dynamic> json) => json.map((i) => CategoriaInspeccionModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'idCatInspeccion': idCatInspeccion,
        'idVehiculo': idVehiculo,
        'tipoUnidad': tipoUnidad,
        'tipoInspeccion': tipoInspeccion,
        'descripcionCatInspeccion': descripcionCatInspeccion,
        'estadoCatInspeccion': estadoCatInspeccion,
      };

  factory CategoriaInspeccionModel.fromJson(Map<String, dynamic> json) => CategoriaInspeccionModel(
        id: json["id"],
        idCatInspeccion: json["idCatInspeccion"],
        idVehiculo: json["idVehiculo"],
        tipoUnidad: json["tipoUnidad"],
        tipoInspeccion: json["tipoInspeccion"],
        descripcionCatInspeccion: json["descripcionCatInspeccion"],
        estadoCatInspeccion: json["estadoCatInspeccion"],
      );
}
