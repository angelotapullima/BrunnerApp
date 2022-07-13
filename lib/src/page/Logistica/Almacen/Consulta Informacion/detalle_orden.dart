import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/orden_almacen_model.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

class DetalleOrden extends StatelessWidget {
  const DetalleOrden({Key? key, required this.idAlmacenLog, required this.titulo}) : super(key: key);
  final String idAlmacenLog;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    final detalleBloc = ProviderBloc.almacen(context);
    detalleBloc.getDetalleOrden(idAlmacenLog);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          titulo,
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<int>(
        stream: detalleBloc.respDetalleStream,
        builder: (_, r) {
          if (r.hasData && r.data! != 0) {
            if (r.data! == 1) {
              return StreamBuilder<List<OrdenAlmacenModel>>(
                stream: detalleBloc.detalleOrdenStrean,
                builder: (_, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    var orden = snapshot.data![0];
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${obtenerFecha(orden.fechaAlmacenLog.toString())} ${orden.horaAlmacenLog ?? ""}',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(11),
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          fileData('Sede', orden.nombreSede ?? '', 10, 13, FontWeight.w500, FontWeight.w400, TextAlign.start),
                          fileData('Clase', (orden.tipoAlmacenLog == '0') ? 'Salida' : 'Ingreso', 10, 13, FontWeight.w500, FontWeight.w400,
                              TextAlign.start),
                          fileData('Descripción', orden.comentarioAlmacenLog ?? '', 10, 13, FontWeight.w500, FontWeight.w400, TextAlign.start),
                          fileData('Solicitado por', orden.nombreSoliAlmacenLog ?? '', 10, 13, FontWeight.w500, FontWeight.w400, TextAlign.start),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Consultar nuevamente'),
                          IconButton(
                            onPressed: () {
                              detalleBloc.getDetalleOrden(idAlmacenLog);
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.green,
                              size: ScreenUtil().setHeight(50),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Consultar nuevamente'),
                    IconButton(
                      onPressed: () {
                        detalleBloc.getDetalleOrden(idAlmacenLog);
                      },
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.green,
                        size: ScreenUtil().setHeight(50),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return ShowLoadding(
              active: true,
              h: double.infinity,
              w: double.infinity,
              fondo: Colors.transparent,
              colorText: Colors.black,
            );
          }
        },
      ),
    );
  }
}
