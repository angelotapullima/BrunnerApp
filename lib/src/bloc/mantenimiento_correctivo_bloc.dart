import 'package:new_brunner_app/src/api/Mantenimiento/mantenimiento_correctivo_api.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/item_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/mantenimiento_correctivo_model.dart';
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

  //Detalle Inspeccion Vehiculo
  final _detalllesController = BehaviorSubject<List<InspeccionVehiculoDetalleModel>>();
  Stream<List<InspeccionVehiculoDetalleModel>> get detallesStream => _detalllesController.stream;

  //Controlador para motrar que se está cargndo la consulta
  final _cargandoController = BehaviorSubject<bool>();
  Stream<bool> get cargandoStream => _cargandoController.stream;

  dispose() {
    _categoriasFiltroController.close();
    _personasFiltroController.close();
    _itemsCatFiltroCOntroller.close();
    _detalllesController.close();
    _cargandoController.close();
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

  void getDetalleInsppeccionFiltro(
    String tipoUnidad,
    String placa,
    String idPersona,
    String idCategoria,
    String idItem,
    String estado,
    String nroCheck,
    String fechaIni,
    String fechaFin,
  ) async {
    _detalllesController.sink.add([]);
    _detalllesController.sink
        .add(await getDetallesInspeccion(tipoUnidad, placa, idPersona, idCategoria, idItem, estado, nroCheck, fechaIni, fechaFin));
    _cargandoController.sink.add(true);
    await _api.getData(tipoUnidad);
    _cargandoController.sink.add(false);
    _detalllesController.sink
        .add(await getDetallesInspeccion(tipoUnidad, placa, idPersona, idCategoria, idItem, estado, nroCheck, fechaIni, fechaFin));
  }

  Future<List<InspeccionVehiculoDetalleModel>> getDetallesInspeccion(
    String tipoUnidad,
    String placa,
    String idPersona,
    String idCategoria,
    String idItem,
    String estado,
    String nroCheck,
    String fechaIni,
    String fechaFin,
  ) async {
    final List<InspeccionVehiculoDetalleModel> result = [];

    String db = '';
    String mc = '';

    if (estado == '1' || estado == '0') {
      db = estado;
    } else if (estado != '') {
      mc = estado;
    }

    final detallesQuery = await _api.detalleInspDB.getDetalleInspeccionFiltro(
      tipoUnidad,
      fechaIni,
      fechaFin,
      placa,
      idCategoria,
      idItem,
      db,
      nroCheck,
    );

    for (var i = 0; i < detallesQuery.length; i++) {
      final detalle = InspeccionVehiculoDetalleModel();

      detalle.idInspeccionDetalle = detallesQuery[i].idInspeccionDetalle;
      detalle.tipoUnidad = detallesQuery[i].tipoUnidad;
      detalle.plavaVehiculo = detallesQuery[i].plavaVehiculo;
      detalle.nroCheckList = detallesQuery[i].nroCheckList;
      detalle.fechaInspeccion = detallesQuery[i].fechaInspeccion;
      detalle.horaInspeccion = detallesQuery[i].horaInspeccion;
      detalle.idCategoria = detallesQuery[i].idCategoria;
      detalle.descripcionCategoria = detallesQuery[i].descripcionCategoria;
      detalle.descripcionCategoria = detallesQuery[i].descripcionCategoria;
      detalle.descripcionCategoria = detallesQuery[i].descripcionCategoria;
      detalle.descripcionCategoria = detallesQuery[i].descripcionCategoria;
      detalle.descripcionCategoria = detallesQuery[i].descripcionCategoria;
      detalle.descripcionCategoria = detallesQuery[i].descripcionCategoria;
      detalle.descripcionCategoria = detallesQuery[i].descripcionCategoria;

      final mantenimientoDB = await _api.mantCorrectivoDB.getMantenimientosFiltro(detalle.idInspeccionDetalle.toString(), idPersona, mc);

      final List<MantenimientoCorrectivoModel> mant = [];
      for (var x = 0; x < mantenimientoDB.length; x++) {
        final mantenimiento = MantenimientoCorrectivoModel();
        mantenimiento.idMantenimiento = mantenimientoDB[x].idMantenimiento;
        mantenimiento.idInspeccionDetalle = mantenimientoDB[x].idInspeccionDetalle;
        mantenimiento.responsable = mantenimientoDB[x].responsable;
        mantenimiento.idResponsable = mantenimientoDB[x].idResponsable;
        mantenimiento.estado = mantenimientoDB[x].estado;
        mantenimiento.diagnostico = mantenimientoDB[x].diagnostico;
        mantenimiento.fechaDiagnostico = mantenimientoDB[x].fechaDiagnostico;
        mantenimiento.conclusion = mantenimientoDB[x].conclusion;
        mantenimiento.dateTimeMantenimiento = mantenimientoDB[x].dateTimeMantenimiento;
        mantenimiento.estadoFinal = mantenimientoDB[x].estadoFinal;
        mantenimiento.fechaFinalMantenimiento = mantenimientoDB[x].fechaFinalMantenimiento;
        mant.add(mantenimiento);
      }

      detalle.mantCorrectivos = mant;

      result.add(detalle);
    }

    return result;
  }
}
