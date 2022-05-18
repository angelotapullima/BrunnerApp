import 'package:new_brunner_app/src/api/Mantenimiento/mantenimiento_correctivo_api.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/item_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/personas_model.dart';
import 'package:rxdart/rxdart.dart';

class MantenimientoCorrectivoBloc {
  final _api = MantenimientoCorrectivoApi();

  //Filtro categorias
  final _categoriasFiltroController = BehaviorSubject<List<CategoriaInspeccionModel>>();
  Stream<List<CategoriaInspeccionModel>> get categoriasStream => _categoriasFiltroController;

  //Filtro Personas
  final _personasFiltroController = BehaviorSubject<List<PersonasModel>>();
  Stream<List<PersonasModel>> get personasStream => _personasFiltroController.stream;

  //Filtro ItemsCategoria
  final _itemsCatFiltroCOntroller = BehaviorSubject<List<ItemInspeccionModel>>();
  Stream<List<ItemInspeccionModel>> get itemsCatStream => _itemsCatFiltroCOntroller.stream;

  dispose() {
    _categoriasFiltroController.close();
    _personasFiltroController.close();
    _itemsCatFiltroCOntroller.close();
  }

  void getCategorias(String tipoUnidad) async {
    if (tipoUnidad.isNotEmpty) {
      _categoriasFiltroController.sink.add(await _api.catInspeccionDB.getCatInspeccionByTipoUnidad(tipoUnidad));
      await _api.getData(tipoUnidad);
      _categoriasFiltroController.sink.add(await _api.catInspeccionDB.getCatInspeccionByTipoUnidad(tipoUnidad));
    } else {
      await _api.getData(tipoUnidad);
      _categoriasFiltroController.sink.add([]);
    }
  }

  void getPersonasMantenimiento(String query) async {
    if (query.isEmpty) {
      _personasFiltroController.sink.add(await _api.personaDB.getPersonasMantenimiento());
      await _api.getData(query);
      _personasFiltroController.sink.add(await _api.personaDB.getPersonasMantenimiento());
    } else {
      _personasFiltroController.sink.add(await _api.personaDB.getPersonasMantenimientoByQuery(query));
    }
  }

  void getItemsCategoria(String idCategoria) async {
    _itemsCatFiltroCOntroller.sink.add(await _api.itemInspeccionDB.getItemInspeccionByIdCatInsp(idCategoria));
  }
}
