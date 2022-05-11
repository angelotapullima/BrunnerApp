import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Check%20List/check_list.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/choferes_search.dart';
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

  String idTipo = '';
  List<String> spinnerItems = ['Todos', 'Unidades habilitadas', 'Unidaddes habilitadas con restricciones', 'Unidades inhabilitadas'];
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
    idTipo = 'Todos';
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
    if (count == 0) {
      count++;
    }
    return Scaffold(
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
      body: Column(
        children: [],
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
                                hintText: 'Estado de la unidad',
                                hintStyle: const TextStyle(
                                  color: Color(0xff808080),
                                ),
                                labelText: 'Estado de la unidad',
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
                                // if (_fechaInicio.text.isNotEmpty) {
                                //   if (_fechaFin.text.isNotEmpty) {
                                //     final solicitudesBloc = ProviderBloc.solicitudesReserva(context);
                                //     solicitudesBloc.getBusquedaSolicitudes(_fechaInicio.text, _fechaFin.text, idTipo);
                                //     Navigator.pop(context);
                                //   } else {
                                //     showToast2('Por favor, igresar fecha final', Colors.red);
                                //   }
                                // } else {
                                //   showToast2('Por favor, igresar fecha inicial', Colors.red);
                                // }
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
                                  if (_tipo.text == 'PLIN') {
                                    idTipo = '1';
                                  } else if (_tipo.text == 'YAPE') {
                                    idTipo = '2';
                                  } else if (_tipo.text == 'TARJETA') {
                                    idTipo = '3';
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
