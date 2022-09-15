import 'package:new_brunner_app/src/api/Logistica/cotizacion_api.dart';
import 'package:new_brunner_app/src/model/Logistica/Cotizacion/recurso_cotizacion_model.dart';
import 'package:rxdart/rxdart.dart';

class CotizacionBloc {
  final _api = CotizacionApi();

  final _recursosCotizacionController = BehaviorSubject<List<RecursoCotizacionModel>>();
  Stream<List<RecursoCotizacionModel>> get recursoCotizacionStream => _recursosCotizacionController.stream;

  dispose() {
    _recursosCotizacionController.close();
  }

  void getRecursosCotizacion(String query) async {
    _recursosCotizacionController.sink.add(await _api.getOrdenesPedido(query));
  }
}
