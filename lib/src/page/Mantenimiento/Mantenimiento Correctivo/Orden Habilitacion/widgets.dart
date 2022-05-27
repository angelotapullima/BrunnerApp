import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/Consulta%20Informacion/inspeccion_detalle.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Orden%20Habilitacion/new_observaciones_model.dart';
import 'package:new_brunner_app/src/util/utils.dart';

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
              PopupMenuButton(
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

class ControllerDetalle extends ChangeNotifier {
  int totalInforme = 0;
  int total = 0;
  List<InspeccionVehiculoDetalleModel> informes = [];
  List<NuevasObservacionesModel> observaciones = [];

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

  void saveInforme(InspeccionVehiculoDetalleModel item) {
    informes.removeWhere((element) => element.idInspeccionDetalle == item.idInspeccionDetalle);
    informes.add(item);
    notifyListeners();
  }

  void removeInforme(String id) {
    informes.removeWhere((item) => item.idInspeccionDetalle == id);
    notifyListeners();
  }

  void saveObservacion(NuevasObservacionesModel item) {
    observaciones.removeWhere((element) => element.observacion == item.observacion);
    observaciones.add(item);
    notifyListeners();
  }

  void removeObservacion(String observacion) {
    observaciones.removeWhere((item) => item.observacion == observacion);
    notifyListeners();
  }
}
