import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Mantenimiento/mantenimiento_correctivo_api.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

class AsignarResponsableMantenimiento extends StatefulWidget {
  const AsignarResponsableMantenimiento(
      {Key? key, required this.idIsnpeccionDetalle, required this.idPerson, required this.person, required this.tipoUnidad})
      : super(key: key);
  final String idIsnpeccionDetalle;
  final String idPerson;
  final String person;
  final String tipoUnidad;

  @override
  State<AsignarResponsableMantenimiento> createState() => _AsignarResponsableMantenimientoState();
}

class _AsignarResponsableMantenimientoState extends State<AsignarResponsableMantenimiento> {
  final _controller = LoadingController();
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
              vertical: ScreenUtil().setHeight(310),
              horizontal: ScreenUtil().setWidth(40),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(24),
                vertical: ScreenUtil().setHeight(15),
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
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '¿Está seguro de asignar a ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(15),
                      ),
                      children: [
                        TextSpan(
                          text: widget.person,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                        TextSpan(
                          text: ' como responsable?',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ],
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
                          final _api = MantenimientoCorrectivoApi();

                          final res = await _api.asignarResponsableAInspeccionDetalle(widget.idIsnpeccionDetalle, widget.idPerson);
                          if (res == 1) {
                            final consultaDetallespBloc = ProviderBloc.mantenimientoCorrectivo(context);
                            consultaDetallespBloc.getInspeccionesById(widget.idIsnpeccionDetalle, widget.tipoUnidad);
                            showToast2('Responsable asignado correctamente', Colors.green);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            showToast2('Ocurrió un error, inténtelo nuevamente', Colors.red);
                          }
                          _controller.changeCargando(false);
                        },
                        child: Text(
                          'Confirmar',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(16),
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
            builder: (context, snapshot) {
              return ShowLoadding(
                active: _controller.cargando,
                h: double.infinity,
                w: double.infinity,
                fondo: Colors.black.withOpacity(.3),
                colorText: Colors.black,
              );
            },
          ),
        ],
      ),
    );
  }
}
