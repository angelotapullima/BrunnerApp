import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/orden_almacen_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/productos_orden_model.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/Consulta%20Informacion/aprobar_orden.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/Consulta%20Informacion/eliminar_orden.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/button_widget.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

class DetalleOrden extends StatelessWidget {
  const DetalleOrden({Key? key, required this.titulo, required this.idAlmacenLog, required this.idSede, required this.idTipo}) : super(key: key);
  final String titulo;
  final String idAlmacenLog;
  final String idSede;
  final String idTipo;

  @override
  Widget build(BuildContext context) {
    final detalleBloc = ProviderBloc.almacen(context);
    detalleBloc.getDetalleOrden(idAlmacenLog);
    return StreamBuilder<int>(
      stream: detalleBloc.respDetalleStream,
      builder: (_, r) {
        if (r.hasData && r.data! != 0) {
          if (r.data! == 1) {
            return StreamBuilder<List<OrdenAlmacenModel>>(
              stream: detalleBloc.detalleOrdenStrean,
              builder: (_, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  var orden = snapshot.data![0];
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: orden.estadoAlmacenLog == '0' ? Colors.orangeAccent : Color(0XFF154360),
                      title: Text(
                        '$titulo ${orden.estadoAlmacenLog == "0" ? "" : "- ${orden.codigoAlmacenLog}"}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      elevation: 0,
                      centerTitle: true,
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(16),
                          vertical: ScreenUtil().setHeight(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            fileData('Sede', orden.nombreSede ?? '', 12, 14, FontWeight.w400, FontWeight.w500, TextAlign.start),
                            fileData('Tipo de Registro', (orden.tipoAlmacenLog == '0') ? 'Salida' : 'Ingreso', 12, 14, FontWeight.w400,
                                FontWeight.w500, TextAlign.start),
                            fileData('Descripción', orden.comentarioAlmacenLog ?? '', 12, 14, FontWeight.w400, FontWeight.w500, TextAlign.start),
                            fileData('Registrado por', orden.nombreUserCreacion ?? '', 12, 14, FontWeight.w400, FontWeight.w500, TextAlign.start),
                            (orden.estadoAlmacenLog != '0')
                                ? fileData(
                                    'Fecha Aprobación', orden.nombreSoliAlmacenLog ?? '', 12, 14, FontWeight.w400, FontWeight.w500, TextAlign.start)
                                : Container(),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            ExpansionTile(
                              initiallyExpanded: true,
                              maintainState: true,
                              title: Text(
                                'Información Registrada',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              children: orden.products!.map((item) => _productos(item)).toList(),
                            ),
                            orden.estadoAlmacenLog == '0' ? _actionsPendientes(context, orden.idAlmacenLog ?? '') : Container(),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Scaffold(
                    body: Center(
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
                    ),
                  );
                }
              },
            );
          } else {
            return Scaffold(
              body: Center(
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
              ),
            );
          }
        } else {
          return Scaffold(
            body: ShowLoadding(
              active: true,
              h: double.infinity,
              w: double.infinity,
              fondo: Colors.transparent,
              colorText: Colors.black,
            ),
          );
        }
      },
    );
  }

  Widget _actionsPendientes(BuildContext context, String idAlmacenLog) {
    final detalleBloc = ProviderBloc.almacen(context);
    return Column(
      children: [
        SizedBox(height: ScreenUtil().setHeight(30)),
        ButtonWidget(
          titulo: 'Aprobar',
          width: double.infinity,
          sizeTitle: 18,
          color: Colors.green,
          onTap: () {
            //Aprobar Orden
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return AprobarOrden(
                    id: idAlmacenLog,
                    onChanged: (val) {
                      if (val == 1) {
                        detalleBloc.getDetalleOrden(idAlmacenLog);
                        detalleBloc.getNotasPendientes(idSede, idTipo);
                      }
                    },
                  );
                },
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  );

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
        ),
        TextButton(
          onPressed: () {
            //Eliminar Orden
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return EliminarOrden(
                    page: 'P',
                    id: idAlmacenLog,
                    onChanged: (val) {
                      if (val == 1) {
                        Navigator.pop(context);
                        detalleBloc.getNotasPendientes(idSede, idTipo);
                      }
                    },
                  );
                },
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  );

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
          child: Text(
            'Eliminar',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: ScreenUtil().setSp(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _productos(ProductosOrdenModel item) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
        vertical: ScreenUtil().setHeight(10),
      ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(5),
          ),
          fileData('Denominación', '${item.nombreClaseLogistica ?? ""} | ${item.nombreRecursoLogistica ?? ""}', 10, 12, FontWeight.w500,
              FontWeight.w500, TextAlign.start),
          fileData('U.M.', item.unidadDetalleAlmacen ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
          fileData('Detalle', item.nombreTipoRecurso ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
          fileData('Cantidad', item.stockDetalleAlmacen ?? '', 10, 14, FontWeight.w500, FontWeight.w600, TextAlign.start),
        ],
      ),
    );
  }
}
