import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

void detalleInspeccionAnulado(BuildContext context, InspeccionVehiculoDetalleModel item) {
  final _controller = LoadingController();
  TextEditingController _placaVehiculo = TextEditingController();
  TextEditingController _observacionFinalController = TextEditingController();
  TextEditingController _observacionItemController = TextEditingController();
  _placaVehiculo.text = item.plavaVehiculo.toString().trim();
  _observacionFinalController.text = item.observacionFinalInspeccionDetalle.toString().trim();
  _observacionItemController.text = item.observacionInspeccionDetalle.toString().trim();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: const Color.fromRGBO(0, 0, 0, 0.001),
          child: GestureDetector(
            child: DraggableScrollableSheet(
              initialChildSize: 0.65,
              minChildSize: 0.3,
              maxChildSize: 0.7,
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
                                'Mantenimiento Correctivo',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(20),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${obtenerFecha(item.fechaInspeccion.toString())} ${item.horaInspeccion}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: ScreenUtil().setSp(10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              Text(
                                'Check List Nro ${item.nroCheckList}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(15),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              Text(
                                'ANULADO',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: ScreenUtil().setSp(18),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              TextField(
                                controller: _placaVehiculo,
                                readOnly: true,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xff808080),
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
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
                                  labelText: 'Vehiculo',
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(16),
                              ),
                              TextField(
                                controller: _observacionItemController,
                                keyboardType: TextInputType.multiline,
                                readOnly: true,
                                maxLines: null,
                                textInputAction: TextInputAction.done,
                                style: const TextStyle(
                                  color: Color(0xff808080),
                                ),
                                decoration: InputDecoration(
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
                                  labelText: '${item.descripcionCategoria} - ${item.descripcionItem}',
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(16),
                              ),
                              TextField(
                                controller: _observacionFinalController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                readOnly: true,
                                textInputAction: TextInputAction.done,
                                style: const TextStyle(
                                  color: Color(0xff808080),
                                ),
                                decoration: InputDecoration(
                                  //filled: true,
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
                                  labelText: 'Comentario de anulación',
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Center(
                                  child: Text(
                                    'Volver',
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
