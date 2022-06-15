import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Logistica/logistica_api.dart';
import 'package:new_brunner_app/src/api/pdf_api.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
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
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10), horizontal: ScreenUtil().setWidth(16)),
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, snapshot) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    (op.estado != '0' && op.numeroOP != '0') ? numberOP('OP ${op.numeroOP}', Colors.black) : Container(),
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
                                          fileData('Dirección', op.empresa?.direccionEmpresa ?? '', 11, 13, FontWeight.w500, FontWeight.w400,
                                              TextAlign.start),
                                          SizedBox(height: ScreenUtil().setHeight(4)),
                                          fileData('Departamento', op.departamento ?? '', 11, 13, FontWeight.w500, FontWeight.w400, TextAlign.start),
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
                                          fileData(
                                              'Ruc', op.proveedor?.rucProveedor ?? '', 11, 13, FontWeight.w500, FontWeight.w400, TextAlign.start),
                                          SizedBox(height: ScreenUtil().setHeight(4)),
                                          fileData('Dirección', op.proveedor?.direccionProveedor ?? '', 11, 13, FontWeight.w500, FontWeight.w400,
                                              TextAlign.start),
                                          SizedBox(height: ScreenUtil().setHeight(4)),
                                          fileData('Persona de contacto', op.proveedor?.contactoProveedor ?? '', 11, 13, FontWeight.w500,
                                              FontWeight.w400, TextAlign.start),
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
                                      initiallyExpanded: true,
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
                                            fontWeight: FontWeight.w500,
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
                                    Divider(thickness: 1),
                                    SizedBox(height: ScreenUtil().setHeight(10)),
                                    _detallePago(op),
                                    SizedBox(height: ScreenUtil().setHeight(15)),
                                    (op.estado == '0' && op.numeroOP == '0') ? _botonAprobarOP(op) : Container(),
                                    (op.estado == '0' && op.numeroOP == '0') ? SizedBox(height: ScreenUtil().setHeight(10)) : Container(),
                                    // _buttonPDF(op.idOP.toString()),
                                    SizedBox(height: ScreenUtil().setHeight(50)),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (_, p) {
                            return ShowLoadding(
                              active: _controller.cargando,
                              h: double.infinity,
                              w: double.infinity,
                              fondo: Colors.black.withOpacity(0.5),
                              colorText: Colors.black,
                            );
                          },
                        ),
                      ],
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
                    (expanded) ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
                    //topLeft: Radius.circular(10),
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
                  (detail.descripcionSI != '')
                      ? SizedBox(
                          height: ScreenUtil().setHeight(3),
                        )
                      : Container(),
                  (detail.descripcionSI != '')
                      ? Text(
                          detail.descripcionSI ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: ScreenUtil().setSp(11),
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      : Container(),
                  SizedBox(height: ScreenUtil().setHeight(7)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      fileData('SI', detail.nroSI ?? '', 12, 12, FontWeight.w400, FontWeight.w500, TextAlign.start),
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

  Widget _fileData(String titulo, String data, num sizeT, num sizeD, FontWeight ft, FontWeight fd, TextAlign aling) {
    return RichText(
      textAlign: aling,
      text: TextSpan(
        text: '$titulo: ',
        style: TextStyle(
          color: Colors.blueGrey,
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
        ],
      ),
    );
  }

  Widget _fileBanco(String data, String data2, String data3, String data4) {
    return RichText(
      text: TextSpan(
        text: 'Banco: ',
        style: TextStyle(
          color: Colors.blueGrey,
          fontWeight: FontWeight.w500,
          fontSize: ScreenUtil().setSp(12),
        ),
        children: [
          TextSpan(
            text: data,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: ScreenUtil().setSp(13),
            ),
          ),
          TextSpan(
            text: ' | ',
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w500,
              fontSize: ScreenUtil().setSp(13),
            ),
          ),
          TextSpan(
            text: ' Número de Cuenta: ',
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w400,
              fontSize: ScreenUtil().setSp(12),
            ),
          ),
          TextSpan(
            text: data2,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: ScreenUtil().setSp(13),
            ),
          ),
          TextSpan(
            text: ' | ',
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w500,
              fontSize: ScreenUtil().setSp(13),
            ),
          ),
          TextSpan(
            text: ' Moneda: ',
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w400,
              fontSize: ScreenUtil().setSp(12),
            ),
          ),
          TextSpan(
            text: data3,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: ScreenUtil().setSp(13),
            ),
          ),
          TextSpan(
            text: ' | ',
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w500,
              fontSize: ScreenUtil().setSp(13),
            ),
          ),
          TextSpan(
            text: ' CCI: ',
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w400,
              fontSize: ScreenUtil().setSp(12),
            ),
          ),
          TextSpan(
            text: data4,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: ScreenUtil().setSp(13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fileBancoNacion(String data, String data2) {
    return RichText(
      text: TextSpan(
        text: 'Banco: ',
        style: TextStyle(
          color: Colors.blueGrey,
          fontWeight: FontWeight.w500,
          fontSize: ScreenUtil().setSp(12),
        ),
        children: [
          TextSpan(
            text: data,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: ScreenUtil().setSp(13),
            ),
          ),
          TextSpan(
            text: ' | ',
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w500,
              fontSize: ScreenUtil().setSp(13),
            ),
          ),
          TextSpan(
            text: ' Cuenta Detracciones: ',
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w400,
              fontSize: ScreenUtil().setSp(12),
            ),
          ),
          TextSpan(
            text: data2,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: ScreenUtil().setSp(13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detallePago(OrdenPedidoModel op) {
    var banco1 = op.proveedor?.banco1Proveedor?.split('/../');
    var banco2 = op.proveedor?.banco2Proveedor?.split('/../');
    var banco3 = op.proveedor?.banco3Proveedor?.split('/../');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fileData('Condiciones', op.condicionesOP ?? '', 12, 13, FontWeight.w500, FontWeight.w500, TextAlign.start),
          (banco1?[0] != '') ? SizedBox(height: ScreenUtil().setHeight(10)) : Container(),
          (banco1?[0] != '')
              ? (banco1?[0] == 'BANCO DE LA NACION')
                  ? _fileBancoNacion(banco1?[0] ?? '', banco1?[1] ?? '')
                  : _fileBanco(banco1?[0] ?? '', banco1?[2] ?? '', banco1?[1] ?? '', banco1?[3] ?? '')
              : Container(),
          (banco2?[0] != '') ? SizedBox(height: ScreenUtil().setHeight(6)) : Container(),
          (banco2?[0] != '')
              ? (banco2?[0] == 'BANCO DE LA NACION')
                  ? _fileBancoNacion(banco2?[0] ?? '', banco2?[1] ?? '')
                  : _fileBanco(banco2?[0] ?? '', banco2?[2] ?? '', banco2?[1] ?? '', banco2?[3] ?? '')
              : Container(),
          (banco3?[0] != '') ? SizedBox(height: ScreenUtil().setHeight(6)) : Container(),
          (banco3?[0] != '')
              ? (banco3?[0] == 'BANCO DE LA NACION')
                  ? _fileBancoNacion(banco3?[0] ?? '', banco3?[1] ?? '')
                  : _fileBanco(banco3?[0] ?? '', banco3?[2] ?? '', banco3?[1] ?? '', banco3?[3] ?? '')
              : Container(),
          SizedBox(height: ScreenUtil().setHeight(10)),
          _fileData('Solicitado por', '${op.nombrePerson ?? ""} ${op.surnamePerson ?? ""} ${op.surname2Person ?? ""}', 12, 13, FontWeight.w500,
              FontWeight.w500, TextAlign.start),
          SizedBox(height: ScreenUtil().setHeight(10)),
          (op.estado != '0')
              ? _fileData('Aprobado por', '${op.nombreApro ?? ""} ${op.surnameApro ?? ""} ${op.surname2Apro ?? ""}', 12, 13, FontWeight.w500,
                  FontWeight.w500, TextAlign.start)
              : Container(),
        ],
      ),
    );
  }

  Widget _botonAprobarOP(OrdenPedidoModel op) {
    return InkWell(
      onTap: () async {
        _controller.changeCargando(true);
        final _api = LogisticaApi();
        final res = await _api.aprobarOP(op.idOP.toString());
        if (res == 1) {
          final detalleOPBloc = ProviderBloc.logisticaOP(context);
          detalleOPBloc.getDetalleOP(op.idOP.toString(), op.rendido.toString());
          detalleOPBloc.getOPSPendientes();
          showToast2('Solicitud aprobada', Colors.green);
        } else {
          showToast2('Ocurrió un error, inténtelo nuevamente', Colors.redAccent);
        }
        _controller.changeCargando(false);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0XFFF39C12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aprobar',
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(18),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(6),
            ),
            Icon(
              Icons.check_circle_outline,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonPDF(String idOP) {
    return InkWell(
      onTap: () async {
        _controller.changeCargando(true);
        final _apiPDF = PdfApi();
        _apiPDF.openFile(url: '$apiBaseURL/OrdenPedido/pdf_op/$idOP');
        _controller.changeCargando(false);
      },
      child: Center(
        child: Container(
          width: ScreenUtil().setWidth(200),
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0XFFE74C3C),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Visualizar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(18),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(8),
              ),
              const Icon(
                Icons.picture_as_pdf,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ControllerExpanded extends ChangeNotifier {
  bool expanded1 = true, expanded2 = true, expanded3 = true, expanded4 = false;
  bool cargando = false;

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

  void changeCargando(bool c) {
    cargando = c;
    notifyListeners();
  }
}
