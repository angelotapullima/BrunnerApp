import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/item_inspeccion_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Correctivo/resultados_consulta_detalle.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/search_person_mantenimiento.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/search_vehiculos.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:provider/provider.dart';

class MantCorrectivo extends StatefulWidget {
  const MantCorrectivo({Key? key}) : super(key: key);

  @override
  State<MantCorrectivo> createState() => _MantCorrectivoState();
}

class _MantCorrectivoState extends State<MantCorrectivo> {
  final _placaUnidad = TextEditingController();
  final _responsable = TextEditingController();
  final _fechaInicio = TextEditingController();
  final _fechaFin = TextEditingController();
  final _nroCheck = TextEditingController();
  final _estadoController = TextEditingController();
  final _tipoVehiculo = TextEditingController();
  final _categoriaController = TextEditingController();
  final _itemCatController = TextEditingController();

  String _estado = '';
  List<String> estadoItems = [
    'Todos',
    'Atendido',
    'Informe Pendiente de Aprobación',
    'Diagnosticado',
    'En proceso de Atención',
    'Sin Atender',
    'Anulado',
  ];

  String _tipoVeh = '';
  List<String> tiposVehiculo = [
    'Seleccionar unidad',
    'Vehiculo',
    'Maquinaria',
  ];

  String idCategoria = '';
  String idItemCategoria = '';

  int count = 0;

