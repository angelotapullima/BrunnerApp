import 'package:new_brunner_app/src/model/Menu/submodulo_model.dart';

class ModulosModel {
  String? idModulo;
  String? nombreModulo;
  String? ordenModulo;
  String? estadoModulo;
  String? visibleAppModulo;

  //No en db
  List<SubModuloModel>? subModulos;

  ModulosModel({
    this.idModulo,
    this.nombreModulo,
    this.ordenModulo,
    this.estadoModulo,
    this.visibleAppModulo,
    this.subModulos,
  });

  static List<ModulosModel> fromJsonList(List<dynamic> json) => json.map((i) => ModulosModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idModulo': idModulo,
        'nombreModulo': nombreModulo,
        'ordenModulo': ordenModulo,
        'estadoModulo': estadoModulo,
        'visibleAppModulo': visibleAppModulo,
      };

  factory ModulosModel.fromJson(Map<String, dynamic> json) => ModulosModel(
        idModulo: json["idModulo"],
        nombreModulo: json["nombreModulo"],
        ordenModulo: json["ordenModulo"],
        estadoModulo: json["estadoModulo"],
        visibleAppModulo: json["visibleAppModulo"],
      );
}
