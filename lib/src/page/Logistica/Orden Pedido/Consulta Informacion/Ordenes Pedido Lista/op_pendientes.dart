import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Logistica/Orden%20Pedido/orden_pedido_model.dart';
import 'package:new_brunner_app/src/page/Logistica/Orden%20Pedido/Consulta%20Informacion/Ordenes%20Pedido%20Lista/detalle_oden_pedido.dart';
import 'package:new_brunner_app/src/page/Logistica/Orden%20Pedido/Consulta%20Informacion/Ordenes%20Pedido%20Lista/eliminar_op.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';
import 'package:new_brunner_app/src/widget/widget_all.dart';

class OPSPendientes extends StatelessWidget {
  const OPSPendientes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logisticaOpBloc = ProviderBloc.logisticaOP(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFFF39C12),
        title: Text(
          'Listado de Orden de Pedido Pendientes',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(12),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            autofocus: true,
            onPressed: () {
              logisticaOpBloc.getOPSPendientes();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: StreamBuilder<bool>(
        stream: logisticaOpBloc.cargandoStream,
        builder: (_, s) {
          if (s.hasData && !s.data!) {
            return StreamBuilder<List<OrdenPedidoModel>>(
              stream: logisticaOpBloc.opsPendientesStream,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length + 1,
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
                          var dato = snapshot.data![index];
                          return _items(context, dato);
                        });
                  } else {
                    return Center(
                      child: Text('Sin información disponible'),
                    );
                  }
                } else {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              },
            );
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

  Widget _items(BuildContext context, OrdenPedidoModel item) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
        vertical: ScreenUtil().setHeight(10),
      ),
      child: Stack(
        children: [
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case 0:
                  break;
                case 1:
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return DetalleOrdenPedido(
                          idOP: item.idOP.toString(),
                          rendicion: item.rendido.toString(),
                        );
                      },
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return EliminarOP(
                          idOP: item.idOP.toString(),
                          eliminar: '1',
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
              options(Icons.remove_red_eye, Colors.blueGrey, 'Visualizar', Colors.black, 1),
              options(Icons.close, Colors.redAccent, 'Eliminar', Colors.redAccent, 2),
            ],
            child: contenidoItem(context, item),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: ScreenUtil().setWidth(110),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.orangeAccent, borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: Text(
                  '${obtenerFecha(item.fechaCreacion.toString())}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget contenidoItem(BuildContext context, OrdenPedidoModel op) {
    return Container(
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
            width: ScreenUtil().setWidth(90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PopupMenuButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.error,
                    color: Colors.orangeAccent,
                    size: ScreenUtil().setHeight(30),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text(
                        'Sin Atención',
                        style: TextStyle(color: Colors.orangeAccent),
                      ),
                      value: 1,
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      op.monedaOP ?? '',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: ScreenUtil().setSp(9),
                      ),
                    ),
                    Text(
                      op.totalOP.toString(),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'Vencimiento: ${obtenerFecha(op.opVencimiento.toString())}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
                fileData('Proveedor', op.nombreProveedor ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                fileData('RUC', op.rucProveedor ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                fileData('Centro laboral', op.nombreSede ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                fileData('Condiciones', op.condicionesOP ?? '', 10, 12, FontWeight.w600, FontWeight.w500, TextAlign.start),
                fileData('Solicitado por', '${op.nombrePerson?.split(" ").first} ${op.surnamePerson}', 10, 12, FontWeight.w600, FontWeight.w400,
                    TextAlign.start),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
