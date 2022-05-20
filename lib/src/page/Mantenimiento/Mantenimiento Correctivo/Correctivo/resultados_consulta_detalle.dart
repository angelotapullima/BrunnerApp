import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/util/utils.dart';

class ResultadosConsultaDetalle extends StatelessWidget {
  const ResultadosConsultaDetalle({Key? key, required this.detalles}) : super(key: key);
  final List<InspeccionVehiculoDetalleModel> detalles;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: detalles.length + 1,
        itemBuilder: (_, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(5),
                horizontal: ScreenUtil().setWidth(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Se encontraron ${detalles.length} resultados',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(10),
                    ),
                  ),
                ],
              ),
            );
          }
          index = index - 1;
          var data = detalles[index];
          return _detalle(context, data);
        });
  }

  Widget _detalle(BuildContext context, InspeccionVehiculoDetalleModel detalle) {
    Color color = Colors.redAccent;
    String textEstado = 'Sin Atender';
    if (detalle.estadoFinalInspeccionDetalle == '0') {
      textEstado = 'Anulado';
    }
    if (detalle.mantCorrectivos!.isNotEmpty) {
      switch (detalle.mantCorrectivos![0].estado) {
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
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
        vertical: ScreenUtil().setHeight(10),
      ),
      child: Stack(
        children: [
          Container(
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
                      fileData('Clase', detalle.descripcionCategoria.toString(), 10, 12, FontWeight.w600, FontWeight.w400),
                      fileData('Descripción', detalle.descripcionItem.toString(), 10, 12, FontWeight.w600, FontWeight.w500),
                      fileData('Observación', detalle.observacionInspeccionDetalle.toString(), 10, 12, FontWeight.w600, FontWeight.w400),
                      fileData('Mantenimiento', detalle.mantCorrectivos!.length.toString(), 10, 12, FontWeight.w600, FontWeight.w400),
                    ],
                  ),
                ),
              ],
            ),
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

  Widget fileData(String titulo, String data, num sizeT, num sizeD, FontWeight ft, FontWeight fd) {
    return RichText(
      text: TextSpan(
          text: '$titulo: ',
          style: TextStyle(
            color: Colors.black,
            fontWeight: ft,
            fontSize: ScreenUtil().setSp(sizeT),
          ),
          children: [
            TextSpan(
              text: data,
              style: TextStyle(
                color: Colors.black,
                fontWeight: fd,
                fontSize: ScreenUtil().setSp(sizeD),
              ),
            )
          ]),
    );
  }
}
