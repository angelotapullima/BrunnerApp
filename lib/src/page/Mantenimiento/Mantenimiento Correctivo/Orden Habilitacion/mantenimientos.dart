import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Correctivo/Acciones%20Mantenimiento/agregar_acciones_responsable.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Correctivo/Acciones%20Mantenimiento/editar_detalle_mantenimiento.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Correctivo/Acciones%20Mantenimiento/visualizar_detalles.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Orden%20Habilitacion/widgets.dart';

class Mantenimientos extends StatelessWidget {
  const Mantenimientos({Key? key, required this.detalles, required this.action}) : super(key: key);
  final List<InspeccionVehiculoDetalleModel> detalles;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: detalles.map((item) => _detalle(context, item)).toList(),
    );
  }

  Widget _detalle(BuildContext context, InspeccionVehiculoDetalleModel detalle) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
        vertical: ScreenUtil().setHeight(10),
      ),
      child: Stack(
        children: [
          (action == 'TODO')
              ? PopupMenuButton(
                  onSelected: (value) {
                    switch (value) {
                      case 1:
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return VisualizarDetalles(
                                detalle: detalle,
                              );
                            },
                          ),
                        );
                        break;
                      case 2:
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return AddAccionesResponsable(
                                detalle: detalle,
                              );
                            },
                          ),
                        );
                        break;
                      case 3:
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return EditarDetallesMantenimiento(
                                detalle: detalle,
                              );
                            },
                          ),
                        );
                        break;
                      default:
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(8),
                          ),
                          Text(
                            'Visualizar',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_outlined,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(8),
                          ),
                          Text(
                            'Agregar',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      value: 2,
                    ),
                  ],
                  child: contenidoItem(context, detalle),
                )
              : contenidoItem(context, detalle),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: ScreenUtil().setWidth(110),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(color: Color(0XFF247196), borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: Text(
                  detalle.plavaVehiculo.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
