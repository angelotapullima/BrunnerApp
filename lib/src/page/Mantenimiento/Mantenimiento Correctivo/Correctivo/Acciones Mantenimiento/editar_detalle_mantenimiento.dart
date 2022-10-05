import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/mantenimiento_correctivo_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Correctivo/Acciones%20Mantenimiento/editar_acciones_responsables.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

class EditarDetallesMantenimiento extends StatelessWidget {
  const EditarDetallesMantenimiento({Key? key, required this.detalle}) : super(key: key);
  final InspeccionVehiculoDetalleModel detalle;

  @override
  Widget build(BuildContext context) {
    final detalleBloc = ProviderBloc.mantenimientoCorrectivo(context);
    detalleBloc.getDetalleInspeccionManttCorrectivoById(detalle.idInspeccionDetalle.toString(), detalle.tipoUnidad.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF3498DB),
        title: Text(
          'Mantenimiento Correctivo',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<List<InspeccionVehiculoDetalleModel>>(
        stream: detalleBloc.detalleManttCorrectivoStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              var dato = snapshot.data![0];
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(16),
                        vertical: ScreenUtil().setHeight(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          fileData('Check List', 'N° ${dato.nroCheckList}', 15, 15, FontWeight.w400, FontWeight.w500, TextAlign.start),
                          Text(
                            '${obtenerFecha(dato.fechaInspeccion.toString())} ${dato.horaInspeccion}',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(11),
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    placa(
                      dato.plavaVehiculo.toString(),
                      Icons.bus_alert,
                      (dato.estadoInspeccionDetalle == '2')
                          ? Colors.orangeAccent
                          : (dato.estadoInspeccionDetalle == '3')
                              ? Colors.redAccent
                              : const Color(0XFF09AD92),
                    ),
                    const Divider(),
                    Text(
                      '${dato.descripcionCategoria}',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(14)),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(8)),
                    fileData('Descripción', '${dato.descripcionItem}', 14, 15, FontWeight.w400, FontWeight.w500, TextAlign.center),
                    SizedBox(height: ScreenUtil().setHeight(8)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(16),
                      ),
                      child:
                          fileData('Observación', '${dato.observacionInspeccionDetalle}', 14, 15, FontWeight.w500, FontWeight.w400, TextAlign.center),
                    ),
                    const Divider(),
                    SizedBox(height: ScreenUtil().setHeight(8)),
                    Text(
                      'HISTORIAL',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(16),
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(8)),
                    Column(
                      children: dato.mantCorrectivos!.map((item) => responsables(context, item)).toList(),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(50)),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text('Sin datos...'),
              );
            }
          } else {
            return ShowLoadding(
              active: true,
              h: double.infinity,
              w: double.infinity,
              fondo: Colors.black.withOpacity(.1),
              colorText: Colors.black,
            );
          }
        },
      ),
    );
  }

  Widget responsables(BuildContext context, MantenimientoCorrectivoModel dato) {
    return ExpansionTile(
      //backgroundColor: Colors.white,
      onExpansionChanged: (valor) {},
      maintainState: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dato.responsable ?? '',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: ScreenUtil().setSp(12),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            (dato.estadoFinal == '1') ? 'Habilitado' : 'Deshabilitado',
            style: TextStyle(
              color: (dato.estadoFinal == '1') ? Colors.green : Colors.redAccent,
              fontSize: ScreenUtil().setSp(9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      children: [
        detalleOption(context, dato, 1),
        detalleOption(context, dato, 2),
        detalleOption(context, dato, 3),
      ],
    );
  }

  Widget detalleOption(BuildContext context, MantenimientoCorrectivoModel data, int tipo) {
    // String text = 'Sin información';
    // if (tipo == 1) {
    //   text = data.diagnostico ?? 'Sin información';
    // } else if (tipo == 2) {
    //   text = data.conclusion ?? 'Sin información';
    // } else {
    //   text = data.recomendacion ?? 'Sin información';
    // }
    return Container(
      margin: EdgeInsets.all(8),
      child: Stack(children: [
        InkWell(
          onTap: () {
            // editarAccionResponsable(context, data, tipo, detalle.tipoUnidad.toString());
          },
          child: Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            width: double.infinity,
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(20),
              left: ScreenUtil().setWidth(8),
              right: ScreenUtil().setWidth(8),
              bottom: ScreenUtil().setHeight(8),
            ),
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
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.list,
                      color: Colors.blueGrey,
                      size: ScreenUtil().setHeight(20),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(8),
                    ),
                    // Expanded(
                    //   child: Text(
                    //     text,
                    //     style: TextStyle(fontSize: ScreenUtil().setSp(12), color: (text == 'Sin información') ? Colors.grey : Colors.black),
                    //   ),
                    // ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.edit,
                    color: Colors.blueGrey,
                    size: ScreenUtil().setHeight(20),
                  ),
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: ScreenUtil().setWidth(150),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.blueGrey)),
            child: Center(
              child: Text(
                (tipo == 1)
                    ? 'Diagnóstico'
                    : (tipo == 2)
                        ? 'Acciones Correctivas'
                        : 'Recomendaciones',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(11),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
