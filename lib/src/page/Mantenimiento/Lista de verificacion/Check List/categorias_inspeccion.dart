import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/check_item_inspeccion_model.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/text_field.dart';

class CategoriasInspeccion extends StatefulWidget {
  const CategoriasInspeccion({Key? key, required this.tipoUnidad, required this.idVehiculo}) : super(key: key);
  final String idVehiculo;
  final String tipoUnidad;

  @override
  State<CategoriasInspeccion> createState() => _CategoriasInspeccionState();
}

class _CategoriasInspeccionState extends State<CategoriasInspeccion> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    final _catInspeccionBloc = ProviderBloc.checklist(context);
    if (count == 0) {
      _catInspeccionBloc.getCatCheckInspeccion(widget.idVehiculo, widget.tipoUnidad);
      count++;
    }

    return StreamBuilder<List<CategoriaInspeccionModel>>(
      stream: _catInspeccionBloc.catInspeccionStream,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Column(
            children: snapshot.data!.map((categoria) => crearCategoriaInspeccion(categoria, context)).toList(),
          );
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

  Widget crearCategoriaInspeccion(CategoriaInspeccionModel categoria, BuildContext context) {
    return ExpansionTile(
      backgroundColor: Colors.white,
      onExpansionChanged: (valor) {},
      maintainState: true,
      title: Text(
        categoria.descripcionCatInspeccion.toString(),
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: ScreenUtil().setSp(14),
          fontWeight: FontWeight.w500,
        ),
      ),
      children: categoria.checkItemInspeccion!.map((item) => crearItemInspeccion(context, item)).toList(),
    );
  }

  Widget crearItemInspeccion(BuildContext context, CheckItemInspeccionModel item) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
        vertical: ScreenUtil().setHeight(8),
      ),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: (item.ckeckItemHabilitado == '1') ? Colors.blueGrey.withOpacity(0.15) : Colors.transparent,
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.conteoCheckItemInsp.toString().trim(),
            style: TextStyle(
              fontSize: ScreenUtil().setSp(13),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(200),
            child: Text(
              item.descripcionCheckItemInsp.toString().trim(),
              style: TextStyle(
                fontSize: ScreenUtil().setSp(13),
              ),
            ),
          ),
          check(
            context,
            (item.valueCheckItemInsp == '1') ? Icons.check_circle : Icons.circle_outlined,
            (item.valueCheckItemInsp == '1') ? Colors.green : Colors.blueGrey,
            '1',
            item,
          ),
          check(
            context,
            (item.valueCheckItemInsp == '2') ? Icons.error_rounded : Icons.circle_outlined,
            (item.valueCheckItemInsp == '2') ? Colors.orangeAccent : Colors.blueGrey,
            '2',
            item,
          ),
          check(
            context,
            (item.valueCheckItemInsp == '3') ? Icons.cancel : Icons.circle_outlined,
            (item.valueCheckItemInsp == '3') ? Colors.red : Colors.blueGrey,
            '3',
            item,
          ),
        ],
      ),
    );
  }

  Widget check(BuildContext context, IconData icon, Color color, String value, CheckItemInspeccionModel item) {
    return InkWell(
      onTap: () {
        if (item.ckeckItemHabilitado == '0') {
          if (value != '1') {
            addObservacion(context, item, value);
          } else {
            final check = CheckItemInspeccionModel();
            check.valueCheckItemInsp = value;
            check.idCheckItemInsp = item.idCheckItemInsp;
            check.observacionCkeckItemInsp = '';
            check.idVehiculo = widget.idVehiculo;
            final _catInspeccionBloc = ProviderBloc.checklist(context);
            _catInspeccionBloc.updateCheckInspeccion(check, widget.tipoUnidad);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: (item.ckeckItemHabilitado == '1') ? Colors.blueGrey.withOpacity(0.1) : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: color),
        ),
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }

  void addObservacion(BuildContext context, CheckItemInspeccionModel item, String value) {
    final _controller = EditController();
    TextEditingController _itemNameController = TextEditingController();
    TextEditingController _observacionesController = TextEditingController();
    _itemNameController.text = item.descripcionCheckItemInsp.toString().trim();
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
                                  'Agregar observación',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ScreenUtil().setSp(20),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(20),
                                ),
                                TextFieldSelect(
                                  label: 'Item [${item.conteoCheckItemInsp.toString().trim()}]',
                                  hingText: '',
                                  controller: _itemNameController,
                                  readOnly: true,
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(16),
                                ),
                                TextFieldSelect(
                                  label: 'Observación',
                                  hingText: 'Agregar observación',
                                  controller: _observacionesController,
                                  readOnly: false,
                                  autofocus: true,
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
                                      check.valueCheckItemInsp = value;
                                      check.idCheckItemInsp = item.idCheckItemInsp;
                                      check.observacionCkeckItemInsp = _observacionesController.text.trim();
                                      check.idVehiculo = widget.idVehiculo;
                                      final _catInspeccionBloc = ProviderBloc.checklist(context);
                                      _catInspeccionBloc.updateCheckInspeccion(check, widget.tipoUnidad);
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
                          }),
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

class EditController extends ChangeNotifier {
  bool cargando = false;

  void chnageCargando(bool c) {
    cargando = c;
    notifyListeners();
  }
}
