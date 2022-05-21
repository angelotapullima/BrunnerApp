import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Mantenimiento/inspeccion_api.dart';
import 'package:new_brunner_app/src/api/Mantenimiento/mantenimiento_correctivo_api.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

void anularDetalleInspeccion(BuildContext context, InspeccionVehiculoDetalleModel item) {
  final _controller = LoadingController();
  TextEditingController _numeroCheckList = TextEditingController();
  TextEditingController _observacionesController = TextEditingController();
  _numeroCheckList.text = item.descripcionItem.toString().trim();
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
                                'Anular CheckList Nro ${item.nroCheckList}',
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
                                controller: _numeroCheckList,
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
                                  labelText: '${item.descripcionCategoria}',
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(16),
                              ),
                              TextField(
                                controller: _observacionesController,
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
                                  hintText: 'Agregar observación',
                                  hintStyle: const TextStyle(
                                    color: Color(0xff808080),
                                  ),
                                  labelText: 'Observación',
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              InkWell(
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  _controller.changeCargando(true);

                                  if (_observacionesController.text.trim().isNotEmpty) {
                                    final _api = MantenimientoCorrectivoApi();

                                    final res =
                                        await _api.anularInspeccionDetalle(item.idInspeccionDetalle.toString(), _observacionesController.text.trim());
                                    if (res == 1) {
                                      final consultaDetallespBloc = ProviderBloc.mantenimientoCorrectivo(context);
                                      consultaDetallespBloc.getInspeccionesById(item.idInspeccionDetalle.toString(), item.tipoUnidad.toString());
                                      showToast2('CheckList Mantenimiento Anulado!!!', Colors.black);

                                      Navigator.pop(context);
                                    } else {
                                      showToast2('Ocurrió un error, inténtelo nuevamente', Colors.red);
                                    }
                                  } else {
                                    showToast2('Debe agregar una observación', Colors.red);
                                  }

                                  _controller.changeCargando(false);
                                },
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.redAccent,
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
                                      'Anular',
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
                                    'Cancelar',
                                    style: TextStyle(
                                      color: Colors.green,
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
