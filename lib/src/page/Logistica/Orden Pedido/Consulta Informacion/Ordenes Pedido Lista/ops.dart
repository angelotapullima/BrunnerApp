import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Logistica/orden_pedido_model.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

class OPS extends StatelessWidget {
  const OPS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logisticaOpBloc = ProviderBloc.logisticaOP(context);
    return StreamBuilder<bool>(
      stream: logisticaOpBloc.cargandoStream,
      builder: (_, s) {
        if (s.hasData && !s.data!) {
          return StreamBuilder<List<OrdenPedidoModel>>(
            stream: logisticaOpBloc.opsStream,
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
    );
  }

  Widget _items(BuildContext context, OrdenPedidoModel item) {
    Color color = Colors.green;
    Color colorText = Colors.orangeAccent;
    String textEstado = 'En proceso de rendición';
    IconData icon = FontAwesomeIcons.r;
    if (item.rendido == '0') {
      color = Colors.redAccent;
      textEstado = 'Sin rendir';
      icon = FontAwesomeIcons.triangleExclamation;
      colorText = Colors.redAccent;
    }
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
                  break;
                case 2:
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (context) => (item.estado == '0')
                ? [
                    _options(icon, color, textEstado, colorText, 0),
                    _options(Icons.remove_red_eye, Colors.blueGrey, 'Visualizar', Colors.black, 1),
                    _options(Icons.close, Colors.redAccent, 'Eliminar', Colors.redAccent, 2),
                  ]
                : [
                    _options(icon, color, textEstado, colorText, 0),
                    _options(Icons.remove_red_eye, Colors.blueGrey, 'Visualizar', Colors.black, 1),
                  ],
            child: contenidoItem(context, item),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: ScreenUtil().setWidth(110),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: Text(
                  'OP: ${item.numeroOP}',
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

  PopupMenuItem _options(IconData icon, Color colorIcon, String title, Color colorText, int value) {
    return PopupMenuItem(
      child: Row(
        children: [
          Icon(
            icon,
            color: colorIcon,
          ),
          SizedBox(
            width: ScreenUtil().setWidth(8),
          ),
          Text(
            title,
            style: TextStyle(color: colorText),
          ),
        ],
      ),
      value: value,
    );
  }

  Widget contenidoItem(BuildContext context, OrdenPedidoModel op) {
    Color color = Colors.redAccent;
    String textEstado = 'Sin Atención';
    IconData icon = Icons.error;
    switch (op.estado) {
      case '1':
        color = Colors.green;
        textEstado = 'Atendido';
        icon = FontAwesomeIcons.a;
        break;
      case '2':
        color = Colors.orangeAccent;
        textEstado = 'Parcialmente atendido';
        break;
      default:
        color = Colors.redAccent;
    }
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
                    icon,
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
                    '${obtenerFecha(op.fechaOP.toString())}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
                fileData('Clase', 'Orden de Pedido', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                fileData('Empresa', op.nombreEmpresa.toString(), 10, 12, FontWeight.w600, FontWeight.w500, TextAlign.start),
                fileData('Centro laboral', op.nombreSede ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                fileData('Proveedor', op.nombreProveedor ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                fileData('Solicitado por', '${op.nombrePerson} ${op.surnamePerson}', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
