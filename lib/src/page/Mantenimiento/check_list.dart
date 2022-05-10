import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Mantenimiento/mantenimiento_api.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/check_item_inspeccion_database.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/vehiculo_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/categorias_inspeccion.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/choferes_search.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/observaciones_inspeccion.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:provider/provider.dart';

class CheckList extends StatefulWidget {
  const CheckList({Key? key, required this.vehiculo}) : super(key: key);
  final VehiculoModel vehiculo;

  @override
  State<CheckList> createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  final _hidrolinaController = TextEditingController();
  final _kilometrajeController = TextEditingController();
  final _controller = EditController();

  @override
  void dispose() {
    _hidrolinaController.dispose();
    _kilometrajeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ConductorController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Listado de verificación de unidades',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                placa(
                  widget.vehiculo.placaVehiculo.toString(),
                  Icons.bus_alert,
                  (widget.vehiculo.estadoInspeccionVehiculo == '2')
                      ? Colors.orangeAccent
                      : (widget.vehiculo.estadoInspeccionVehiculo == '3')
                          ? Colors.redAccent
                          : const Color(0XFF09AD92),
                ),
                const Divider(),
                Text(
                  'INFORMACIÓN DEL CONDUCTOR',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(14)),
                ),
                SizedBox(height: ScreenUtil().setHeight(5)),
                ValueListenableBuilder(
                  valueListenable: provider.conductorS,
                  builder: (BuildContext context, String data, Widget? child) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return const ChoferesSearch();
                            },
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              var begin = const Offset(0.0, 1.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end).chain(
                                CurveTween(curve: curve),
                              );

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(data),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                const Divider(),
                Text(
                  'SISTEMAS DE LA UNIDAD',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(14)),
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                      child: const Text('Estado'),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(16),
                    vertical: ScreenUtil().setHeight(4),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: ScreenUtil().setWidth(220)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green),
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.orangeAccent),
                        ),
                        child: const Icon(
                          Icons.error_rounded,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                CategoriasInspeccion(
                  idVehiculo: widget.vehiculo.idVehiculo.toString(),
                  tipoUnidad: widget.vehiculo.tipoUnidad.toString(),
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                const Divider(),
                _imputText(),
                SizedBox(height: ScreenUtil().setHeight(10)),
                const Divider(),
                Text(
                  'REPORTE DE OBSERVACIONES',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(14)),
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                ObservacionesInspeccion(
                  tipoUnidad: widget.vehiculo.tipoUnidad.toString(),
                ),
                _buttonSave(),
                SizedBox(height: ScreenUtil().setHeight(20)),
              ],
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
      ),
    );
  }

  Widget placa(String titulo, IconData icon, Color color) {
    return Center(
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
                    fontSize: ScreenUtil().setSp(20),
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

  Widget _imputText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(16),
          ),
          Text(
            'Hidrolina',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          TextField(
            controller: _hidrolinaController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Color(0xff808080),
            ),
            decoration: InputDecoration(
              suffix: const Text(
                'Galones',
                style: TextStyle(color: Colors.blueGrey),
              ),
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
              hintText: '0.00',
              hintStyle: const TextStyle(
                color: Color(0xff808080),
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(16),
          ),
          Text(
            (widget.vehiculo.tipoUnidad == '1') ? 'Kilometraje' : 'Horometraje',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          TextField(
            controller: _kilometrajeController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            style: const TextStyle(
              color: Color(0xff808080),
            ),
            decoration: InputDecoration(
              suffix: Text(
                (widget.vehiculo.tipoUnidad == '1') ? 'KM' : 'Horas',
                style: const TextStyle(color: Colors.blueGrey),
              ),
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
              hintText: '0.00',
              hintStyle: const TextStyle(
                color: Color(0xff808080),
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
        ],
      ),
    );
  }

  Widget _buttonSave() {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final provider = Provider.of<ConductorController>(context, listen: false);

        if (provider.idS.value != '') {
          final _cheksDB = CheckItemInspeccionDatabase();
          //final _checks = await _cheksDB.getCheckItemInspeccionByIdVehiculo(widget.vehiculo.idVehiculo.toString());
          final _checks = await _cheksDB.getCheckItemInspeccionFALTANTESByIdVehiculo(widget.vehiculo.idVehiculo.toString());
          // int count = 0;
          // for (var i = 0; i < _checks.length; i++) {
          //   if (_checks[i].valueCheckItemInsp == '0' && _checks[i].ckeckItemHabilitado == '0') {
          //     print(' ${_checks[i].conteoCheckItemInsp} ${_checks[i].valueCheckItemInsp} ${_checks[i].descripcionCheckItemInsp}');
          //     count++;
          //     break;
          //   }
          // }

          if (_checks.isEmpty) {
            if (_hidrolinaController.text.trim().isNotEmpty) {
              if (_kilometrajeController.text.trim().isNotEmpty) {
                _controller.chnageCargando(true);
                final _api = MantenimientoApi();
                final res = await _api.saveCheckList(
                    widget.vehiculo, provider.idS.value, _hidrolinaController.text.trim(), _kilometrajeController.text.trim());
                if (res.code == 1) {
                  showToast2('Check List guardado correctamente', Colors.blueGrey);
                  Navigator.pop(context);
                } else {
                  showToast2(res.message.toString(), Colors.redAccent);
                }
                _controller.chnageCargando(false);
              } else {
                (widget.vehiculo.tipoUnidad == '1')
                    ? showToast2('Debe ingresar los datos del KILOMETRAJE', Colors.redAccent)
                    : showToast2('Debe ingresar los datos de HOROMETRAJE', Colors.redAccent);
              }
            } else {
              showToast2('Debe ingresar los datos de HIDROLINA', Colors.redAccent);
            }
          } else {
            if (_checks.length == 1) {
              showToast2(
                  'Debe seleccionar el estado del item [${_checks[0].conteoCheckItemInsp.toString().trim()}]  ${_checks[0].descripcionCheckItemInsp.toString().trim()}',
                  Colors.redAccent);
            } else {
              showToast2('Debe seleccionar los estados de todos los items', Colors.redAccent);
            }
          }
        } else {
          showToast2('Debe seleccionar los datos del conductor', Colors.redAccent);
        }
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
    );
  }
}

class ConductorController extends ChangeNotifier {
  ValueNotifier<String> id = ValueNotifier('');
  ValueNotifier<String> conductor = ValueNotifier('Seleccionar...');

  ValueNotifier<String> get idS => id;
  ValueNotifier<String> get conductorS => conductor;

  void setData(String idC, String conductorN) {
    id.value = idC;
    conductor.value = conductorN;
  }
}
