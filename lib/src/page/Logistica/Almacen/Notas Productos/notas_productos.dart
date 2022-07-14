import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/ejecucion_servicio_bloc.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Empresa/sede_model.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/Notas%20Productos/ingreso.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/Notas%20Productos/salida.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';
import 'package:new_brunner_app/src/widget/text_field.dart';

class NotasProductos extends StatefulWidget {
  const NotasProductos({Key? key}) : super(key: key);

  @override
  State<NotasProductos> createState() => _NotasProductosState();
}

class _NotasProductosState extends State<NotasProductos> {
  final _sedeController = TextEditingController();
  final _tipoController = TextEditingController();

  String idSede = '';
  String idTipo = '';

  final tipoRegistro = [
    {'id': '1', 'name': 'Ingreso'},
    {'id': '2', 'name': 'Salida'},
  ];

  @override
  void initState() {
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
        backgroundColor: Color(0XFF148F77),
        title: Text(
          'Notas de Productos',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(14),
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
        stream: almacenBloc.respStream,
        builder: (_, c) {
          if (c.hasData && c.data! != 10) {
            if (c.data! == 1) {
              return (idTipo == '1')
                  ? Ingreso(
                      idSede: idSede,
                    )
                  : Salida(
                      idSede: idSede,
                    );
            } else {
              if (c.data! == 100) {
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
    final ejecucionServicioBloc = ProviderBloc.ejecucionServicio(context);
    ejecucionServicioBloc.getDataFiltro();
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
                              'Registro de Productos:',
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
                              hingText: 'Seleccionar',
                              controller: _sedeController,
                              widget: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                _seleccionar(context, ejecucionServicioBloc, 'Seleccionar', _streamSede);
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
                                _selectTipo();
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            InkWell(
                              onTap: () async {
                                if (idSede != '') {
                                  if (idTipo != '') {
                                    final almacenBloc = ProviderBloc.almacen(context);

                                    if (idTipo == '1') {
                                      almacenBloc.updateResp(1);
                                    } else {
                                      almacenBloc.getDataSalidaAlmacen(idSede);
                                    }

                                    Navigator.pop(context);
                                  } else {
                                    showToast2('Debe seleccionar un tipo de registro', Colors.redAccent);
                                  }
                                } else {
                                  showToast2('Debe seleccionar una sede', Colors.redAccent);
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

  void _seleccionar(
      BuildContext context, EjecucionServicioBloc bloc, String titulo, Widget stream(EjecucionServicioBloc stream, ScrollController controller)) {
    final ejecucionServicioBloc = ProviderBloc.ejecucionServicio(context);
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
                          child: stream(ejecucionServicioBloc, controller),
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

  void _selectTipo() {
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
                            itemCount: tipoRegistro.length,
                            itemBuilder: (_, index) {
                              var item = tipoRegistro[index];
                              return InkWell(
                                onTap: () {
                                  _tipoController.text = item["name"].toString();
                                  idTipo = item["id"].toString();

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
