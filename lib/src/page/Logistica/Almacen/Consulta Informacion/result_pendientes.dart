import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/logistica_almacen_bloc.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/notas_pendientes_model.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/Consulta%20Informacion/eliminar_orden.dart';
import 'package:new_brunner_app/src/util/utils.dart';

class ResultPendientes extends StatelessWidget {
  const ResultPendientes({Key? key, required this.idSede, required this.tipo}) : super(key: key);
  final String idSede;
  final String tipo;

  @override
  Widget build(BuildContext context) {
    final almacenBloc = ProviderBloc.almacen(context);
    return StreamBuilder<List<NotasPendientesModel>>(
      stream: almacenBloc.notasPStrean,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length + 1,
              itemBuilder: (_, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Se encontraron ${snapshot.data!.length} resultados',
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
                var notaP = snapshot.data![index];
                return _crearItem(context, notaP, index + 1, almacenBloc);
              },
            );
          } else {
            return Center(
              child: Text('No se encontraron resultados con los datos ingresados'),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, NotasPendientesModel notaP, int n, LogisticaAlmacenBloc bloc) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16), vertical: ScreenUtil().setHeight(5)),
      child: PopupMenuButton(
        onSelected: (value) {
          switch (value) {
            case 1:
              // Navigator.push(
              //   context,
              //   PageRouteBuilder(
              //     pageBuilder: (context, animation, secondaryAnimation) {
              //       return VisualizarDetalles(
              //         detalle: detalle,
              //       );
              //     },
              //   ),
              // );
              break;
            case 2:
              //Eliminar POS
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return EliminarOrden(
                      page: 'pos',
                      id: notaP.idAlmacenLog ?? '',
                      onChanged: (val) {
                        if (val == 1) {
                          bloc.getNotasPendientes(idSede, tipo);
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
              break;
            default:
              break;
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
                  'Ver Orden',
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
                  Icons.delete,
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
            value: 2,
          ),
        ],
        child: Row(
          children: [
            SizedBox(
              width: ScreenUtil().setWidth(25),
              child: Text('$n'),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(8),
                  vertical: ScreenUtil().setHeight(6),
                ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${obtenerFecha(notaP.fechaAlmacenLog.toString())} ${notaP.horaAlmacenLog ?? ""}',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(11),
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    fileData('Sede', notaP.nombreSede ?? '', 10, 13, FontWeight.w500, FontWeight.w400, TextAlign.start),
                    fileData(
                        'Clase', (notaP.tipoAlmacenLog == '0') ? 'Salida' : 'Ingreso', 10, 13, FontWeight.w500, FontWeight.w400, TextAlign.start),
                    fileData('Descripción', notaP.comentarioAlmacenLog ?? '', 10, 13, FontWeight.w500, FontWeight.w400, TextAlign.start),
                    fileData('Solicitado por', notaP.nombreSoliAlmacenLog ?? '', 10, 13, FontWeight.w500, FontWeight.w400, TextAlign.start),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
