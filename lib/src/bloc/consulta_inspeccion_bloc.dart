import 'package:new_brunner_app/src/api/Mantenimiento/inspeccion_api.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/categoria_inspeccion_vehiculo_database.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/vehiculo_database.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_vehiculo_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_item_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_model.dart';
import 'package:rxdart/rxdart.dart';

class ConsultaInspeccionBloc {
  final _api = InspeccionApi();
  final _catInspeccionDB = CategoriaInspeccionDatabase();

  //Listar checkList generados
  final _inpeccionesController = BehaviorSubject<List<InspeccionVehiculoModel>>();
  Stream<List<InspeccionVehiculoModel>> get inspeccionesStream => _inpeccionesController.stream;

  //Detalle CheckList
  final _inspecionDetalleController = BehaviorSubject<List<InspeccionVehiculoModel>>();
  Stream<List<InspeccionVehiculoModel>> get inspeccionDetalleStream => _inspecionDetalleController.stream;

  final _cartegoriasInspeccionController = BehaviorSubject<List<CategoriaInspeccionModel>>();
  Stream<List<CategoriaInspeccionModel>> get catInspeccionStream => _cartegoriasInspeccionController.stream;

  final _observacionesCheckItemController = BehaviorSubject<List<InspeccionVehiculoItemModel>>();
  Stream<List<InspeccionVehiculoItemModel>> get observacionesCkeckStream => _observacionesCheckItemController.stream;

  //Controlador para motrar que se está cargando la consulta
  final _cargandoController = BehaviorSubject<bool>();
  Stream<bool> get cargandoStream => _cargandoController.stream;

  //Controlador para motrar que se está cargando la consulta
  final _cargando2Controller = BehaviorSubject<bool>();
  Stream<bool> get cargando2Stream => _cargando2Controller.stream;

  dispose() {
    _inpeccionesController.close();
    _cargandoController.close();
    _cartegoriasInspeccionController.close();
    _inspecionDetalleController.close();
    _cargando2Controller.close();
  }

  void getInspeccionesVehiculo(String fechaInicial, String fechaFinal, String placaMarca, String operario, String estado, String nroCheck) async {
    _inpeccionesController.sink.add([]);
    _cargandoController.sink.add(true);
    await _api.getInspeccionesVehiculos(fechaInicial, fechaFinal);
    _cargandoController.sink.add(false);
    _inpeccionesController.sink.add(await _api.inspeccionDB.getInspeccionFiltro(fechaInicial, fechaFinal, placaMarca, operario, estado, nroCheck));
  }

  void getInspeccionesVehiculoQuery() async {
    _inpeccionesController.sink.add([]);
    _inpeccionesController.sink.add(await _api.inspeccionDB.getInspeccionQuery());
  }

  void limpiarSearch() {
    _inpeccionesController.sink.add([]);
  }

  void getDetalleInspeccionDetalle(String idInspeccionVehiculo, String placa) async {
    _inspecionDetalleController.sink.add([]);
    _observacionesCheckItemController.sink.add([]);
    final _vdb = VehiculoDatabase();
    final veh = await _vdb.getVehiculoByPlaca(placa);
    _inspecionDetalleController.sink.add(await _api.inspeccionDB.getInspeccionByIdInspeccion(idInspeccionVehiculo));
    _cargando2Controller.sink.add(true);
    await _api.getDetalleInspeccion(idInspeccionVehiculo, veh[0].idVehiculo.toString());
    _cargando2Controller.sink.add(false);
    // Obtener detalle inspeccion
    _inspecionDetalleController.sink.add(await _api.inspeccionDB.getInspeccionByIdInspeccion(idInspeccionVehiculo));
    //Obtener Categorias e Items
    _cartegoriasInspeccionController.sink.add(await checkCategoriasInspeccion(idInspeccionVehiculo, veh[0].idVehiculo.toString()));
    //Obtener las observaciones
    _observacionesCheckItemController.sink.add(await _api.checkItemInspDB.getObservacionesItemInspeccionByIdInspeccion(idInspeccionVehiculo));
  }

  Future<List<CategoriaInspeccionModel>> checkCategoriasInspeccion(String idInspeccionVehiculo, String idVehiculo) async {
    final List<CategoriaInspeccionModel> result = [];

    final catsInspDB = await _catInspeccionDB.getCatInspeccionByIdVehiculo(idVehiculo);

    for (var i = 0; i < catsInspDB.length; i++) {
      final categoria = CategoriaInspeccionModel();

      categoria.idCatInspeccion = catsInspDB[i].idCatInspeccion;
      categoria.idVehiculo = catsInspDB[i].idVehiculo;
      categoria.tipoUnidad = catsInspDB[i].tipoUnidad;
      categoria.descripcionCatInspeccion = catsInspDB[i].descripcionCatInspeccion;
      categoria.estadoCatInspeccion = catsInspDB[i].estadoCatInspeccion;

      final checkItems =
          await _api.checkItemInspDB.getCheckItemInspeccionByIdInspeccionANDIdCat(idInspeccionVehiculo, categoria.idCatInspeccion.toString());
      for (var x = 0; x < checkItems.length; x++) {
        if (checkItems[x].valueCheckItemInsp == '') {
          await _api.checkItemInspDB.updateCheck('0', checkItems[x].idCheckItemInsp.toString());
        }
      }

      if (checkItems.isNotEmpty) {
        categoria.checkInspeccionVehiculoItem = checkItems;
        result.add(categoria);
      }
    }

    return result;
  }
}
