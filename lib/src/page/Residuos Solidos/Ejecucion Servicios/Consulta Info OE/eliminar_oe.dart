import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Residuo%20Solido/consulta_oe_api.dart';
import 'package:new_brunner_app/src/page/Logistica/Orden%20Pedido/Consulta%20Informacion/Ordenes%20Pedido%20Lista/detalle_oden_pedido.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

class EliminarOE extends StatefulWidget {
  const EliminarOE({Key? key, required this.modulo, required this.id, required this.estado, required this.onChanged}) : super(key: key);
  final String modulo;
  final String id;
  final String estado;
  final ValueChanged<int>? onChanged;

  @override
  _EliminarOEState createState() => _EliminarOEState();
}

class _EliminarOEState extends State<EliminarOE> {
  final _controller = ControllerExpanded();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(.3),
      child: Stack(
        fit: StackFit.expand,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: const Color.fromRGBO(0, 0, 0, 0.3),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            margin: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(326),
              horizontal: ScreenUtil().setWidth(40),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(24),
                vertical: ScreenUtil().setHeight(10),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: ScreenUtil().setHeight(40),
                    child: Image.asset(
                      'assets/img/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),
                  Text(
                    '¿Está seguro que desea eliminar esta ${widget.modulo == "oes" ? "Orden de Ejecución de Servicio" : "Parte Operativo del Servicio"}?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: ScreenUtil().setSp(15),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(14),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(32),
                      ),
                      InkWell(
                        onTap: () async {
                          _controller.changeCargando(true);
                          final _api = ConsultaOEApi();
                          final res = await _api.accionesOE(modulo: widget.modulo, accion: 'eliminar', id: widget.id, estado: widget.estado);
                          if (res == 1) {
                            widget.onChanged!(res);
                            Navigator.pop(context);
                            showToast2('${widget.modulo == "oes" ? "Orden de Ejecución de Servicio" : "Parte Operativo del Servicio"} eliminada',
                                Colors.black);
                          } else {
                            showToast2('Ocurrió un error, inténtelo nuevamente', Colors.redAccent);
                          }

                          _controller.changeCargando(false);
                        },
                        child: Text(
                          'Eliminar',
                          style: TextStyle(
                            color: const Color(0XFFFF0F00),
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(14),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
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
                fondo: Colors.black.withOpacity(0.6),
                colorText: Colors.black,
              );
            },
          ),
        ],
      ),
    );
  }
}
