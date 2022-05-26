import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Correctivo/resultados_consulta_detalle.dart';

class DetallesOrdenHabilitacion extends StatelessWidget {
  const DetallesOrdenHabilitacion({Key? key, required this.detalle}) : super(key: key);
  final List<InspeccionVehiculoDetalleModel> detalle;

  @override
  Widget build(BuildContext context) {
    final ordenHabilitacionBloc = ProviderBloc.ordenHab(context);
    ordenHabilitacionBloc.getInformesPendientesAprobacion(detalle[0].plavaVehiculo.toString());
    ordenHabilitacionBloc.getPendientesAtencion(detalle[0].plavaVehiculo.toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                return Expanded(
                  child: ResultadosConsultaDetalle(
                    detalles: snapshot.data!,
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
          child: Text(
            'En proceso de atención:',
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
          stream: ordenHabilitacionBloc.enProcesoStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return Expanded(
                  child: ResultadosConsultaDetalle(
                    detalles: snapshot.data!,
                  ),
                );
              } else {
                return Center(
                  child: Text('Tiene 0 observaciones corregidas de un total de 0'),
                );
              }
            } else {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ),
      ],
    );
  }
}
