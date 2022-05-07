import 'package:new_brunner_app/src/database/Mantenimiento/categorias_inspeccion_database.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/choferes_database.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/item_inspeccion_database.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/choferes_model.dart';
import 'package:rxdart/rxdart.dart';

class CheckListBloc {
  final _choferesDB = ChoferesDatabase();
  final _catInspeccionDB = CategoriaInspeccionDatabase();
  final _itemInspeccionDB = ItemInspeccionDatabase();

  final _choferesController = BehaviorSubject<List<ChoferesModel>>();
  Stream<List<ChoferesModel>> get choferesStream => _choferesController.stream;

  final _cartegoriasInspeccionController = BehaviorSubject<List<CategoriaInspeccionModel>>();
  Stream<List<CategoriaInspeccionModel>> get catInspeccionStream => _cartegoriasInspeccionController.stream;

  dispose() {
    _choferesController.close();
    _cartegoriasInspeccionController.close();
  }

  void searchVehiculos(String query) async {
    _choferesController.sink.add([]);
    if (query.isNotEmpty) {
      _choferesController.sink.add(await _choferesDB.getChoferesByQuery(query));
    } else {
      _choferesController.sink.add(await _choferesDB.getChoferes());
    }
  }

  void getCatInspeccion(String tipoUnidad) async {
    //_cartegoriasInspeccionController.sink.add([]);
    _cartegoriasInspeccionController.sink.add(await categoriasInspeccion(tipoUnidad));
  }

  Future<List<CategoriaInspeccionModel>> categoriasInspeccion(String tipoUnidad) async {
    final List<CategoriaInspeccionModel> result = [];

    final catsInspDB = await _catInspeccionDB.getCatInspeccionByTipoUnidad(tipoUnidad);

    for (var i = 0; i < catsInspDB.length; i++) {
      final categoria = CategoriaInspeccionModel();

      categoria.idCatInspeccion = catsInspDB[i].idCatInspeccion;
      categoria.tipoUnidad = catsInspDB[i].tipoUnidad;
      categoria.descripcionCatInspeccion = catsInspDB[i].descripcionCatInspeccion;
      categoria.estadoCatInspeccion = catsInspDB[i].estadoCatInspeccion;

      categoria.itemsInspeccion = await _itemInspeccionDB.getItemInspeccionByIdCatInsp(categoria.idCatInspeccion.toString());

      result.add(categoria);
    }

    return result;
  }
}
