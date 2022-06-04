import 'package:new_brunner_app/src/api/Mantenimiento/mantenimiento_api.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/check_item_inspeccion_model.dart';
import 'package:rxdart/rxdart.dart';

class CheckListBloc {
  final _api = MantenimientoApi();

  final _cartegoriasInspeccionController = BehaviorSubject<List<CategoriaInspeccionModel>>();
  Stream<List<CategoriaInspeccionModel>> get catInspeccionStream => _cartegoriasInspeccionController.stream;

  final _observacionesCheckItemController = BehaviorSubject<List<CheckItemInspeccionModel>>();
  Stream<List<CheckItemInspeccionModel>> get observacionesCkeckStream => _observacionesCheckItemController.stream;

  dispose() {
    _cartegoriasInspeccionController.close();
    _observacionesCheckItemController.close();
  }

  void getCatCheckInspeccion(String idVehiculo, String tipoUnidad) async {
    //Obtener Categorias e items
    _cartegoriasInspeccionController.sink.add(await checkCategoriasInspeccion(idVehiculo, tipoUnidad));
    //Obtener las observaciones
    _observacionesCheckItemController.sink.add(await _api.checkItemInspDB.getObservacionesItemInspeccionByIdVehiculo(idVehiculo));
    //LLamar al api
    await _api.getCheckItemsVehiculo(idVehiculo);
    _cartegoriasInspeccionController.sink.add(await checkCategoriasInspeccion(idVehiculo, tipoUnidad));
    _observacionesCheckItemController.sink.add(await _api.checkItemInspDB.getObservacionesItemInspeccionByIdVehiculo(idVehiculo));
  }

  void updateCheckInspeccion(CheckItemInspeccionModel check, String tipoUnidad) async {
    await _api.checkItemInspDB.updateCheckInspeccion(check);
    _cartegoriasInspeccionController.sink.add(await checkCategoriasInspeccion(check.idVehiculo.toString(), tipoUnidad));
    _observacionesCheckItemController.sink.add(await _api.checkItemInspDB.getObservacionesItemInspeccionByIdVehiculo(check.idVehiculo.toString()));
  }

  void updateObservaciones(CheckItemInspeccionModel check) async {
    await _api.checkItemInspDB.updateCheckInspeccion(check);
    _observacionesCheckItemController.sink.add(await _api.checkItemInspDB.getObservacionesItemInspeccionByIdVehiculo(check.idVehiculo.toString()));
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

      final checkItems = await _api.checkItemInspDB.getCheckItemInspeccionByIdVehiculoANDIdCat(idVehiculo, categoria.idCatInspeccion.toString());
      for (var x = 0; x < checkItems.length; x++) {
        if (checkItems[x].valueCheckItemInsp == '') {
          await _api.checkItemInspDB.updateCheck('0', checkItems[x].idCheckItemInsp.toString());
        }
      }

      if (checkItems.isNotEmpty) {
        categoria.checkItemInspeccion = checkItems;
        result.add(categoria);
      }
    }

    return result;
  }
}
