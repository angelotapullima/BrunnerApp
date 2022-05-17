import 'package:new_brunner_app/src/api/Mantenimiento/mantenimiento_api.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_model.dart';
import 'package:rxdart/rxdart.dart';

class MantenimientoCorrectivo {
  final _api = MantenimientoApi();

  final _categoriasFiltroController = BehaviorSubject<List<CategoriaInspeccionModel>>();
  Stream<List<CategoriaInspeccionModel>> get categoriasStream => _categoriasFiltroController;

  dispose() {
    _categoriasFiltroController.close();
  }

  void getCategorias(String tipoUnidad) async {
    if (tipoUnidad.isNotEmpty) {
      _categoriasFiltroController.sink.add(await _api.catInspeccionDB.getCatInspeccionByTipoUnidad(tipoUnidad));
      await _api.getVehiculos();
      _categoriasFiltroController.sink.add(await _api.catInspeccionDB.getCatInspeccionByTipoUnidad(tipoUnidad));
    } else {
      _categoriasFiltroController.sink.add([]);
    }
  }
}
