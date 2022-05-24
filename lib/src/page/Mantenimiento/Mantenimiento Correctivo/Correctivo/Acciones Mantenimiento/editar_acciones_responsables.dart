import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Mantenimiento/mantenimiento_correctivo_api.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/mantenimiento_correctivo_model.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

void editarAccionResponsable(BuildContext context, MantenimientoCorrectivoModel item, int accion, String tipoUnidad) {
  final _controller = LoadingController();
  TextEditingController _responsableController = TextEditingController();
  TextEditingController _detalleController = TextEditingController();
  _responsableController.text = item.responsable.toString().trim();
  _detalleController.text = (accion == 1)
      ? item.diagnostico ?? ''
      : (accion == 2)
          ? item.conclusion ?? ''
          : item.recomendacion ?? '';
  String text = '';
  if (accion == 1) {
    text = 'Diagnóstico';
  } else if (accion == 2) {
    text = 'Acciones Correctivas';
  } else {
    text = 'Recomendaciones';
  }
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return GestureDetector(
        child: Container(
          color: const Color.fromRGBO(0, 0, 0, 0.001),
          child: GestureDetector(
            onTap: () {},
            child: DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              builder: (_, controller) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(24),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: ScreenUtil().setHeight(16),
                              ),
                              Center(
                                child: Container(
                                  width: ScreenUtil().setWidth(100),
                                  height: ScreenUtil().setHeight(5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Text(
                                (accion == 1)
                                    ? 'Editar Diagnóstico'
                                    : (accion == 2)
                                        ? 'Editar Acciones Correctivas'
                                        : 'Editar Recomendaciones',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(20),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              TextField(
                                controller: _responsableController,
                                readOnly: true,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xff808080),
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xffeeeeee),
                                  labelStyle: const TextStyle(
                                    color: Color(0xff808080),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xffeeeeee),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xffeeeeee),
                                    ),
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Color(0xff808080),
                                  ),
                                  labelText: 'Responsable',
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(16),
                              ),
                              TextField(
                                controller: _detalleController,
                                autofocus: true,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                textInputAction: TextInputAction.done,
                                style: const TextStyle(
                                  color: Color(0xff808080),
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xffeeeeee),
                                  labelStyle: const TextStyle(
                                    color: Color(0xff808080),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xffeeeeee),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xffeeeeee),
                                    ),
                                  ),
                                  hintText: (accion == 1)
                                      ? 'Agregar Diagnóstico'
                                      : (accion == 2)
                                          ? 'Agregar Acciones Correctivas'
                                          : 'Agregar Recomendaciones',
                                  hintStyle: const TextStyle(
                                    color: Color(0xff808080),
                                  ),
                                  labelText: (accion == 1)
                                      ? 'Diagnóstico'
                                      : (accion == 2)
                                          ? 'Acciones Correctivas'
                                          : 'Recomendaciones',
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              InkWell(
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  _controller.changeCargando(true);

                                  if (_detalleController.text.trim().isNotEmpty) {
                                    final _api = MantenimientoCorrectivoApi();

                                    final res = await _api.actualizarAcciones(
                                        item.idMantenimiento.toString(), _detalleController.text.trim(), accion.toString());
                                    if (res == 1) {
                                      final detalleBloc = ProviderBloc.mantenimientoCorrectivo(context);
                                      detalleBloc.getDetalleInspeccionManttCorrectivoById(item.idInspeccionDetalle.toString(), tipoUnidad);
                                      showToast2('$text editado correctamente', Colors.green);

                                      Navigator.pop(context);
                                    } else {
                                      showToast2('Ocurrió un error, inténtelo nuevamente', Colors.red);
                                    }
                                  } else {
                                    showToast2('Debe agregar $text', Colors.red);
                                  }

                                  _controller.changeCargando(false);
                                },
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.green,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 3,
                                        blurRadius: 8,
                                        offset: const Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Editar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(20),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(15),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Center(
                                  child: Text(
                                    'Volver',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: ScreenUtil().setSp(20),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
