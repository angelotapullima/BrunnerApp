import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/Check%20List/check_list.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/Consulta%20Informacion/resultados_consulta.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/choferes_search.dart';
import 'package:provider/provider.dart';

class ConsultaInformacion extends StatefulWidget {
  const ConsultaInformacion({Key? key}) : super(key: key);

  @override
  State<ConsultaInformacion> createState() => _ConsultaInformacionState();
}

class _ConsultaInformacionState extends State<ConsultaInformacion> {
  final _placaUnidad = TextEditingController();
  final _operario = TextEditingController();
  final _fechaInicio = TextEditingController();
  final _fechaFin = TextEditingController();
  final _nroCheck = TextEditingController();
  final _tipo = TextEditingController();

  String _estado = '';
  List<String> spinnerItems = ['Todos', 'Unidades habilitadas', 'Unidades habilitadas con restricciones', 'Unidades inhabilitadas'];
  int count = 0;

  @override
  void dispose() {
    _placaUnidad.dispose();
    _fechaInicio.dispose();
    _fechaFin.dispose();
    _nroCheck.dispose();
    _tipo.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tipo.text = 'Todos';
    _estado = '';
    var data =
        "${DateTime.now().year.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
    _fechaInicio.text = data;
    _fechaFin.text = data;
    Future.delayed(const Duration(microseconds: 100), () async {
      filtroSearch();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final consultaInspBloc = ProviderBloc.consultaInsp(context);

    return WillPopScope(
      onWillPop: () async {
        final consultaInspBloc = ProviderBloc.consultaInsp(context);
        consultaInspBloc.limpiarSearch();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Listar reportes generados',
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
          stream: consultaInspBloc.cargandoStream,
          builder: (context, cargando) {
            if (!cargando.hasData || cargando.data!) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            return StreamBuilder<List<InspeccionVehiculoModel>>(
              stream: consultaInspBloc.inspeccionesStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ResultadosConsulta(
                      inspecciones: snapshot.data!,
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
    final provider = Provider.of<ConductorController>(context, listen: false);
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
                initialChildSize: 0.8,
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
                              height: ScreenUtil().setHeight(20),
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
                              controller: _placaUnidad,
                              style: const TextStyle(
                                color: Color(0xff808080),
                              ),
                              decoration: InputDecoration(
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
                                labelText: 'Placa de la Unidad o Marca',
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            ValueListenableBuilder(
                              valueListenable: provider.conductorS,
                              builder: (BuildContext context, String data, Widget? child) {
                                if (data != 'Seleccionar') {
                                  _operario.text = data;
                                }
                                return TextField(
                                  readOnly: true,
                                  controller: _operario,
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
                                          return const ChoferesSearch(
                                            page: 'Consulta',
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
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: const Icon(
                                      Icons.person_outline,
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
                                    labelText: 'Nombre del operario',
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            TextField(
                              controller: _tipo,
                              maxLines: null,
                              readOnly: true,
                              style: const TextStyle(
                                color: Color(0xff808080),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                _bottomShetTipe(context);
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
                                hintText: '_Estado de la unidad',
                                hintStyle: const TextStyle(
                                  color: Color(0xff808080),
                                ),
                                labelText: '_Estado de la unidad',
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
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
                              height: ScreenUtil().setHeight(20),
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
                              height: ScreenUtil().setHeight(20),
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
                              height: ScreenUtil().setHeight(20),
                            ),
                            InkWell(
                              onTap: () async {
                                final consultaInspBloc = ProviderBloc.consultaInsp(context);
                                final provider = Provider.of<ConductorController>(context, listen: false);
                                consultaInspBloc.getInspeccionesVehiculo(_fechaInicio.text.trim(), _fechaFin.text.trim(), _placaUnidad.text.trim(),
                                    provider.idS.value.trim(), _estado.trim(), _nroCheck.text.trim());
                                Navigator.pop(context);
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

  void _bottomShetTipe(BuildContext context) {
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
                          'Seleccionar Tipo',
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
                            itemCount: spinnerItems.length,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  _tipo.text = spinnerItems[index];
                                  if (_tipo.text == 'Unidades habilitadas') {
                                    _estado = '1';
                                  } else if (_tipo.text == 'Unidades habilitadas con restricciones') {
                                    _estado = '2';
                                  } else if (_tipo.text == 'Unidades inhabilitadas') {
                                    _estado = '3';
                                  } else {
                                    _estado = '';
                                  }

                                  Navigator.pop(context);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(spinnerItems[index]),
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