  @override
  void dispose() {
    _placaUnidad.dispose();
    _fechaInicio.dispose();
    _fechaFin.dispose();
    _nroCheck.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _estadoController.text = 'Todos';
    _estado = '';
    _tipoVehiculo.text = 'Seleccionar unidad';
    _tipoVeh = '';
    // var data =
    //     "${DateTime.now().year.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
    // _fechaInicio.text = data;
    // _fechaFin.text = data;
    Future.delayed(const Duration(microseconds: 100), () async {
      filtroSearch();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final consultaDetallesBloc = ProviderBloc.mantenimientoCorrectivo(context);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
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
          stream: consultaDetallesBloc.cargandoStream,
          builder: (context, cargando) {
            if (!cargando.hasData || cargando.data!) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            return StreamBuilder<List<InspeccionVehiculoDetalleModel>>(
              stream: consultaDetallesBloc.detallesStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ResultadosConsultaDetalle(
                      detalles: snapshot.data!,
                    );
                  } else {
                    if (count == 0) {
                      count++;

                      return buttonSeach();
                    } else {
                      return const Center(
                        child: Text('No se encontraron resultados...'),
                      );
                    }
                  }
                } else {
                  if (count == 0) {
                    count++;

                    return buttonSeach();
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

  Widget buttonSeach() {
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
              '¡Buscar ahora!',
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
    final providerPerson = Provider.of<PersonaMantenimientoController>(context, listen: false);
    final providerPlaca = Provider.of<VehiculosController>(context, listen: false);
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
                initialChildSize: 0.95,
                minChildSize: 0.3,
                maxChildSize: 0.95,
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
                            TextField(
                              controller: _tipoVehiculo,
                              maxLines: null,
                              readOnly: true,
                              style: const TextStyle(
                                color: Color(0xff808080),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                _seleccionarTipoUnidad(context);
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
                                hintText: 'Unidad',
                                hintStyle: const TextStyle(
                                  color: Color(0xff808080),
                                ),
                                labelText: 'Unidad',
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            ValueListenableBuilder(
                              valueListenable: providerPlaca.placaS,
                              builder: (BuildContext context, String data, Widget? child) {
                                if (data != '') {
                                  _placaUnidad.text = data;
                                } else {
                                  _placaUnidad.clear();
                                }
                                return TextField(
                                  readOnly: true,
                                  controller: _placaUnidad,
                                  maxLines: null,
                                  style: const TextStyle(
                                    color: Color(0xff808080),
                                  ),
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    if (_tipoVeh != '') {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) {
                                            return VehiculosSearch(
                                              tipoUnidad: _tipoVeh,
                                            );
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
                                    labelText: 'Placa de la unidad',
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            ValueListenableBuilder(
                              valueListenable: providerPerson.personaS,
                              builder: (BuildContext context, String data, Widget? child) {
                                if (data != 'Seleccionar responsable') {
                                  _responsable.text = data;
                                } else {
                                  _responsable.text = '';
                                }
                                return TextField(
                                  readOnly: true,
                                  controller: _responsable,
                                  maxLines: null,
                                  style: const TextStyle(
                                    color: Color(0xff808080),
                                  ),
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) {
                                          return PersonMantenimiento();
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
                                    hintText: 'Seleccionar responsable',
                                    labelText: 'Responsable',
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
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
                                if (_tipoVeh != '') {
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
                              controller: _estadoController,
                              maxLines: null,
                              readOnly: true,
                              style: const TextStyle(
                                color: Color(0xff808080),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                _seleccionarEstadoInspeccion(context);
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
                                hintText: 'Estado',
                                hintStyle: const TextStyle(
                                  color: Color(0xff808080),
                                ),
                                labelText: 'Estado',
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextField(
                              controller: _nroCheck,
                              style: const TextStyle(
                                color: Color(0xff808080),
                              ),
                              decoration: InputDecoration(
                                suffixIcon: const Icon(
                                  Icons.numbers,
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
                                hintText: 'Digitar N°',
                                labelText: 'N° de Check List',
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextField(
                              controller: _fechaInicio,
                              readOnly: true,
                              style: const TextStyle(
                                color: Color(0xff808080),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                _selectdate(context, _fechaInicio);
                              },
                              decoration: InputDecoration(
                                suffixIcon: const Icon(
                                  Icons.calendar_month_outlined,
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
                                hintText: 'Fecha inicio',
                                hintStyle: const TextStyle(
                                  color: Color(0xff808080),
                                ),
                                labelText: 'Fecha inicio',
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextField(
                              controller: _fechaFin,
                              readOnly: true,
                              style: const TextStyle(
                                color: Color(0xff808080),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                _selectdate(context, _fechaFin);
                              },
                              decoration: InputDecoration(
                                suffixIcon: const Icon(
                                  Icons.calendar_month_outlined,
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
                                hintText: 'Fecha fin',
                                hintStyle: const TextStyle(
                                  color: Color(0xff808080),
                                ),
                                labelText: 'Fecha término',
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            InkWell(
                              onTap: () async {
                                if (_tipoVeh.isNotEmpty && _tipoVeh != '') {
                                  print(providerPlaca.placaS.value);
                                  final consultaDetallespBloc = ProviderBloc.mantenimientoCorrectivo(context);
                                  consultaDetallespBloc.getDetalleInsppeccionFiltro(
                                    _tipoVeh,
                                    providerPlaca.placaS.value,
                                    providerPerson.idS.value,
                                    idCategoria.trim(),
                                    idItemCategoria.trim(),
                                    _estado.trim(),
                                    _nroCheck.text.trim(),
                                    _fechaInicio.text.trim(),
                                    _fechaFin.text.trim(),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  showToast2('Debe seleecionar por lo menos una unidad', Colors.redAccent);
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
                                  if (_tipoVehiculo.text == 'Vehiculo') {
                                    _tipoVeh = '1';
                                  } else if (_tipoVehiculo.text == 'Maquinaria') {
                                    _tipoVeh = '2';
                                  } else {
                                    _tipoVeh = '';
                                  }
                                  final provider = Provider.of<VehiculosController>(context, listen: false);

                                  idCategoria = '';
                                  _categoriaController.clear();
                                  idItemCategoria = '';
                                  _itemCatController.clear();

                                  provider.setData('', '');

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

  void _seleccionarEstadoInspeccion(BuildContext context) {
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
                            itemCount: estadoItems.length,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  _estadoController.text = estadoItems[index];

                                  switch (estadoItems[index]) {
                                    case 'Atendido':
                                      _estado = '1';
                                      break;
                                    case 'Informe Pendiente de Aprobación':
                                      _estado = '2';
                                      break;
                                    case 'Diagnosticado':
                                      _estado = '3';
                                      break;
                                    case 'En proceso de Atención':
                                      _estado = '4';
                                      break;
                                    case 'Sin Atender':
                                      _estado = '5';
                                      break;
                                    case 'Anulado':
                                      _estado = '6';
                                      break;
                                    default:
                                      _estado = '';
                                      break;
                                  }

                                  Navigator.pop(context);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(estadoItems[index]),
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

  void _seleccionarCategorias(BuildContext context) {
    final categoriasBloc = ProviderBloc.mantenimientoCorrectivo(context);
    categoriasBloc.getCategorias(_tipoVeh);
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

  _selectdate(BuildContext context, TextEditingController date) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().month - 1),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    date.text = "${picked!.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
  }
}
