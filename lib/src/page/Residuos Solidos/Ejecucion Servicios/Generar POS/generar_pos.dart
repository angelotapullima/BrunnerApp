import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/pos_bloc.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Empresa/departamento_model.dart';
import 'package:new_brunner_app/src/model/Empresa/empresas_model.dart';
import 'package:new_brunner_app/src/model/Empresa/sede_model.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/text_field.dart';

class GenerarPOS extends StatefulWidget {
  const GenerarPOS({Key? key}) : super(key: key);

  @override
  State<GenerarPOS> createState() => _GenerarPOSState();
}

class _GenerarPOSState extends State<GenerarPOS> {
  final _empresaController = TextEditingController();
  final _unidadOperativaController = TextEditingController();
  final _sedeOperativaController = TextEditingController();
  final _fechaServicioController = TextEditingController();
  final _fechaFinController = TextEditingController();

  String idEmpresa = '';
  String idDepartamento = '';
  String idSede = '';

  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 100), () async {
      filtroSearch();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Generar Parte Operativo del Servicio',
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
      // body: StreamBuilder<bool>(
      //   stream: posBloc.cargandoStream,
      //   builder: (_, c) {
      //     if (c.hasData && !c.data!) {
      //       return StreamBuilder<List<ClientesOEModel>?>(
      //         stream: posBloc.clientesStream,
      //         builder: (_, snapshot) {
      //           if (snapshot.hasData) {
      //             if (snapshot.data!.isNotEmpty) {
      //               return ResultOE(
      //                 idEmpresa: idEmpresa,
      //                 idDepartamento: idDepartamento,
      //                 idSede: idSede,
      //                 //id: '$idEmpresa$idDepartamento$idSede',
      //               );
      //             } else {
      //               return Padding(
      //                 padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Text('Sin datos encontrados, para los datos ingresados'),
      //                     InkWell(
      //                       onTap: () async {
      //                         filtroSearch();
      //                       },
      //                       child: Container(
      //                         width: double.infinity,
      //                         margin: const EdgeInsets.all(8),
      //                         padding: const EdgeInsets.all(8),
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(20),
      //                           color: Colors.green,
      //                           boxShadow: [
      //                             BoxShadow(
      //                               color: Colors.black.withOpacity(0.2),
      //                               spreadRadius: 3,
      //                               blurRadius: 8,
      //                               offset: const Offset(0, 3), // changes position of shadow
      //                             ),
      //                           ],
      //                         ),
      //                         child: Center(
      //                           child: Text(
      //                             'Buscar',
      //                             style: TextStyle(
      //                               color: Colors.white,
      //                               fontSize: ScreenUtil().setSp(20),
      //                               fontWeight: FontWeight.w600,
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               );
      //             }
      //           } else {
      //             return ShowLoadding(
      //               active: true,
      //               h: double.infinity,
      //               w: double.infinity,
      //               fondo: Colors.transparent,
      //               colorText: Colors.black,
      //             );
      //           }
      //         },
      //       );
      //     } else {
      //       return ShowLoadding(
      //         active: true,
      //         h: double.infinity,
      //         w: double.infinity,
      //         fondo: Colors.transparent,
      //         colorText: Colors.black,
      //       );
      //     }
      //   },
      // ),
    );
  }

  void filtroSearch() {
    final parteOperativoBloc = ProviderBloc.pos(context);
    parteOperativoBloc.getDataFiltro();
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
                              label: 'Empresa Contratante',
                              hingText: 'Seleccionar empresa',
                              controller: _empresaController,
                              widget: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                _seleccionar(context, parteOperativoBloc, 'Seleccionar empresa', _streamEmpresa);
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Unidad Operativa Ejecutora',
                              hingText: 'Seleccionar',
                              controller: _unidadOperativaController,
                              widget: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                _seleccionar(context, parteOperativoBloc, 'Seleccionar', _streamDepartamento);
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Sede Ejecutora',
                              hingText: 'Seleccionar',
                              controller: _sedeOperativaController,
                              widget: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                _seleccionar(context, parteOperativoBloc, 'Seleccionar', _streamSede);
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Fecha del Servicio',
                              hingText: '',
                              controller: _fechaServicioController,
                              widget: Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                selectdate(context, _fechaServicioController);
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Fecha Fin',
                              hingText: '',
                              controller: _fechaFinController,
                              widget: Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                selectdate(context, _fechaFinController);
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            InkWell(
                              onTap: () async {
                                if (idEmpresa != '' &&
                                    idDepartamento != '' &&
                                    idSede != '' &&
                                    _fechaServicioController.text.isNotEmpty &&
                                    _fechaFinController.text.isNotEmpty) {
                                  //parteOperativoBloc.getActividadesClientes(idEmpresa, idDepartamento, idSede);
                                  //Navigator.pop(context);
                                } else {
                                  showToast2('Seleccione los 5 filtros', Colors.redAccent);
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

  void _seleccionar(BuildContext context, POSBloc bloc, String titulo, Widget stream(POSBloc stream, ScrollController controller)) {
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
                          child: stream(bloc, controller),
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

  Widget _streamEmpresa(POSBloc stream, ScrollController controller) {
    return StreamBuilder<List<EmpresasModel>>(
      stream: stream.empresasStream,
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
                _empresaController.text = item.nombreEmpresa.toString().trim();
                idEmpresa = item.idEmpresa.toString().trim();

                Navigator.pop(context);
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(item.nombreEmpresa.toString().trim()),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _streamDepartamento(POSBloc stream, ScrollController controller) {
    return StreamBuilder<List<DepartamentoModel>>(
      stream: stream.departamentosStream,
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
                _unidadOperativaController.text = item.nombreDepartamento.toString().trim();
                idDepartamento = item.idDepartamento.toString().trim();

                Navigator.pop(context);
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(item.nombreDepartamento.toString().trim()),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _streamSede(POSBloc stream, ScrollController controller) {
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
                _sedeOperativaController.text = item.nombreSede.toString().trim();
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
}
