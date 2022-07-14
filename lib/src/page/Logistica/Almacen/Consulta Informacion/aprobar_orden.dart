import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Logistica/almacen_api.dart';
import 'package:new_brunner_app/src/page/Logistica/Orden%20Pedido/Consulta%20Informacion/Ordenes%20Pedido%20Lista/detalle_oden_pedido.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

class AprobarOrden extends StatefulWidget {
  const AprobarOrden({Key? key, required this.id, required this.onChanged}) : super(key: key);
  final String id;
  final ValueChanged<int>? onChanged;

  @override
  _AprobarOrdenState createState() => _AprobarOrdenState();
}

class _AprobarOrdenState extends State<AprobarOrden> {
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
                    '¿Está seguro que desea aprobar esta orden?',
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
                            color: Colors.redAccent,
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
                          final _api = AlmacenApi();
                          final res = await _api.aprobarOrden(widget.id);
                          if (res == 1) {
                            widget.onChanged!(res);
                            Navigator.pop(context);
                            showToast2('Orden aprobada', Colors.green);
                          } else {
                            showToast2('Ocurrió un error, inténtelo nuevamente', Colors.redAccent);
                          }

                          _controller.changeCargando(false);
                        },
                        child: Text(
                          'Aprobar',
                          style: TextStyle(
                            color: Colors.green,
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
