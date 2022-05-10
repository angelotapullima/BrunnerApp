import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/check_item_inspeccion_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/categorias_inspeccion.dart';
import 'package:new_brunner_app/src/util/utils.dart';

class ObservacionesInspeccion extends StatelessWidget {
  const ObservacionesInspeccion({Key? key, required this.tipoUnidad}) : super(key: key);
  final String tipoUnidad;

  @override
  Widget build(BuildContext context) {
    final observacionesBloc = ProviderBloc.checklist(context);

    return StreamBuilder<List<CheckItemInspeccionModel>>(
      stream: observacionesBloc.observacionesCkeckStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            // return Column(
            //   children: snapshot.data!.map((item) => crearObservacionInspeccion(context, item, 1)).toList(),
            // );

            return SizedBox(
              height: ScreenUtil().setHeight(70) * snapshot.data!.length,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => crearObservacionInspeccion(context, snapshot.data![index], index + 1)),
            );
          } else {
            return SizedBox(
              height: ScreenUtil().setHeight(20),
            );
          }
        } else {
          return SizedBox(
            height: ScreenUtil().setHeight(30),
            child: const Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget crearObservacionInspeccion(BuildContext context, CheckItemInspeccionModel item, int index) {
    return InkWell(
      onTap: () {
        editarObservacion(context, item);
      },
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          //Elimiar observacion
          final check = CheckItemInspeccionModel();
          check.valueCheckItemInsp = '0';
          check.idCheckItemInsp = item.idCheckItemInsp;
          check.observacionCkeckItemInsp = '';
          check.idVehiculo = item.idVehiculo;
          final _catInspeccionBloc = ProviderBloc.checklist(context);
          _catInspeccionBloc.updateCheckInspeccion(check, tipoUnidad);
          showToast2('Observación eliminada', Colors.black);
        },
        background: Container(
          padding: EdgeInsets.only(right: ScreenUtil().setWidth(16)),
          color: Colors.redAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ],
          ),
        ),
        direction: DismissDirection.endToStart,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(16),
            vertical: ScreenUtil().setHeight(8),
          ),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                index.toString(),
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(13),
                ),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(100),
                child: Text(
                  '${item.descripcionCheckItemInsp.toString().trim()} [${item.conteoCheckItemInsp.toString().trim()}]',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(150),
                child: Text(
                  item.observacionCkeckItemInsp.toString().trim(),
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editarObservacion(BuildContext context, CheckItemInspeccionModel item) {
    final _controller = EditController();
    TextEditingController _itemNameController = TextEditingController();
    TextEditingController _observacionesController = TextEditingController();
    _itemNameController.text = item.descripcionCheckItemInsp.toString().trim();
    _observacionesController.text = item.observacionCkeckItemInsp.toString().trim();
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
                                  'Editar observación',
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
                                  controller: _itemNameController,
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
                                    labelText: 'Item [${item.conteoCheckItemInsp.toString().trim()}]',
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
                                  onTap: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    _controller.chnageCargando(true);

                                    if (_observacionesController.text.trim().isNotEmpty) {
                                      final check = CheckItemInspeccionModel();
                                      check.valueCheckItemInsp = item.valueCheckItemInsp;
                                      check.idCheckItemInsp = item.idCheckItemInsp;
                                      check.observacionCkeckItemInsp = _observacionesController.text.trim();
                                      check.idVehiculo = item.idVehiculo;
                                      final _catInspeccionBloc = ProviderBloc.checklist(context);
                                      _catInspeccionBloc.updateObservaciones(check);
                                      Navigator.pop(context);
                                    } else {
                                      showToast2('Debe agregar una observación', Colors.red);
                                    }

                                    _controller.chnageCargando(false);
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
                                        'Guardar',
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
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    _controller.chnageCargando(true);

                                    //Elimiar observacion
                                    final check = CheckItemInspeccionModel();
                                    check.valueCheckItemInsp = '0';
                                    check.idCheckItemInsp = item.idCheckItemInsp;
                                    check.observacionCkeckItemInsp = '';
                                    check.idVehiculo = item.idVehiculo;
                                    final _catInspeccionBloc = ProviderBloc.checklist(context);
                                    _catInspeccionBloc.updateCheckInspeccion(check, tipoUnidad);
                                    Navigator.pop(context);

                                    showToast2('Observación eliminada', Colors.black);

                                    _controller.chnageCargando(false);
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
                                        'Eliminar',
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
                                        color: Colors.redAccent,
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
                        builder: (_, s) {
                          return (_controller.cargando)
                              ? Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.black.withOpacity(0.3),
                                  child: const Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                )
                              : Container();
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
}
