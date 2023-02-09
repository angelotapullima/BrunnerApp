import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Orden%20Habilitacion/detalles_orden_habilitacion.dart';
import 'package:new_brunner_app/src/page/search_vehiculos.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/scan_qr_vehiculo_placa.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/text_field.dart';

class OrdenHabilitacionCorrectiva extends StatefulWidget {
  const OrdenHabilitacionCorrectiva({Key? key}) : super(key: key);

  @override
  State<OrdenHabilitacionCorrectiva> createState() =>
      _OrdenHabilitacionCorrectivaState();
}

class _OrdenHabilitacionCorrectivaState
    extends State<OrdenHabilitacionCorrectiva> {
  final _placaUnidad = TextEditingController();
  final _tipoVehiculo = TextEditingController();

  String _tipoVeh = '';
  List<String> tiposVehiculo = [
    'Seleccionar unidad',
    'Vehículo Motorizado Pesado',
    'Maquinaria Pesada',
    'Embarcación Fluvial',
    'Vehículo Motorizado Liviano',
  ];

  int count = 0;

  @override
  void dispose() {
    _placaUnidad.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tipoVehiculo.text = 'Seleccionar unidad';
    _tipoVeh = '';
    Future.delayed(const Duration(microseconds: 100), () async {
      filtroSearch();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordenHabilitacionBloc = ProviderBloc.ordenHab(context);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0XFF16A085),
          title: Text(
            'Orden Habilitación Correctiva',
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              autofocus: true,
              onPressed: () {
                filtroSearch();
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: StreamBuilder<bool>(
          stream: ordenHabilitacionBloc.cargandoStream,
          builder: (context, cargando) {
            if (!cargando.hasData || cargando.data!) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            return StreamBuilder<List<InspeccionVehiculoDetalleModel>>(
              stream: ordenHabilitacionBloc.detallesStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return DetallesOrdenHabilitacion(
                      detalle: snapshot.data!,
                    );
                  } else {
                    if (count == 0) {
                      count++;
                      return buttonSeach('¡Buscar ahora!');
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No se encontraron resultados...'),
                          SizedBox(
                            height: ScreenUtil().setHeight(10),
                          ),
                          buttonSeach('Buscar'),
                        ],
                      );
                    }
                  }
                } else {
                  if (count == 0) {
                    count++;

                    return buttonSeach('¡Buscar ahora!');
                  } else {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget buttonSeach(String title) {
    return Center(
      child: InkWell(
        onTap: () async {
          filtroSearch();
        },
        child: Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(50),
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
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(20),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void filtroSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          child: Container(
            color: const Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.7,
                minChildSize: 0.3,
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
                              height: ScreenUtil().setHeight(10),
                            ),
                            Text(
                              'Filtros',
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
                              label: 'Tipo de Unidad',
                              hingText: 'Seleccionar',
                              controller: _tipoVehiculo,
                              widget: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                _seleccionarTipoUnidad(context);
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Placa de la unidad',
                              hingText: 'Seleccionar',
                              controller: _placaUnidad,
                              widget: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                if (_tipoVeh != '') {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return VehiculosSearch(
                                          tipoUnidad: _tipoVeh,
                                          onChanged: (vehiculo) {
                                            _placaUnidad.text =
                                                vehiculo.placaVehiculo ?? '';
                                          },
                                        );
                                      },
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        var begin = const Offset(0.0, 1.0);
                                        var end = Offset.zero;
                                        var curve = Curves.ease;

                                        var tween =
                                            Tween(begin: begin, end: end).chain(
                                          CurveTween(curve: curve),
                                        );

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            InkWell(
                              onTap: () async {
                                if (_tipoVeh.isNotEmpty && _tipoVeh != '') {
                                  if (_placaUnidad.text.isNotEmpty) {
                                    final consultaDetallespBloc =
                                        ProviderBloc.ordenHab(context);
                                    consultaDetallespBloc.getInspeccionesById(
                                        _placaUnidad.text.trim(), _tipoVeh);
                                    Navigator.pop(context);
                                  } else {
                                    showToast2(
                                        'Debe seleccionar la Placa de una Unidad',
                                        Colors.redAccent);
                                  }
                                } else {
                                  showToast2(
                                      'Debe seleccionar un Tipo de Unidad',
                                      Colors.redAccent);
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
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Buscar',
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
                              height: ScreenUtil().setHeight(10),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return ScanQRVehiculoPlaca(
                                        modulo: 'OHC',
                                      );
                                    },
                                  ),
                                );
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
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.qr_code_scanner_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(10),
                                    ),
                                    Text(
                                      'Escanear QR',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(15),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  void _seleccionarTipoUnidad(BuildContext context) {
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
                initialChildSize: 0.5,
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
                          'Seleccionar Unidad',
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
                            itemCount: tiposVehiculo.length,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  _tipoVehiculo.text = tiposVehiculo[index];

                                  switch (tiposVehiculo[index]) {
                                    case 'Vehículo Motorizado Pesado':
                                      _tipoVeh = '1';
                                      break;
                                    case 'Maquinaria Pesada':
                                      _tipoVeh = '2';
                                      break;
                                    case 'Embarcación Fluvial':
                                      _tipoVeh = '3';
                                      break;
                                    case 'Vehículo Motorizado Liviano':
                                      _tipoVeh = '4';
                                      break;
                                    default:
                                      _tipoVeh = '';
                                      break;
                                  }
                                  // if (_tipoVehiculo.text == 'Vehiculo') {
                                  //   _tipoVeh = '1';
                                  // } else if (_tipoVehiculo.text == 'Maquinaria') {
                                  //   _tipoVeh = '2';
                                  // } else {
                                  //   _tipoVeh = '';
                                  // }
                                  _placaUnidad.clear();

                                  Navigator.pop(context);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(tiposVehiculo[index]),
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
