import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Orden%20Habilitacion/mantenimientos.dart';
import 'package:provider/provider.dart';

class DetallesOrdenHabilitacion extends StatefulWidget {
  const DetallesOrdenHabilitacion({Key? key, required this.detalle}) : super(key: key);
  final List<InspeccionVehiculoDetalleModel> detalle;

  @override
  State<DetallesOrdenHabilitacion> createState() => _DetallesOrdenHabilitacionState();
}

class _DetallesOrdenHabilitacionState extends State<DetallesOrdenHabilitacion> {
  final _controller = ControllerDetalle();
  @override
  Widget build(BuildContext context) {
    final providerInformes = Provider.of<InformesController>(context, listen: true);
    final ordenHabilitacionBloc = ProviderBloc.ordenHab(context);
    ordenHabilitacionBloc.getInformesPendientesAprobacion(widget.detalle[0].plavaVehiculo.toString());
    ordenHabilitacionBloc.getPendientesAtencion(widget.detalle[0].plavaVehiculo.toString());
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (_, t) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                child: RichText(
                  text: TextSpan(
                    text: 'Tiene ${_controller.totalInforme} observacion(es) corregidas pendientes de habilitar ',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                    children: [
                      TextSpan(
                        text: ', de un total de ${_controller.total}',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
            child: Text(
              'Pendientes de aprobación:',
              style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.w600,
                fontSize: ScreenUtil().setSp(18),
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          StreamBuilder<List<InspeccionVehiculoDetalleModel>>(
            stream: ordenHabilitacionBloc.infoPenStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  _controller.changeInformeTotal(snapshot.data!.length);
                  return InkWell(
                    onTap: () {
                      _seleccionarInformePendienteAprobacion(context, snapshot.data!);
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blueGrey),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Seleccionar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: ScreenUtil().setSp(16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.blueGrey,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              } else {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            },
          ),
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
          ValueListenableBuilder(
            valueListenable: providerInformes.informesS,
            builder: (BuildContext context, List<InspeccionVehiculoDetalleModel> data, Widget? child) {
              print(data.length);
              return Mantenimientos(
                detalles: data,
                action: 'INFORME',
              );
            },
          ),
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
          StreamBuilder<List<InspeccionVehiculoDetalleModel>>(
            stream: ordenHabilitacionBloc.enProcesoStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  _controller.changeTotal(snapshot.data!.length);
                  return ExpansionTile(
                    maintainState: true,
                    title: Text(
                      'En proceso de atención:',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: ScreenUtil().setSp(18),
                      ),
                    ),
                    children: [
                      Mantenimientos(
                        detalles: snapshot.data!,
                        action: 'TODO',
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              } else {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _seleccionarInformePendienteAprobacion(BuildContext context, List<InspeccionVehiculoDetalleModel> lista) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          child: Container(
            color: const Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.2,
                maxChildSize: 0.9,
                builder: (_, controller) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.grey[600],
                        ),
                        Text(
                          'Seleccione',
                          style: TextStyle(
                            color: const Color(0xff5a5a5a),
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(20),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        Mantenimientos(
                          detalles: lista,
                          action: 'VER',
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class ControllerDetalle extends ChangeNotifier {
  int totalInforme = 0;
  int total = 0;

  void changeTotal(int t) async {
    total = 0;
    total += t;
    total += totalInforme;
    await Future.delayed(Duration(microseconds: 100));

    notifyListeners();
  }

  void changeInformeTotal(int t) async {
    totalInforme = 0;
    totalInforme += t;
    await Future.delayed(Duration(seconds: 100));
    notifyListeners();
  }
}
