import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/ejecucion_servicio_bloc.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Empresa/sede_model.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/Consulta%20Informacion/result_generadas.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/Consulta%20Informacion/result_pendientes.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';
import 'package:new_brunner_app/src/widget/text_field.dart';

class OrdenGeneradas extends StatefulWidget {
  const OrdenGeneradas({Key? key}) : super(key: key);

  @override
  State<OrdenGeneradas> createState() => _OrdenGeneradasState();
}

class _OrdenGeneradasState extends State<OrdenGeneradas> {
  final _sedeController = TextEditingController();
  final _tipoController = TextEditingController();
  final _entregaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _inicioController = TextEditingController();
  final _finController = TextEditingController();

  String idSede = '';
  String idTipo = '';
  String idEntrega = '2';

  final tipoRegistro = [
    {'id': '', 'name': 'TODOS'},
    {'id': 'I', 'name': 'Ingreso'},
    {'id': 'S', 'name': 'Salida'},
  ];

  final tipoEntrega = [
    {'id': '2', 'name': 'TODOS'},
    {'id': '0', 'name': 'NO ENTREGADO'},
    {'id': '1', 'name': 'ENTREGADO'},
  ];

  @override
  void initState() {
    _sedeController.text = 'TODAS LAS SEDES';
    _tipoController.text = 'TODOS';
    _entregaController.text = 'TODOS';
    DateTime fechaInit = DateTime.now().subtract(const Duration(days: 30));
    var dataInicio =
        "${fechaInit.year.toString().padLeft(2, '0')}-${fechaInit.month.toString().padLeft(2, '0')}-${fechaInit.day.toString().padLeft(2, '0')}";
    var dataFin =
        "${DateTime.now().year.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
    _inicioController.text = dataInicio;
    _finController.text = dataFin;
    Future.delayed(const Duration(microseconds: 100), () async {
      filtroSearch();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final almacenBloc = ProviderBloc.almacen(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF154360),
        title: Text(
          'Listado de Registros de Almacén Generados',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(12),
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
      body: StreamBuilder<int>(
        stream: almacenBloc.respGeneradasStream,
        builder: (_, c) {
          if (c.hasData && c.data! != 10) {
            if (c.data! == 1) {
              return ResultGeneradas(
                idSede: idSede,
                tipo: idTipo,
                entrega: idEntrega,
                numero: _numeroController.text,
                inicio: _inicioController.text,
                fin: _finController.text,
              );
            } else {
              if (c.data! == 11) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          filtroSearch();
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
                );
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sin resultados, inténtelo nuevamente'),
                    InkWell(
                      onTap: () async {
                        filtroSearch();
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
              );
            }
          } else {
            return ShowLoadding(
              active: true,
              h: double.infinity,
              w: double.infinity,
              fondo: Colors.transparent,
              colorText: Colors.black,
            );
          }
        },
      ),
    );
  }

  void filtroSearch() {
    final notasPBloc = ProviderBloc.ejecucionServicio(context);
    notasPBloc.getDataFiltro();
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
                initialChildSize: 0.9,
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
                              label: 'Sede',
                              hingText: 'Seleccionar Sede',
                              controller: _sedeController,
                              widget: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                _seleccionar(context, notasPBloc, 'Seleccionar', _streamSede);
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(15),
                            ),
                            TextFieldSelect(
                              label: 'Tipo de Registro',
                              hingText: 'Seleccionar',
                              controller: _tipoController,
                              widget: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                _selectTipo(1);
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(15),
                            ),
                            TextFieldSelect(
                              label: 'Entrega',
                              hingText: 'Seleccionar',
                              controller: _entregaController,
                              widget: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                _selectTipo(2);
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(15),
                            ),
                            TextFieldSelect(
                              label: 'Número',
                              hingText: '',
                              controller: _numeroController,
                              widget: Icon(
                                Icons.numbers,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: false,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(15),
                            ),
                            TextFieldSelect(
                              label: 'Inicio',
                              hingText: '',
                              controller: _inicioController,
                              widget: Icon(
                                Icons.calendar_month,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                selectdate(context, _inicioController);
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(15),
                            ),
                            TextFieldSelect(
                              label: 'Término',
                              hingText: '',
                              controller: _finController,
                              widget: Icon(
                                Icons.calendar_month,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                selectdate(context, _finController);
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            InkWell(
                              onTap: () async {
                                final almacenBloc = ProviderBloc.almacen(context);
                                almacenBloc.getOrdenesGeneradas(
                                    idSede, idTipo, idEntrega, _numeroController.text, _inicioController.text, _finController.text);
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
                                    'Buscar ahora',
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

  void _seleccionar(BuildContext context, bloc, String titulo, Widget stream(EjecucionServicioBloc stream, ScrollController controller)) {
    final notasPBloc = ProviderBloc.ejecucionServicio(context);
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
                          titulo,
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
                          child: stream(notasPBloc, controller),
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

  Widget _streamSede(EjecucionServicioBloc stream, ScrollController controller) {
    return StreamBuilder<List<SedeModel>>(
      stream: stream.sedesStream,
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
                _sedeController.text = item.nombreSede.toString().trim();
                idSede = item.idSede.toString().trim();

                Navigator.pop(context);
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(item.nombreSede.toString().trim()),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _selectTipo(int tipo) {
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
                          'Seleccionar',
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
                            itemCount: tipo == 1 ? tipoRegistro.length : tipoEntrega.length,
                            itemBuilder: (_, index) {
                              var item = tipo == 1 ? tipoRegistro[index] : tipoEntrega[index];
                              return InkWell(
                                onTap: () {
                                  if (tipo == 1) {
                                    _tipoController.text = item["name"].toString();
                                    idTipo = item["id"].toString();
                                  } else {
                                    _entregaController.text = item["name"].toString();
                                    idEntrega = item["id"].toString();
                                  }

                                  Navigator.pop(context);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(item["name"].toString()),
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
