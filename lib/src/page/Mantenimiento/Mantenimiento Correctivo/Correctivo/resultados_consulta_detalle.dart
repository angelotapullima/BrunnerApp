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
        itemCount: detalles.length,
        itemBuilder: (_, index) {
          var data = detalles[index];
          return _detalle(context, data);
        });
  }

  Widget _detalle(BuildContext context, InspeccionVehiculoDetalleModel detalle) {
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
              color: Colors.white,
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
                  width: ScreenUtil().setWidth(80),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.orangeAccent,
                      ),
                      Text(
                        'Nro CheckList',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(8),
                        ),
                      ),
                      Text(detalle.nroCheckList.toString()),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${obtenerFecha(detalle.fechaInspeccion.toString())} ${detalle.horaInspeccion}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(10),
                          ),
                        ),
                      ),
                      Text(detalle.descripcionCategoria.toString()),
                      Text(detalle.descripcionCategoria.toString()),
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

  Widget fileData(String titulo, String data, num sizeT, num sizeD) {
    return RichText(
      text: TextSpan(
          text: '$titulo: ',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: ScreenUtil().setSp(sizeT),
          ),
          children: [
            TextSpan(
              text: data,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtil().setSp(sizeD),
              ),
            )
          ]),
    );
  }
}
