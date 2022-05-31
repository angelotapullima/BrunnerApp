import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Mantenimiento/mantenimiento_correctivo_api.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/item_inspeccion_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Correctivo/Acciones%20Mantenimiento/visualizar_detalles.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Orden%20Habilitacion/mantenimientos.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Orden%20Habilitacion/new_observaciones_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Orden%20Habilitacion/widgets.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

class DetallesOrdenHabilitacion extends StatefulWidget {
  const DetallesOrdenHabilitacion({Key? key, required this.detalle}) : super(key: key);
  final List<InspeccionVehiculoDetalleModel> detalle;

  @override
  State<DetallesOrdenHabilitacion> createState() => _DetallesOrdenHabilitacionState();
}

class _DetallesOrdenHabilitacionState extends State<DetallesOrdenHabilitacion> {
  final _controller = ControllerDetalle();
  @override
  Widget build(BuildContext context) {
    final ordenHabilitacionBloc = ProviderBloc.ordenHab(context);
    ordenHabilitacionBloc.getInformesPendientesAprobacion(widget.detalle[0].plavaVehiculo.toString(), widget.detalle[0].tipoUnidad.toString());
    ordenHabilitacionBloc.getPendientesAtencion(widget.detalle[0].plavaVehiculo.toString(), widget.detalle[0].tipoUnidad.toString());
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (_, t) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                    child: RichText(
                      text: TextSpan(
                        text: 'Tiene ${_controller.totalInforme} observacion(es) corregida(s) pendientes de habilitar ',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                        children: [
                          TextSpan(
                            text: ', de un total de ${_controller.total}',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil().setSp(15),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                child: Text(
                  'Pendientes de aprobación:',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: ScreenUtil().setSp(18),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              StreamBuilder<List<InspeccionVehiculoDetalleModel>>(
                stream: ordenHabilitacionBloc.infoPenStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _controller.changeInformeTotal(snapshot.data!.length);
                    if (snapshot.data!.isNotEmpty) {
                      return InkWell(
                        onTap: () {
                          _seleccionarInformePendienteAprobacion(context, snapshot.data!);
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blueGrey),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Seleccionar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: ScreenUtil().setSp(16),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.blueGrey,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (_, s) {
                  return Column(
                    children: _controller.informes.map((item) => _detalleInformePendienteAprobacion(context, item, 'VER')).toList(),
                  );
                },
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              StreamBuilder<List<InspeccionVehiculoDetalleModel>>(
                stream: ordenHabilitacionBloc.enProcesoStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _controller.changeTotal(snapshot.data!.length);
                    if (snapshot.data!.isNotEmpty) {
                      return ExpansionTile(
                        maintainState: true,
                        title: Text(
                          'En proceso de atención (${snapshot.data!.length}):',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(18),
                          ),
                        ),
                        children: [
                          Mantenimientos(
                            detalles: snapshot.data!,
                            action: 'TODO',
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(16),
                  right: ScreenUtil().setWidth(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nuevas observaciones:',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: ScreenUtil().setSp(18),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _addObservacion(context, widget.detalle[0].tipoUnidad.toString());
                      },
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (_, s) {
                  return Column(
                    children: _controller.observaciones.map((item) => _detalleObservacion(context, item)).toList(),
                  );
                },
              ),
              Divider(),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              InkWell(
                onTap: () async {
                  _controller.changeCargando(true);
                  if (_controller.informes.isNotEmpty) {
                    final _api = MantenimientoCorrectivoApi();
                    final res =
                        await _api.habilitarObservaciones(widget.detalle[0].idVehiculo.toString(), _controller.informes, _controller.observaciones);

                    if (res == 1) {
                      _controller.removeAll();

                      final ordenHabilitacionBloc = ProviderBloc.ordenHab(context);
                      ordenHabilitacionBloc.getInformesPendientesAprobacion(
                          widget.detalle[0].plavaVehiculo.toString(), widget.detalle[0].tipoUnidad.toString());
                      ordenHabilitacionBloc.getPendientesAtencion(
                          widget.detalle[0].plavaVehiculo.toString(), widget.detalle[0].tipoUnidad.toString());
                      // final consultaDetallespBloc = ProviderBloc.ordenHab(context);
                      // consultaDetallespBloc.getInspeccionesById(widget.detalle[0].plavaVehiculo.toString(), widget.detalle[0].tipoUnidad.toString());
                      Future.delayed(Duration(seconds: 1));
                      showToast2('Acción realizada correctamente', Colors.green);
                    } else {
                      showToast2('Ocurrió un error, inténtelo nuevamente', Colors.red);
                    }
                  } else {
                    showToast2('Debe seleccionar por lo menos una observación corregida', Colors.red);
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
                      'Habilitar con Observaciones',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(18),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),
            ],
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
  }

  void _seleccionarInformePendienteAprobacion(BuildContext context, List<InspeccionVehiculoDetalleModel> lista) {
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
                initialChildSize: 0.6,
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
                          'Seleccione',
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
                            itemCount: lista.length,
                            itemBuilder: (_, index) {
                              return _detalleInformePendienteAprobacion(context, lista[index], 'SELECCIONAR');
                            },
                          ),
                        ),
                        // Column(
                        //   children: lista.map((item) => _detalleInformePendienteAprobacion(context, item, 'SELECCIONAR')).toList(),
                        // ),
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

  Widget _detalleInformePendienteAprobacion(BuildContext context, InspeccionVehiculoDetalleModel detalle, String accion) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
        vertical: ScreenUtil().setHeight(10),
      ),
      child: Stack(
        children: [
          (accion == 'VER')
              ? PopupMenuButton(
                  onSelected: (value) {
                    switch (value) {
                      case 1:
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return VisualizarDetalles(
                                detalle: detalle,
                              );
                            },
                          ),
                        );
                        break;
                      case 6:
                        _controller.removeInforme(detalle.idInspeccionDetalle.toString());
                        break;
                      default:
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(8),
                          ),
                          Text(
                            'Visualizar',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.cancel,
                            color: Colors.redAccent,
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(8),
                          ),
                          Text(
                            'Eliminar',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ],
                      ),
                      value: 6,
                    ),
                  ],
                  child: contenidoItem(context, detalle),
                )
              : InkWell(
                  onTap: () {
                    _controller.saveInforme(detalle);
                    Navigator.pop(context);
                  },
                  child: contenidoItem(context, detalle),
                ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: ScreenUtil().setWidth(110),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(color: Color(0XFF247196), borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: Text(
                  detalle.plavaVehiculo.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _detalleObservacion(BuildContext context, NuevasObservacionesModel observacion) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
        vertical: ScreenUtil().setHeight(10),
      ),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(15),
              right: ScreenUtil().setWidth(8),
              left: ScreenUtil().setWidth(8),
              bottom: ScreenUtil().setHeight(8),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      fileData('Denominación', observacion.descripcionItem.toString(), 10, 12, FontWeight.w600, FontWeight.w500, TextAlign.start),
                      fileData('Observación', observacion.observacion ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _controller.removeObservacion(observacion.observacion.toString());
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: ScreenUtil().setWidth(200),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(color: Color(0XFF16A085), borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: Text(
                  observacion.descripcionCat.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _addObservacion(BuildContext context, String tipoUnidad) {
    final _controllerL = LoadingController();
    TextEditingController _observacionesController = TextEditingController();
    final _categoriaController = TextEditingController();
    final _itemCatController = TextEditingController();

    String idCategoria = '';
    String idItemCategoria = '';

    void _seleccionarCategorias(BuildContext context) {
      final categoriasBloc = ProviderBloc.mantenimientoCorrectivo(context);
      categoriasBloc.getCategorias(tipoUnidad);
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
                            child: StreamBuilder<List<CategoriaInspeccionModel>>(
                                stream: categoriasBloc.categoriasStream,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CupertinoActivityIndicator(),
                                    );
                                  }

                                  if (snapshot.data!.isEmpty) {
                                    return Center(
                                      child: Text('Sin información disponible'),
                                    );
                                  }

                                  return ListView.builder(
                                    controller: controller,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (_, index) {
                                      var categories = snapshot.data![index];
                                      return InkWell(
                                        onTap: () {
                                          idCategoria = categories.idCatInspeccion.toString();
                                          _categoriaController.text = categories.descripcionCatInspeccion.toString().trim();

                                          Navigator.pop(context);
                                        },
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(categories.descripcionCatInspeccion.toString().trim()),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
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

    void _seleccionarItems(BuildContext context) {
      final itemsBloc = ProviderBloc.mantenimientoCorrectivo(context);
      itemsBloc.getItemsCategoria(idCategoria);
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
                            child: StreamBuilder<List<ItemInspeccionModel>>(
                                stream: itemsBloc.itemsCatStream,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CupertinoActivityIndicator(),
                                    );
                                  }

                                  if (snapshot.data!.isEmpty) {
                                    return Center(
                                      child: Text('Sin información disponible'),
                                    );
                                  }

                                  return ListView.builder(
                                    controller: controller,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (_, index) {
                                      var item = snapshot.data![index];
                                      return InkWell(
                                        onTap: () {
                                          idItemCategoria = item.idItemInspeccion.toString();
                                          _itemCatController.text = item.descripcionItemInspeccion.toString().trim();

                                          Navigator.pop(context);
                                        },
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(item.descripcionItemInspeccion.toString().trim()),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
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
                                  'Agregar nueva observación',
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
                                  controller: _categoriaController,
                                  style: const TextStyle(
                                    color: Color(0xff808080),
                                  ),
                                  readOnly: true,
                                  maxLines: null,
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    if (tipoUnidad != '') {
                                      _seleccionarCategorias(context);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.green,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xffeeeeee),
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
                                    hintText: 'Seleccionar',
                                    labelText: 'Clase',
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(10),
                                ),
                                TextField(
                                  controller: _itemCatController,
                                  style: const TextStyle(
                                    color: Color(0xff808080),
                                  ),
                                  readOnly: true,
                                  maxLines: null,
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    if (idCategoria != '') {
                                      _seleccionarItems(context);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.green,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xffeeeeee),
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
                                    hintText: 'Seleccionar',
                                    labelText: 'Descripción',
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(10),
                                ),
                                TextField(
                                  controller: _observacionesController,
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
                                    _controllerL.changeCargando(true);

                                    if (idCategoria != '') {
                                      if (idItemCategoria != '') {
                                        if (_observacionesController.text.trim().isNotEmpty) {
                                          final observacion = NuevasObservacionesModel();
                                          observacion.id = '1';
                                          observacion.idCategoria = idCategoria;
                                          observacion.descripcionCat = _categoriaController.text.trim();
                                          observacion.idItem = idItemCategoria;
                                          observacion.descripcionItem = _itemCatController.text.trim();
                                          observacion.observacion = _observacionesController.text.trim();
                                          _controller.saveObservacion(observacion);
                                          Navigator.pop(context);
                                        } else {
                                          showToast2('Debe agregar una observación', Colors.red);
                                        }
                                      } else {
                                        showToast2('Debe seleccionar una Denominación', Colors.red);
                                      }
                                    } else {
                                      showToast2('Debe seleccionar una Clase', Colors.red);
                                    }

                                    _controllerL.changeCargando(false);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.all(8),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0XFF16A085),
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
                                        'Agregar',
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
                        animation: _controllerL,
                        builder: (context, snapshot) {
                          return ShowLoadding(
                            active: _controllerL.cargando,
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
}
