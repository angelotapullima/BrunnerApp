import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/Consulta%20Informacion/inspeccion_detalle.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Correctivo/Acciones%20Mantenimiento/agregar_acciones_responsable.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Correctivo/Acciones%20Mantenimiento/editar_detalle_mantenimiento.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Correctivo/Acciones%20Mantenimiento/visualizar_detalles.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:provider/provider.dart';

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
              : (action == 'INFORME')
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
                          case 6:
                            final providerInformes = Provider.of<InformesController>(context, listen: false);
                            providerInformes.removeInforme(detalle.idInspeccionDetalle.toString());
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
                                Icons.cancel,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(8),
                              ),
                              Text(
                                'Eliminar',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ],
                          ),
                          value: 6,
                        ),
                      ],
                      child: contenidoItem(context, detalle),
                    )
                  : InkWell(
                      onTap: () {
                        final providerInformes = Provider.of<InformesController>(context, listen: false);
                        providerInformes.saveInforme(detalle);
                        Navigator.pop(context);
                      },
                      child: contenidoItem(context, detalle),
                    ),
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

  Widget contenidoItem(BuildContext context, InspeccionVehiculoDetalleModel detalle) {
    Color color = Colors.redAccent;
    String textEstado = 'Sin Atender';
    String responsable = '';
    if (detalle.estadoFinalInspeccionDetalle == '0') {
      textEstado = 'Anulado';
    }
    if (detalle.mantCorrectivos!.isNotEmpty) {
      for (var i = 0; i < detalle.mantCorrectivos!.length; i++) {
        if (detalle.mantCorrectivos![i].estadoFinal == '1') {
          responsable = detalle.mantCorrectivos![i].responsable ?? '';
          switch (detalle.mantCorrectivos![i].estado) {
            case '1':
              color = Colors.blue;
              textEstado = 'Informe Pendiente de Aprobación';
              break;
            case '2':
              color = Colors.orangeAccent;
              textEstado = 'En Proceso de Aprobación';
              break;
            case '4':
              color = Colors.green;
              textEstado = 'Atendido';
              break;
            case '5':
              color = Colors.deepPurpleAccent;
              textEstado = 'Diagnosticado';
              break;
            default:
              color = Colors.redAccent;
          }
        }
      }
    }
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (detalle.estadoFinalInspeccionDetalle == '0') ? Colors.redAccent.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.transparent.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: ScreenUtil().setWidth(90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PopupMenuButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.error,
                    color: color,
                    size: ScreenUtil().setHeight(30),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text(
                        textEstado,
                        style: TextStyle(color: color),
                      ),
                      value: 1,
                    )
                  ],
                ),
                (action == 'TODO')
                    ? PopupMenuButton(
                        padding: EdgeInsets.all(0),
                        onSelected: (value) {
                          if (value == 1) {
                            final dato = InspeccionVehiculoModel();
                            dato.idInspeccionVehiculo = detalle.idInspeccionVehiculo;
                            dato.tipoUnidad = detalle.tipoUnidad;
                            dato.estadoFinal = '2';
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  return InspeccionDetalle(
                                    inspeccion: dato,
                                  );
                                },
                              ),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            Text(
                              'Nro CheckList',
                              style: TextStyle(
                                color: (detalle.estadoFinalInspeccionDetalle == '0') ? Colors.black : Colors.grey,
                                fontSize: ScreenUtil().setSp(8),
                              ),
                            ),
                            Text(
                              detalle.nroCheckList.toString(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.remove_red_eye,
                                  color: color,
                                ),
                                SizedBox(width: ScreenUtil().setWidth(10)),
                                Text(
                                  'Visualizar Check List',
                                  style: TextStyle(color: color),
                                ),
                              ],
                            ),
                            value: 1,
                          )
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                            'Nro CheckList',
                            style: TextStyle(
                              color: (detalle.estadoFinalInspeccionDetalle == '0') ? Colors.black : Colors.grey,
                              fontSize: ScreenUtil().setSp(8),
                            ),
                          ),
                          Text(
                            detalle.nroCheckList.toString(),
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${obtenerFecha(detalle.fechaInspeccion.toString())} ${detalle.horaInspeccion}',
                    style: TextStyle(
                      color: (detalle.estadoFinalInspeccionDetalle == '0') ? Colors.black : Colors.grey,
                      fontSize: ScreenUtil().setSp(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
                fileData('Clase', detalle.descripcionCategoria.toString(), 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                fileData('Descripción', detalle.descripcionItem.toString(), 10, 12, FontWeight.w600, FontWeight.w500, TextAlign.start),
                fileData('Observación', detalle.observacionInspeccionDetalle ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                fileData('Responsable', responsable, 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InformesController extends ChangeNotifier {
  ValueNotifier<List<InspeccionVehiculoDetalleModel>> informesList = ValueNotifier([]);

  ValueNotifier<List<InspeccionVehiculoDetalleModel>> get informesS => informesList;

  void saveInforme(InspeccionVehiculoDetalleModel item) {
    informesList.value.removeWhere((item) => item.idInspeccionDetalle == item.idInspeccionDetalle);
    informesList.value.add(item);
  }

  void removeInforme(String id) {
    informesList.value.removeWhere((item) => item.idInspeccionDetalle == id);
  }
}
