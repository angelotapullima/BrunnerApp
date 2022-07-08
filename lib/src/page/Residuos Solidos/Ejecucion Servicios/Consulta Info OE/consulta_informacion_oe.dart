import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/page/Logistica/Orden%20Pedido/Consulta%20Informacion/Ordenes%20Pedido%20Lista/detalle_oden_pedido.dart';
import 'package:new_brunner_app/src/page/Residuos%20Solidos/Ejecucion%20Servicios/Consulta%20Info%20OE/OES/pendientes_oe.dart';
import 'package:new_brunner_app/src/page/Residuos%20Solidos/Ejecucion%20Servicios/Consulta%20Info%20OE/POS/pendientes_pos.dart';

class ConsultaInformacionOE extends StatefulWidget {
  const ConsultaInformacionOE({Key? key}) : super(key: key);

  @override
  State<ConsultaInformacionOE> createState() => _ConsultaInformacionOEState();
}

class _ConsultaInformacionOEState extends State<ConsultaInformacionOE> {
  final _controller = ControllerExpanded();
  @override
  Widget build(BuildContext context) {
    final _consultaOEBloc = ProviderBloc.consultaOE(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF85929E),
        title: Text(
          'Consulta de Información',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimatedBuilder(
          animation: _controller,
          builder: (_, p) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _expandedContainer(
                    titulo: 'Orden de Ejecución del Servicio (OES)',
                    expanded: _controller.expanded1,
                    lugar: 1,
                    color: Color(0XFF73C6B6),
                    contenido: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        option(
                          titulo: 'OES Generadas',
                          icon: Icons.handshake,
                          color: Color(0XFF73C6B6),
                        ),
                        option(
                          titulo: 'OES Pendientes de Aprobación',
                          icon: Icons.edit_note,
                          color: Colors.orangeAccent,
                          ontap: () {
                            _consultaOEBloc.getOESPendientes();
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  return const PendientesOES();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  _expandedContainer(
                    titulo: 'Parte Operativo del Servicio (POS)',
                    expanded: _controller.expanded2,
                    lugar: 2,
                    color: Colors.green,
                    contenido: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        option(
                          titulo: 'POS Generadas',
                          icon: Icons.file_open,
                          color: Colors.green,
                          ontap: () {},
                        ),
                        option(
                          titulo: 'POS Pendientes de Aprobación',
                          icon: Icons.edit_note,
                          color: Colors.orangeAccent,
                          ontap: () {
                            _consultaOEBloc.getPOSPendientes();
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  return const PendientesPOS();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
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
                  Expanded(
                    child: Text(
                      titulo,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(14),
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget option({required String titulo, required IconData icon, required Color color, Function()? ontap}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: ScreenUtil().setHeight(70),
        width: ScreenUtil().setWidth(155),
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
            Container(
              height: ScreenUtil().setHeight(70),
              width: ScreenUtil().setWidth(150),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(100),
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  titulo,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(1),
                  bottom: ScreenUtil().setHeight(2),
                ),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
