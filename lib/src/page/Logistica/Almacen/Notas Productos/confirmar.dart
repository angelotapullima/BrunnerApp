import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Logistica/almacen_api.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/Notas%20Productos/salida.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

class Confirmar extends StatefulWidget {
  Confirmar(
      {Key? key,
      required this.idSede,
      required this.idAlmacenDestino,
      required this.tipoRegistro,
      required this.dniSolicitante,
      required this.comentarios,
      required this.nombreSolicitante,
      required this.datos})
      : super(key: key);
  final String idSede;
  final String idAlmacenDestino;
  final String tipoRegistro;
  final String dniSolicitante;
  final String nombreSolicitante;
  final String comentarios;
  final String datos;

  @override
  State<Confirmar> createState() => _ConfirmarState();
}

class _ConfirmarState extends State<Confirmar> {
  final _controller = SalidaController();

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
                    '¿Está seguro que desea generar este registro?',
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
                            color: const Color(0XFFFF0F00),
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
                          final res = await _api.generarOrden(
                              idSede: widget.idSede,
                              idAlmacenDestino: widget.idAlmacenDestino,
                              tipoRegistro: widget.tipoRegistro,
                              dniSolicitante: widget.dniSolicitante,
                              nombreSolicitante: widget.nombreSolicitante,
                              comentarios: widget.comentarios,
                              datos: widget.datos);

                          if (res == 1) {
                            showToast2('Registro Generado correctamente', Colors.green);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            showToast2('Ocurrió un error, inténtelo nuevamente', Colors.redAccent);
                          }

                          _controller.changeCargando(false);
                        },
                        child: Text(
                          'Generar',
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
