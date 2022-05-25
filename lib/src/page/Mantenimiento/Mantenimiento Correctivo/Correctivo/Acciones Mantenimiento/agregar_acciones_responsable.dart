import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Mantenimiento/mantenimiento_correctivo_api.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/mantenimiento_correctivo_model.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

class AddAccionesResponsable extends StatefulWidget {
  const AddAccionesResponsable({Key? key, required this.detalle}) : super(key: key);
  final InspeccionVehiculoDetalleModel detalle;

  @override
  State<AddAccionesResponsable> createState() => _AddAccionesResponsableState();
}

class _AddAccionesResponsableState extends State<AddAccionesResponsable> {
  String _accion = '';
  List<String> acciones = [
    'Diagnóstico',
    'Acciones Correctivas',
    'Recomendaciones',
    //'Anular',
  ];
  final _accionController = TextEditingController();
  final _descripccionAccionController = TextEditingController();

  final _controller = AccionesController();
  @override
  Widget build(BuildContext context) {
    final detalleBloc = ProviderBloc.mantenimientoCorrectivo(context);
    detalleBloc.getDetalleResponsableInspeccionManttCorrectivoById(
        widget.detalle.idInspeccionDetalle.toString(), widget.detalle.tipoUnidad.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mantenimiento Correctivo',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<List<InspeccionVehiculoDetalleModel>>(
        stream: detalleBloc.detalleManttCorrectivoStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              var dato = snapshot.data![0];
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(16),
                            vertical: ScreenUtil().setHeight(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              fileData('Check List', 'N° ${dato.nroCheckList}', 15, 15, FontWeight.w400, FontWeight.w500, TextAlign.start),
                              Text(
                                '${obtenerFecha(dato.fechaInspeccion.toString())} ${dato.horaInspeccion}',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(11),
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        placa(
                          dato.plavaVehiculo.toString(),
                          Icons.bus_alert,
                          (dato.estadoInspeccionDetalle == '2')
                              ? Colors.orangeAccent
                              : (dato.estadoInspeccionDetalle == '3')
                                  ? Colors.redAccent
                                  : const Color(0XFF09AD92),
                        ),
                        const Divider(),
                        Text(
                          '${dato.descripcionCategoria}',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(14)),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(8)),
                        fileData('Descripción', '${dato.descripcionItem}', 14, 15, FontWeight.w400, FontWeight.w500, TextAlign.center),
                        SizedBox(height: ScreenUtil().setHeight(8)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(16),
                          ),
                          child: fileData(
                              'Observación', '${dato.observacionInspeccionDetalle}', 14, 15, FontWeight.w500, FontWeight.w400, TextAlign.center),
                        ),
                        const Divider(),
                        SizedBox(height: ScreenUtil().setHeight(8)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Responsable: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: ScreenUtil().setSp(14),
                                color: Colors.blueGrey,
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(8),
                            ),
                            Text(
                              dato.mantCorrectivos![0].responsable.toString(),
                              style: TextStyle(fontSize: ScreenUtil().setSp(13), fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const Divider(),
                        SizedBox(height: ScreenUtil().setHeight(8)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                          child: TextField(
                            controller: _accionController,
                            readOnly: true,
                            onTap: () {
                              _seleccionarAccion(context, dato.mantCorrectivos![0]);
                            },
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xff808080),
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              fillColor: const Color(0xffeeeeee),
                              labelStyle: const TextStyle(
                                color: Colors.blueGrey,
                              ),
                              suffixIcon: Icon(Icons.keyboard_arrow_down),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                  color: Colors.blueGrey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                  color: Colors.blueGrey,
                                ),
                              ),
                              hintStyle: const TextStyle(
                                color: Color(0xff808080),
                              ),
                              hintText: 'Seleccionar',
                              labelText: 'Acción a realizar',
                            ),
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(16)),
                        AnimatedBuilder(
                            animation: _controller,
                            builder: (_, s) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                                child: TextField(
                                  controller: _descripccionAccionController,
                                  readOnly: !_controller.activeEdit,
                                  maxLines: null,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    color: Color(0xff808080),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: InputDecoration(
                                    filled: !_controller.activeEdit,
                                    fillColor: (_controller.activeEdit) ? Colors.white : const Color(0xffeeeeee),
                                    labelStyle: const TextStyle(
                                      color: Colors.blueGrey,
                                    ),
                                    suffixIcon: IconButton(
                                        onPressed: () async {
                                          if (_controller.activeEdit) {
                                            if (_accion != '') {
                                              if (_descripccionAccionController.text.isNotEmpty) {
                                                FocusScope.of(context).requestFocus(FocusNode());
                                                _controller.changeCargando(true);
                                                final _api = MantenimientoCorrectivoApi();
                                                final res = await _api.actualizarAcciones(dato.mantCorrectivos![0].idMantenimiento.toString(),
                                                    _descripccionAccionController.text.toString().trim(), _accion);

                                                if (res == 1) {
                                                  _controller.changeAcccion(false);
                                                  final detalleBloc = ProviderBloc.mantenimientoCorrectivo(context);
                                                  detalleBloc.getDetalleResponsableInspeccionManttCorrectivoById(
                                                      widget.detalle.idInspeccionDetalle.toString(), widget.detalle.tipoUnidad.toString());

                                                  detalleBloc.getInspeccionesById(
                                                      widget.detalle.idInspeccionDetalle.toString(), widget.detalle.tipoUnidad.toString());
                                                  _accionController.clear();
                                                  _descripccionAccionController.clear();
                                                  showToast2('Acción guardado correctamente', Colors.green);
                                                } else {
                                                  showToast2('Ocurrió un error, Inténtelo nuevamente', Colors.redAccent);
                                                }

                                                _controller.changeCargando(false);
                                              } else {
                                                showToast2('Debe ingresar un detalle para continuar', Colors.redAccent);
                                              }
                                            } else {
                                              showToast2('Debe seleccionar una Acción a realizar', Colors.redAccent);
                                            }
                                          } else {
                                            _controller.changeAcccion(true);
                                          }
                                        },
                                        icon: Icon((_controller.activeEdit) ? Icons.check : Icons.edit)),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    hintStyle: const TextStyle(
                                      color: Color(0xff808080),
                                    ),
                                    labelText: 'Detalle',
                                  ),
                                ),
                              );
                            }),
                        const Divider(),
                        SizedBox(height: ScreenUtil().setHeight(8)),
                        Text(
                          'HISTORIAL',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: ScreenUtil().setSp(14),
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(8)),
                        options(context, 'Diagnóstico', dato.mantCorrectivos!, 1),
                        options(context, 'Acciones Correctivas', dato.mantCorrectivos!, 2),
                        options(context, 'Recomendaciones', dato.mantCorrectivos!, 3),
                        SizedBox(height: ScreenUtil().setHeight(50)),
                      ],
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (_, t) {
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
            } else {
              return Center(
                child: Text('Sin datos...'),
              );
            }
          } else {
            return ShowLoadding(
              active: true,
              h: double.infinity,
              w: double.infinity,
              fondo: Colors.black.withOpacity(.1),
              colorText: Colors.black,
            );
          }
        },
      ),
    );
  }

  Widget options(BuildContext context, String titulo, List<MantenimientoCorrectivoModel> detail, int tipoOption) {
    List<MantenimientoCorrectivoModel> showList = [];
    for (var i = 0; i < detail.length; i++) {
      switch (tipoOption) {
        case 1:
          if (detail[i].diagnostico != null) {
            showList.add(detail[i]);
          }

          break;
        case 2:
          if (detail[i].conclusion != null) {
            showList.add(detail[i]);
          }

          break;
        case 3:
          if (detail[i].recomendacion != null) {
            showList.add(detail[i]);
          }

          break;
        default:
      }
    }
    return (showList.isNotEmpty)
        ? ExpansionTile(
            //backgroundColor: Colors.white,
            onExpansionChanged: (valor) {},
            maintainState: true,
            title: Text(
              titulo,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w500,
              ),
            ),
            children: showList.map((item) => detalleOption(item, tipoOption)).toList(),
          )
        : Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(16),
                  vertical: ScreenUtil().setHeight(16),
                ),
                child: Text(
                  (tipoOption == 1)
                      ? 'Sin Diagnósticos disponibles'
                      : (tipoOption == 2)
                          ? 'Sin Acciones Correctivas'
                          : 'Sin Recomendaciones',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: ScreenUtil().setSp(14),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          );
  }

  Widget detalleOption(MantenimientoCorrectivoModel data, int tipo) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Stack(children: [
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
          width: double.infinity,
          padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(20),
            left: ScreenUtil().setWidth(8),
            right: ScreenUtil().setWidth(8),
            bottom: ScreenUtil().setHeight(8),
          ),
          decoration: BoxDecoration(
            color: (widget.detalle.estadoFinalInspeccionDetalle == '0') ? Colors.redAccent.withOpacity(0.5) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.transparent.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.blueGrey,
                    size: ScreenUtil().setHeight(18),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(8),
                  ),
                  Text(
                    data.responsable.toString(),
                    style: TextStyle(fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              Row(
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.blueGrey,
                    size: ScreenUtil().setHeight(20),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(8),
                  ),
                  Expanded(
                    child: Text(
                      (tipo == 1)
                          ? data.diagnostico.toString()
                          : (tipo == 2)
                              ? data.conclusion.toString()
                              : data.recomendacion.toString(),
                      style: TextStyle(fontSize: ScreenUtil().setSp(12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: ScreenUtil().setWidth(150),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.blueGrey)),
            child: Center(
              child: Text(
                obtenerFechaHora(data.dateTimeMantenimiento.toString()),
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(10),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }

  void _seleccionarAccion(BuildContext context, MantenimientoCorrectivoModel data) {
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
                initialChildSize: 0.7,
                minChildSize: 0.2,
                maxChildSize: 0.9,
                builder: (_, controller) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.grey[600],
                        ),
                        Text(
                          'Seleccionar Estado',
                          style: TextStyle(
                            color: const Color(0xff5a5a5a),
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(20),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: acciones.length,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  _accionController.text = acciones[index];
                                  _controller.changeAcccion(false);

                                  switch (acciones[index]) {
                                    case 'Diagnóstico':
                                      _accion = '1';
                                      _descripccionAccionController.text = data.diagnostico ?? '';
                                      break;
                                    case 'Acciones Correctivas':
                                      _accion = '2';
                                      _descripccionAccionController.text = data.conclusion ?? '';
                                      break;
                                    case 'Recomendaciones':
                                      _accion = '3';
                                      _descripccionAccionController.text = data.recomendacion ?? '';
                                      break;
                                    // case 'Anular':
                                    //   _accion = '4';
                                    //   _descripccionAccionController.clear();
                                    //break;
                                    default:
                                      _accion = '';
                                      break;
                                  }

                                  Navigator.pop(context);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(acciones[index]),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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

class AccionesController extends ChangeNotifier {
  bool activeEdit = false;
  bool cargando = false;

  void changeAcccion(bool a) {
    activeEdit = a;
    notifyListeners();
  }

  void changeCargando(bool c) {
    cargando = c;
    notifyListeners();
  }
}
