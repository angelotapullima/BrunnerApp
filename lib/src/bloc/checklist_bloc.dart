import 'package:new_brunner_app/src/api/Mantenimiento/mantenimiento_api.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/check_item_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/choferes_model.dart';
import 'package:rxdart/rxdart.dart';

class CheckListBloc {
  final _api = MantenimientoApi();

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
      _choferesController.sink.add(await _api.choferesDB.getChoferesByQuery(query));
    } else {
      _choferesController.sink.add(await _api.choferesDB.getChoferes());
    }
  }

  void getCatCheckInspeccion(String idVehiculo, String tipoUnidad) async {
    _cartegoriasInspeccionController.sink.add(await checkCategoriasInspeccion(idVehiculo, tipoUnidad));
    await _api.getCheckItemsVehiculo(idVehiculo);
    _cartegoriasInspeccionController.sink.add(await checkCategoriasInspeccion(idVehiculo, tipoUnidad));
  }

  void updateCheckInspeccion(CheckItemInspeccionModel check, String tipoUnidad) async {
    await _api.checkItemInspDB.updateCheck(check);
    // await _api.getCheckItemsVehiculo(check.idVehiculo.toString());
    _cartegoriasInspeccionController.sink.add(await checkCategoriasInspeccion(check.idVehiculo.toString(), tipoUnidad));
  }

  Future<List<CategoriaInspeccionModel>> checkCategoriasInspeccion(String idVehiculo, String tipoUnidad) async {
    final List<CategoriaInspeccionModel> result = [];

    final catsInspDB = await _api.catInspeccionDB.getCatInspeccionByTipoUnidad(tipoUnidad);

    for (var i = 0; i < catsInspDB.length; i++) {
      final categoria = CategoriaInspeccionModel();

      categoria.idCatInspeccion = catsInspDB[i].idCatInspeccion;
      categoria.tipoUnidad = catsInspDB[i].tipoUnidad;
      categoria.descripcionCatInspeccion = catsInspDB[i].descripcionCatInspeccion;
      categoria.estadoCatInspeccion = catsInspDB[i].estadoCatInspeccion;

      //categoria.itemsInspeccion = await _itemInspeccionDB.getItemInspeccionByIdCatInsp(categoria.idCatInspeccion.toString());

      final checkItems = await _api.checkItemInspDB.getCheckItemInspeccionByIdVehiculo(idVehiculo, categoria.idCatInspeccion.toString());

      if (checkItems.isNotEmpty) {
        categoria.checkItemInspeccion = checkItems;
        result.add(categoria);
      }
    }

    return result;
  }
}
