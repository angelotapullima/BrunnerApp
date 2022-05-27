import 'package:new_brunner_app/src/api/Mantenimiento/mantenimiento_correctivo_api.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:rxdart/rxdart.dart';

class OrdenHabilitacionCorrectivaBloc {
  final _api = MantenimientoCorrectivoApi();

  //Mantenimiento Correctivo Vehiculo
  final _detalleController = BehaviorSubject<List<InspeccionVehiculoDetalleModel>>();
  Stream<List<InspeccionVehiculoDetalleModel>> get detallesStream => _detalleController.stream;

  //Informe Pendientes de Aprobacion
  final _infPendController = BehaviorSubject<List<InspeccionVehiculoDetalleModel>>();
  Stream<List<InspeccionVehiculoDetalleModel>> get infoPenStream => _infPendController.stream;

  //En proceso de Atencion
  final _enProcesoController = BehaviorSubject<List<InspeccionVehiculoDetalleModel>>();
  Stream<List<InspeccionVehiculoDetalleModel>> get enProcesoStream => _enProcesoController.stream;

  //Controlador para motrar que se está cargndo la consulta
  final _cargandoController = BehaviorSubject<bool>();
  Stream<bool> get cargandoStream => _cargandoController.stream;

  dispose() {
    _detalleController.close();
    _infPendController.close();
    _enProcesoController.close();
  }

  void clear() {
    _detalleController.sink.add([]);
    _infPendController.sink.add([]);
    _enProcesoController.sink.add([]);
  }

  void getInspeccionesById(String placaVehiculo, String tipoUnidad) async {
    _detalleController.sink.add([]);
    _detalleController.sink.add(await _api.detalleInspDB.getDetalleInspeccionByPlacaVehiculo(placaVehiculo));
    _cargandoController.sink.add(true);
    await _api.getData(tipoUnidad);
    _cargandoController.sink.add(false);
    _detalleController.sink.add(await _api.detalleInspDB.getDetalleInspeccionByPlacaVehiculo(placaVehiculo));
  }

  void getInformesPendientesAprobacion(String plavaVehiculo) async {
    _infPendController.sink.add(await getDetalleInspeccionPlacaVehiculo(plavaVehiculo, 1));
  }

  void getPendientesAtencion(String plavaVehiculo) async {
    _enProcesoController.sink.add(await getDetalleInspeccionPlacaVehiculo(plavaVehiculo, 2));
  }

  Future<List<InspeccionVehiculoDetalleModel>> getDetalleInspeccionPlacaVehiculo(String plavaVehiculo, int tipo) async {
    final List<InspeccionVehiculoDetalleModel> result1 = [];
    final List<InspeccionVehiculoDetalleModel> result2 = [];

    final detalleDB = await _api.detalleInspDB.getDetalleInspeccionByPlacaVehiculo(plavaVehiculo);

    for (var i = 0; i < detalleDB.length; i++) {
      final detalle = InspeccionVehiculoDetalleModel();
      detalle.idInspeccionDetalle = detalleDB[i].idInspeccionDetalle;
      detalle.tipoUnidad = detalleDB[i].tipoUnidad;
      detalle.plavaVehiculo = detalleDB[i].plavaVehiculo;
      detalle.nroCheckList = detalleDB[i].nroCheckList;
      detalle.fechaInspeccion = detalleDB[i].fechaInspeccion;
      detalle.horaInspeccion = detalleDB[i].horaInspeccion;
      detalle.idCategoria = detalleDB[i].idCategoria;
      detalle.descripcionCategoria = detalleDB[i].descripcionCategoria;
      detalle.idItemInspeccion = detalleDB[i].idItemInspeccion;
      detalle.descripcionItem = detalleDB[i].descripcionItem;
      detalle.idInspeccionVehiculo = detalleDB[i].idInspeccionVehiculo;
      detalle.estadoInspeccionDetalle = detalleDB[i].estadoInspeccionDetalle;
      detalle.observacionInspeccionDetalle = detalleDB[i].observacionInspeccionDetalle;
      detalle.estadoFinalInspeccionDetalle = detalleDB[i].estadoFinalInspeccionDetalle;
      detalle.observacionFinalInspeccionDetalle = detalleDB[i].observacionFinalInspeccionDetalle;

      if (tipo == 1) {
        final mantenimientoDB =
            await _api.mantCorrectivoDB.getMantenimientosInformePendienteByIdInspeccionDetalle(detalleDB[i].idInspeccionDetalle.toString());
        detalle.mantCorrectivos = mantenimientoDB;
        if (detalle.mantCorrectivos!.isNotEmpty) {
          result1.add(detalle);
        }
      } else if (tipo == 2) {
        final mantenimientoDB =
            await _api.mantCorrectivoDB.getMantenimientosOrdenHabByIdInspeccionDetalle(detalleDB[i].idInspeccionDetalle.toString());
        detalle.mantCorrectivos = mantenimientoDB;
        if (detalle.mantCorrectivos!.isNotEmpty) {
          result2.add(detalle);
        }
      }
    }

    return (tipo == 1) ? result1 : result2;
  }
}
