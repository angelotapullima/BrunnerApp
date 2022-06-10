import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Logistica/detalle_op_model.dart';
import 'package:new_brunner_app/src/model/Logistica/orden_pedido_model.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

class DetalleOrdenPedido extends StatefulWidget {
  const DetalleOrdenPedido({Key? key, required this.idOP, required this.rendicion}) : super(key: key);
  final String idOP;
  final String rendicion;

  @override
  State<DetalleOrdenPedido> createState() => _DetalleOrdenPedidoState();
}

class _DetalleOrdenPedidoState extends State<DetalleOrdenPedido> {
  final _controller = ControllerExpanded();
  @override
  Widget build(BuildContext context) {
    final detalleOPBloc = ProviderBloc.logisticaOP(context);
    detalleOPBloc.getDetalleOP(widget.idOP, widget.rendicion);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF154360),
        title: Text(
          'Orden de Pedido',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<bool>(
        stream: detalleOPBloc.cargando2Stream,
        builder: (_, b) {
          if (b.hasData && !b.data!) {
            return StreamBuilder<List<OrdenPedidoModel>>(
              stream: detalleOPBloc.detalleOPStream,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    var op = snapshot.data![0];
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10), horizontal: ScreenUtil().setWidth(16)),
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${obtenerFecha(op.fechaCreacion.toString())}',
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(11),
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                numberOP('OP ${op.numeroOP}', Colors.black),
                                SizedBox(height: ScreenUtil().setHeight(10)),
                                _expandedContainer(
                                  titulo: 'Empresa Adquiriente',
                                  expanded: _controller.expanded1,
                                  lugar: 1,
                                  color: Colors.green,
                                  contenido: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        op.nombreEmpresa ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: ScreenUtil().setHeight(4)),
                                      fileData('Ruc', op.empresa?.rucEmpresa ?? '', 11, 13, FontWeight.w500, FontWeight.w400, TextAlign.start),
                                      SizedBox(height: ScreenUtil().setHeight(4)),
                                      fileData(
                                          'Dirección', op.empresa?.direccionEmpresa ?? '', 11, 13, FontWeight.w500, FontWeight.w400, TextAlign.start),
                                      SizedBox(height: ScreenUtil().setHeight(4)),
                                      fileData('Departamento', '', 11, 13, FontWeight.w500, FontWeight.w400, TextAlign.start),
                                      SizedBox(height: ScreenUtil().setHeight(4)),
                                      fileData('Centro laboral', op.nombreSede ?? '', 11, 13, FontWeight.w500, FontWeight.w400, TextAlign.start),
                                    ],
                                  ),
                                ),
                                SizedBox(height: ScreenUtil().setHeight(20)),
                                _expandedContainer(
                                  titulo: 'Empresa Proveedora',
                                  expanded: _controller.expanded2,
                                  lugar: 2,
                                  color: Color(0XFF154360),
                                  contenido: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        op.nombreProveedor ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: ScreenUtil().setHeight(4)),
                                      fileData('Ruc', op.proveedor?.rucProveedor ?? '', 11, 13, FontWeight.w500, FontWeight.w400, TextAlign.start),
                                      SizedBox(height: ScreenUtil().setHeight(4)),
                                      fileData('Dirección', op.proveedor?.direccionProveedor ?? '', 11, 13, FontWeight.w500, FontWeight.w400,
                                          TextAlign.start),
                                      SizedBox(height: ScreenUtil().setHeight(4)),
                                      fileData('Persona de contacto', op.proveedor?.contactoProveedor ?? '', 11, 13, FontWeight.w500, FontWeight.w400,
                                          TextAlign.start),
                                      SizedBox(height: ScreenUtil().setHeight(4)),
                                      fileData('Telefono', op.proveedor?.telefonoProveedor ?? '', 11, 13, FontWeight.w500, FontWeight.w400,
                                          TextAlign.start),
                                      SizedBox(height: ScreenUtil().setHeight(4)),
                                      fileData(
                                          'Email', op.proveedor?.emailProveedor ?? '', 11, 13, FontWeight.w500, FontWeight.w400, TextAlign.start),
                                    ],
                                  ),
                                ),
                                SizedBox(height: ScreenUtil().setHeight(15)),
                                ExpansionTile(
                                  onExpansionChanged: (valor) {},
                                  maintainState: true,
                                  title: Text(
                                    'Detalle',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: ScreenUtil().setSp(14),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  children: op.detalle!.asMap().entries.map((item) {
                                    int idx = item.key;
                                    return _detalleOP(item.value, idx + 1);
                                  }).toList(),
                                ),
                                SizedBox(height: ScreenUtil().setHeight(20)),
                                Row(
                                  children: [
                                    SizedBox(width: ScreenUtil().setWidth(15)),
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(15),
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      op.totalOP ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: ScreenUtil().setSp(18),
                                        color: Color(0XFF154360),
                                      ),
                                    ),
                                    SizedBox(width: ScreenUtil().setWidth(8)),
                                    Text(
                                      op.monedaOP ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: ScreenUtil().setSp(15),
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: ScreenUtil().setHeight(50)),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text('Sin información disponible'),
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

  Widget _expandedContainer({required String titulo, required bool expanded, Widget? contenido, required int lugar, required Color color}) {
    return Container(
      child: Stack(
        children: [
          (expanded)
              ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(24),
                    right: ScreenUtil().setWidth(24),
                    top: ScreenUtil().setHeight(50),
                    bottom: ScreenUtil().setHeight(8),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.transparent.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: contenido,
                )
              : Container(),
          InkWell(
            onTap: () {
              _controller.changeExpanded(!expanded, lugar);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(24),
                vertical: ScreenUtil().setHeight(8),
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(14),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: ScreenUtil().setHeight(20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget numberOP(String titulo, Color color) {
    return Center(
      child: Container(
        height: ScreenUtil().setHeight(70),
        width: ScreenUtil().setWidth(250),
        margin: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(10),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.transparent.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(2),
                  bottom: ScreenUtil().setHeight(2),
                ),
                child: Image.asset(
                  'assets/img/logo.png',
                  height: ScreenUtil().setHeight(40),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: ScreenUtil().setHeight(70),
                width: ScreenUtil().setWidth(150),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(100),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    titulo,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(20),
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detalleOP(DetalleOPModel detail, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(index.toString()),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(10),
                vertical: ScreenUtil().setHeight(8),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.transparent.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.logisticaNombreRecurso ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(14),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(4),
                  ),
                  Text(
                    detail.tipoNombreRecurso ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: ScreenUtil().setSp(12),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(3),
                  ),
                  Text(
                    detail.descripcionSI ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(11),
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(7)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      fileData('SI', detail.idSI ?? '', 12, 12, FontWeight.w400, FontWeight.w500, TextAlign.start),
                      Text(
                        'Precio unit. ${detail.precioUnitario}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil().setSp(12),
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtil().setHeight(7)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${detail.cantidadSI} ${detail.umSI}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(13),
                        ),
                      ),
                      Text(
                        '${detail.precioTotal}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ControllerExpanded extends ChangeNotifier {
  bool expanded1 = true, expanded2 = true, expanded3 = true, expanded4 = false;

  void changeExpanded(bool e, int lugar) {
    switch (lugar) {
      case 1:
        expanded1 = e;
        break;
      case 2:
        expanded2 = e;
        break;
      case 3:
        expanded3 = e;
        break;
      case 4:
        expanded4 = e;
        break;
      default:
        break;
    }
    notifyListeners();
  }
}
