import 'package:new_brunner_app/src/api/Mantenimiento/mantenimiento_correctivo_api.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_vehiculo_model.dart';
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

  //Detalle Inspecciones Vehiculos
  final _detalleController = BehaviorSubject<List<InspeccionVehiculoDetalleModel>>();
  Stream<List<InspeccionVehiculoDetalleModel>> get detallesStream => _detalleController.stream;

  //Detalle Inspeccion Vehiculo
  final _detalleManttCorrectivoController = BehaviorSubject<List<InspeccionVehiculoDetalleModel>>();
  Stream<List<InspeccionVehiculoDetalleModel>> get detalleManttCorrectivoStream => _detalleManttCorrectivoController.stream;

  //Controlador para motrar que se está cargndo la consulta
  final _cargandoController = BehaviorSubject<bool>();
  Stream<bool> get cargandoStream => _cargandoController.stream;

  dispose() {
    _categoriasFiltroController.close();
    _personasFiltroController.close();
    _itemsCatFiltroCOntroller.close();
    _detalleController.close();
    _cargandoController.close();
    _detalleManttCorrectivoController.close();
  }

  void clearData() {
    _detalleController.sink.add([]);
  }

  void getCategorias(String tipoUnidad) async {
    if (tipoUnidad.isNotEmpty) {
      _categoriasFiltroController.sink.add(await _api.catInspeccionDB.getCatInspeccionByTipoInspeccion(tipoUnidad));
      await _api.getData(tipoUnidad);
      _categoriasFiltroController.sink.add(await _api.catInspeccionDB.getCatInspeccionByTipoInspeccion(tipoUnidad));
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
    _detalleController.sink.add([]);
    _detalleController.sink.add(await getDetallesInspeccion(tipoUnidad, placa, idPersona, idCategoria, idItem, estado, nroCheck, fechaIni, fechaFin));
    _cargandoController.sink.add(true);
    await _api.getData(tipoUnidad);
    _cargandoController.sink.add(false);
    _detalleController.sink.add(await getDetallesInspeccion(tipoUnidad, placa, idPersona, idCategoria, idItem, estado, nroCheck, fechaIni, fechaFin));
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

    //Asignado el esta para inspeccion detalle
    switch (estado) {
      case '0':
        db = '1';
        break;
      case '3':
        db = '0';
        break;
      default:
        db = '';
        mc = estado;
        break;
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
      detalle.idItemInspeccion = detallesQuery[i].idItemInspeccion;
      detalle.descripcionItem = detallesQuery[i].descripcionItem;
      detalle.idInspeccionVehiculo = detallesQuery[i].idInspeccionVehiculo;
      detalle.estadoInspeccionDetalle = detallesQuery[i].estadoInspeccionDetalle;
      detalle.observacionInspeccionDetalle = detallesQuery[i].observacionInspeccionDetalle;
      detalle.estadoFinalInspeccionDetalle = detallesQuery[i].estadoFinalInspeccionDetalle;
      detalle.observacionFinalInspeccionDetalle = detallesQuery[i].observacionFinalInspeccionDetalle;

      final mantenimientoDB = await _api.mantCorrectivoDB.getMantenimientosFiltro(detallesQuery[i].idInspeccionDetalle.toString(), idPersona, mc);

      if (mantenimientoDB.isEmpty && estado == '0') {
        detalle.mantCorrectivos = [];
        result.add(detalle);
      } else if (estado != '0') {
        final List<MantenimientoCorrectivoModel> mantConEstados = [];
        final List<MantenimientoCorrectivoModel> mantSinEstados = [];
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
          mantenimiento.recomendacion = mantenimientoDB[x].recomendacion;
          mantenimiento.dateTimeMantenimiento = mantenimientoDB[x].dateTimeMantenimiento;
          mantenimiento.estadoFinal = mantenimientoDB[x].estadoFinal;
          mantenimiento.fechaFinalMantenimiento = mantenimientoDB[x].fechaFinalMantenimiento;
          if (mc != '') {
            mantConEstados.add(mantenimiento);
          } else {
            mantSinEstados.add(mantenimiento);
          }
        }

        if (estado == '') {
          detalle.mantCorrectivos = mantSinEstados;
          result.add(detalle);
        } else {
          if (mantConEstados.isNotEmpty) {
            detalle.mantCorrectivos = mantConEstados;
            result.add(detalle);
          }
          if (mantSinEstados.isNotEmpty) {
            detalle.mantCorrectivos = mantSinEstados;
            result.add(detalle);
          }

          if (db != '') {
            detalle.mantCorrectivos = mantSinEstados;
            result.add(detalle);
          }
        }
      }
    }

    return result;
  }

  void getInspeccionesById(String idInspeccionDetalle, String tipoUnidad) async {
    _detalleController.sink.add([]);
    _detalleController.sink.add(await getDetalleInspeccionId(idInspeccionDetalle));
    _cargandoController.sink.add(true);
    await _api.getData(tipoUnidad);
    _cargandoController.sink.add(false);
    _detalleController.sink.add(await getDetalleInspeccionId(idInspeccionDetalle));
  }

  void getDetalleInspeccionManttCorrectivoById(String idInspeccionDetalle, String tipoUnidad) async {
    _detalleManttCorrectivoController.sink.add([]);
    _detalleManttCorrectivoController.sink.add(await getDetalleInspeccionId(idInspeccionDetalle));
    await _api.getData(tipoUnidad);
    _detalleManttCorrectivoController.sink.add(await getDetalleInspeccionId(idInspeccionDetalle));
  }

  Future<List<InspeccionVehiculoDetalleModel>> getDetalleInspeccionId(String idInspeccionDetalle) async {
    final List<InspeccionVehiculoDetalleModel> result = [];

    final detalleDB = await _api.detalleInspDB.getDetalleInspeccionById(idInspeccionDetalle);

    if (detalleDB.isNotEmpty) {
      final detalle = InspeccionVehiculoDetalleModel();
      detalle.idInspeccionDetalle = detalleDB[0].idInspeccionDetalle;
      detalle.tipoUnidad = detalleDB[0].tipoUnidad;
      detalle.plavaVehiculo = detalleDB[0].plavaVehiculo;
      detalle.nroCheckList = detalleDB[0].nroCheckList;
      detalle.fechaInspeccion = detalleDB[0].fechaInspeccion;
      detalle.horaInspeccion = detalleDB[0].horaInspeccion;
      detalle.idCategoria = detalleDB[0].idCategoria;
      detalle.descripcionCategoria = detalleDB[0].descripcionCategoria;
      detalle.idItemInspeccion = detalleDB[0].idItemInspeccion;
      detalle.descripcionItem = detalleDB[0].descripcionItem;
      detalle.idInspeccionVehiculo = detalleDB[0].idInspeccionVehiculo;
      detalle.estadoInspeccionDetalle = detalleDB[0].estadoInspeccionDetalle;
      detalle.observacionInspeccionDetalle = detalleDB[0].observacionInspeccionDetalle;
      detalle.estadoFinalInspeccionDetalle = detalleDB[0].estadoFinalInspeccionDetalle;
      detalle.observacionFinalInspeccionDetalle = detalleDB[0].observacionFinalInspeccionDetalle;

      final mantenimientoDB = await _api.mantCorrectivoDB.getMantenimientoByIdInspeccionDetalle(detalleDB[0].idInspeccionDetalle.toString());

      detalle.mantCorrectivos = mantenimientoDB;
      result.add(detalle);
    }

    return result;
  }

  void getDetalleResponsableInspeccionManttCorrectivoById(String idInspeccionDetalle, String tipoUnidad) async {
    _detalleManttCorrectivoController.sink.add([]);
    _detalleManttCorrectivoController.sink.add(await getDetalleInspeccionMantenimientoActivoById(idInspeccionDetalle));
    await _api.getData(tipoUnidad);
    _detalleManttCorrectivoController.sink.add(await getDetalleInspeccionMantenimientoActivoById(idInspeccionDetalle));
  }

  Future<List<InspeccionVehiculoDetalleModel>> getDetalleInspeccionMantenimientoActivoById(String idInspeccionDetalle) async {
    final List<InspeccionVehiculoDetalleModel> result = [];

    final detalleDB = await _api.detalleInspDB.getDetalleInspeccionById(idInspeccionDetalle);

    if (detalleDB.isNotEmpty) {
      final detalle = InspeccionVehiculoDetalleModel();
      detalle.idInspeccionDetalle = detalleDB[0].idInspeccionDetalle;
      detalle.tipoUnidad = detalleDB[0].tipoUnidad;
      detalle.plavaVehiculo = detalleDB[0].plavaVehiculo;
      detalle.nroCheckList = detalleDB[0].nroCheckList;
      detalle.fechaInspeccion = detalleDB[0].fechaInspeccion;
      detalle.horaInspeccion = detalleDB[0].horaInspeccion;
      detalle.idCategoria = detalleDB[0].idCategoria;
      detalle.descripcionCategoria = detalleDB[0].descripcionCategoria;
      detalle.idItemInspeccion = detalleDB[0].idItemInspeccion;
      detalle.descripcionItem = detalleDB[0].descripcionItem;
      detalle.idInspeccionVehiculo = detalleDB[0].idInspeccionVehiculo;
      detalle.estadoInspeccionDetalle = detalleDB[0].estadoInspeccionDetalle;
      detalle.observacionInspeccionDetalle = detalleDB[0].observacionInspeccionDetalle;
      detalle.estadoFinalInspeccionDetalle = detalleDB[0].estadoFinalInspeccionDetalle;
      detalle.observacionFinalInspeccionDetalle = detalleDB[0].observacionFinalInspeccionDetalle;
      final List<MantenimientoCorrectivoModel> mantenimiento = [];
      final mantenimientoDB = await _api.mantCorrectivoDB.getMantenimientoByIdInspeccionDetalle(detalleDB[0].idInspeccionDetalle.toString());
      for (var i = 0; i < mantenimientoDB.length; i++) {
        if (mantenimientoDB[i].estadoFinal == '1') {
          mantenimiento.add(mantenimientoDB[i]);
        }
      }
      detalle.mantCorrectivos = mantenimiento;
      result.add(detalle);
    }

    return result;
  }
}
