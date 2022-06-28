import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Residuo%20Solido/ejecucion_servicio_api.dart';
import 'package:new_brunner_app/src/bloc/ejecucion_servicio_bloc.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Empresa/tipo_doc_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/actividades_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/codigos_ue_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/contactos_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/lugares_oe_model.dart';
import 'package:new_brunner_app/src/page/Residuos%20Solidos/Ejecucion%20Servicios/Generar%20OES/generar_orden_ejecucion_servicio.dart';
import 'package:new_brunner_app/src/page/Residuos%20Solidos/Ejecucion%20Servicios/Generar%20OES/select_actividades_contractuales.dart';
import 'package:new_brunner_app/src/page/search_clientes.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';
import 'package:new_brunner_app/src/widget/text_field.dart';

class ResultOE extends StatefulWidget {
  const ResultOE({Key? key, required this.idEmpresa, required this.idDepartamento, required this.idSede}) : super(key: key);

  final String idEmpresa;
  final String idDepartamento;
  final String idSede;

  @override
  State<ResultOE> createState() => _ResultOEState();
}

class _ResultOEState extends State<ResultOE> {
  final _clienteController = TextEditingController();
  final _codigoController = TextEditingController();
  final _lugarController = TextEditingController();
  final _condicionController = TextEditingController();
  final _responsableController = TextEditingController();
  final _contactoController = TextEditingController();
  final _actividadesController = TextEditingController();

  final _descripcionController = TextEditingController();
  final _fechaController = TextEditingController();
  final _cipResponsableController = TextEditingController();
  final _telefonoContactoController = TextEditingController();
  final _emailContactoController = TextEditingController();

  //String para los ID
  String idCliente = '';
  String idCod = '';
  String idLugar = '';
  String idCondicion = '';
  String idResponsable = '';
  String idContacto = '';

  //List
  List<String> itemsCondicion = ['FLEXIBLE', 'NO FLEXIBLE'];

  //Controllador de Actividades
  final _controller = ControllerActividades();

  //Guardar ListaTipo Doc
  List<TipoDocModel> listTipos = [];

  void clearControllers() {
    _codigoController.clear();
    _lugarController.clear();
    _responsableController.clear();
    _contactoController.clear();
    _actividadesController.clear();
    _descripcionController.clear();
    _fechaController.clear();
    _cipResponsableController.clear();
    _telefonoContactoController.clear();
    _emailContactoController.clear();

    idCod = '';
    idLugar = '';
    idResponsable = '';
    idContacto = '';
    _controller.clearActividades();
  }

  @override
  void initState() {
    _condicionController.text = itemsCondicion[0];
    idCondicion = '0';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ejecucionServicioBloc = ProviderBloc.ejecucionServicio(context);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
            child: Column(
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                TextFieldSelect(
                  label: 'Cliente',
                  hingText: 'Seleccionar',
                  controller: _clienteController,
                  widget: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.green,
                  ),
                  icon: true,
                  readOnly: true,
                  ontap: () {
                    FocusScope.of(context).unfocus();
                    ejecucionServicioBloc.sarchClientesByQuery('', '${widget.idEmpresa}${widget.idDepartamento}${widget.idSede}');
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ClienteSearch(
                            id: '${widget.idEmpresa}${widget.idDepartamento}${widget.idSede}',
                            onChanged: (cliente) {
                              idCliente = cliente.idCliente.toString();
                              _clienteController.text = cliente.nombreCliente ?? '';
                              clearControllers();
                            },
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
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                TextFieldSelect(
                  label: 'Codigo Contractual',
                  hingText: 'Seleccione',
                  controller: _codigoController,
                  widget: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.green,
                  ),
                  icon: true,
                  readOnly: true,
                  ontap: () {
                    FocusScope.of(context).unfocus();
                    if (idCliente != '') {
                      _seleccionar(context, ejecucionServicioBloc, 'Seleccionar', _streamCodigos);
                    }
                  },
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                TextFieldSelect(
                  label: 'Lugar de Ejecución',
                  hingText: 'Seleccione',
                  controller: _lugarController,
                  widget: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.green,
                  ),
                  icon: true,
                  readOnly: true,
                  ontap: () {
                    FocusScope.of(context).unfocus();
                    if (idCod != '') {
                      _seleccionar(context, ejecucionServicioBloc, 'Seleccionar', _streamLugares);
                    }
                  },
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                TextFieldSelect(
                  label: 'Condición',
                  hingText: 'Seleccione',
                  controller: _condicionController,
                  widget: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.green,
                  ),
                  icon: true,
                  readOnly: true,
                  ontap: () {
                    FocusScope.of(context).unfocus();
                    _condicion(context);
                  },
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                TextFieldSelect(
                  label: 'Descripción General del Servicio',
                  hingText: '',
                  controller: _descripcionController,
                  widget: Icon(
                    Icons.edit_outlined,
                    color: Colors.green,
                  ),
                  icon: true,
                  readOnly: false,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                TextFieldSelect(
                  label: 'Fecha del Servicio',
                  hingText: '',
                  controller: _fechaController,
                  widget: Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.green,
                  ),
                  icon: true,
                  readOnly: true,
                  ontap: () {
                    FocusScope.of(context).unfocus();
                    selectdate(context, _fechaController);
                  },
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                TextFieldSelect(
                  label: 'Responsable Técnico',
                  hingText: 'Seleccione',
                  controller: _responsableController,
                  widget: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.green,
                  ),
                  icon: true,
                  readOnly: true,
                  ontap: () {
                    FocusScope.of(context).unfocus();
                    if (idCliente != '') {
                      _seleccionar(context, ejecucionServicioBloc, 'Seleccionar', _streamResponsable);
                    }
                  },
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                TextFieldSelect(
                  label: 'CIP Responsable Técnico',
                  hingText: '',
                  controller: _cipResponsableController,
                  icon: false,
                  readOnly: false,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                TextFieldSelect(
                  label: 'Personal de Contacto',
                  hingText: 'Seleccione',
                  controller: _contactoController,
                  widget: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.green,
                  ),
                  icon: true,
                  readOnly: true,
                  ontap: () {
                    FocusScope.of(context).unfocus();
                    if (idCliente != '') {
                      _seleccionar(context, ejecucionServicioBloc, 'Seleccionar', _streamContacto);
                    }
                  },
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                TextFieldSelect(
                  label: 'Teléfono de Contacto',
                  hingText: '',
                  controller: _telefonoContactoController,
                  icon: false,
                  readOnly: false,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                TextFieldSelect(
                  label: 'Email de Contacto',
                  hingText: '',
                  controller: _emailContactoController,
                  icon: false,
                  readOnly: false,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Divider(),
                Text(
                  'Actividades Contractuales',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, t) {
                    return Column(
                      children: _controller.actividades.asMap().entries.map((item) {
                        int idx = item.key;
                        return actividadItem(item.value, idx + 1);
                      }).toList(),
                    );
                  },
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                TextFieldSelect(
                  label: 'Actividades Contractuales',
                  hingText: 'Seleccione',
                  controller: _actividadesController,
                  widget: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.green,
                  ),
                  icon: true,
                  readOnly: true,
                  ontap: () {
                    FocusScope.of(context).unfocus();
                    if (idCod != '') {
                      ejecucionServicioBloc.searchActividadesContractualesQuery('', idCod);
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return ActividadesContractualesSelect(
                              idPeriodo: idCod,
                              onChanged: (actividad) {
                                _controller.saveActividad(actividad);
                              },
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
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Divider(),
                StreamBuilder<List<TipoDocModel>>(
                    stream: ejecucionServicioBloc.tipoDocStream,
                    builder: (_, data) {
                      if (!data.hasData || data.data!.isEmpty) {
                        return Container();
                      }

                      listTipos = data.data!;
                      return Column(
                        children: [
                          Text(
                            'Tipo de Documento',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(16),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(10),
                          ),
                          Column(
                            children: data.data!
                                .map(
                                  (e) => tipoDoc(e),
                                )
                                .toList(),
                          ),
                        ],
                      );
                    }),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        ejecucionServicioBloc.getDataFiltro();
                        ejecucionServicioBloc.clearData();
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return const GenerarOrdenEjecucionServicio();
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(100),
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.redAccent,
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
                            'Regresar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(15),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        _controller.changeCargando(true);
                        if (idCliente != '') {
                          if (idCod != '') {
                            if (idLugar != '') {
                              if (idCod != '') {
                                if (_descripcionController.text.isNotEmpty) {
                                  if (_fechaController.text.isNotEmpty) {
                                    if (_responsableController.text.isNotEmpty) {
                                      if (_cipResponsableController.text.isNotEmpty) {
                                        String contenido = '';

                                        for (var i = 0; i < _controller.actividades.length; i++) {
                                          contenido +=
                                              '${_controller.actividades[i].idDetallePeriodo}-.-.${_controller.actividades[i].nombreActividad}-.-.${_controller.actividades[i].umDetallePeriodo}-.-.${_controller.actividades[i].cantDetallePeriodo}/./.';
                                        }

                                        if (contenido != '') {
                                          String tipoDoc = '';

                                          for (var i = 0; i < listTipos.length; i++) {
                                            if (listTipos[i].valueCheck == '1') {
                                              tipoDoc += '${listTipos[i].idTipoDoc}//';
                                            }
                                          }

                                          if (tipoDoc != '') {
                                            final _api = EjecucionServicioApi();
                                            final enviar = ModelGenerarOE();
                                            enviar.idEmpresa = widget.idEmpresa;
                                            enviar.idDepartamento = widget.idDepartamento;
                                            enviar.idSede = widget.idSede;
                                            enviar.observaciones = _descripcionController.text;
                                            enviar.responsable = _responsableController.text;
                                            enviar.responsableCIP = _cipResponsableController.text;
                                            enviar.contacto = _contactoController.text;
                                            enviar.contactoTelefono = _telefonoContactoController.text;
                                            enviar.contactoEmail = _emailContactoController.text;
                                            enviar.idLugar = idLugar;
                                            enviar.condicion = idCondicion;
                                            enviar.fecha = _fechaController.text;
                                            enviar.contenido = contenido;
                                            enviar.documento = tipoDoc;

                                            final res = await _api.saveOrdenEjecuion(enviar);

                                            if (res == 1) {
                                              showToast2('Orden de Ejecución Generada', Colors.green);
                                              Navigator.pop(context);
                                            } else {
                                              showToast2('Ocurrió un error, inténtelo nuevamente', Colors.redAccent);
                                            }
                                          } else {
                                            showToast2('Debe seleccionar por lo menos un Tipo de Documento para continuar', Colors.redAccent);
                                          }
                                        } else {
                                          showToast2('Debe seleccionar por lo menos una Actividad Contractual para continuar', Colors.redAccent);
                                        }
                                      } else {
                                        showToast2('Debe ingresar en número de CIP para continuar', Colors.redAccent);
                                      }
                                    } else {
                                      showToast2('Debe seleccionar una Responsable Técnico para continuar', Colors.redAccent);
                                    }
                                  } else {
                                    showToast2('Debe ingresar una fecha para continuar', Colors.redAccent);
                                  }
                                } else {
                                  showToast2('Debe ingresar una descripción para continuar', Colors.redAccent);
                                }
                              } else {
                                showToast2('Debe seleccionar una Condición para continuar', Colors.redAccent);
                              }
                            } else {
                              showToast2('Debe seleccionar un Lugar de Ejecución para continuar', Colors.redAccent);
                            }
                          } else {
                            showToast2('Debe seleccionar un Codigo Contractual para continuar', Colors.redAccent);
                          }
                        } else {
                          showToast2('Debe seleccionar un Cliente para continuar', Colors.redAccent);
                        }
                        _controller.changeCargando(false);
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(120),
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
                            'Generar',
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
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
              ],
            ),
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

  Widget tipoDoc(TipoDocModel tipo) {
    return Row(
      children: [
        Expanded(child: Text(tipo.nombre ?? '')),
        IconButton(
          onPressed: () {
            final ejecucionServicioBloc = ProviderBloc.ejecucionServicio(context);
            ejecucionServicioBloc.changeSelectTipoDoc(tipo.idTipoDoc.toString(), (tipo.valueCheck == '1') ? '0' : '1');
          },
          icon: Icon((tipo.valueCheck == '1') ? Icons.check_box_rounded : Icons.check_box_outline_blank),
          color: Colors.green,
        ),
      ],
    );
  }

  Widget actividadItem(ActividadesOEModel actividad, int index) {
    return Row(
      children: [
        Text(index.toString()),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10), vertical: ScreenUtil().setHeight(5)),
            padding: EdgeInsets.all(8),
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
            child: Column(
              children: [
                Text("${actividad.nombreActividad ?? ''} ${actividad.descripcionDetallePeriodo ?? ''}"),
                SizedBox(height: ScreenUtil().setHeight(8)),
                RichText(
                  text: TextSpan(
                    text: actividad.cantDetallePeriodo,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(17),
                    ),
                    children: [
                      TextSpan(
                        text: ' ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                      TextSpan(
                        text: actividad.umDetallePeriodo,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            _controller.removeActividad(actividad.idDetallePeriodo.toString());
          },
          icon: Icon(
            Icons.close,
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }

  void _seleccionar(
      BuildContext context, EjecucionServicioBloc bloc, String titulo, Widget stream(EjecucionServicioBloc stream, ScrollController controller)) {
    bloc.getDataSelec(idCliente);
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

  Widget _streamCodigos(EjecucionServicioBloc stream, ScrollController controller) {
    return StreamBuilder<List<CodigosOEModel>>(
      stream: stream.codigosStream,
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
                _codigoController.text = item.periodoCod.toString().trim();
                idCod = item.idCod.toString().trim();

                _lugarController.clear();
                idLugar = '';
                _controller.clearActividades();
                stream.getDataByidPeriodo(idCod);

                Navigator.pop(context);
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(item.periodoCod.toString().trim()),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _streamLugares(EjecucionServicioBloc stream, ScrollController controller) {
    return StreamBuilder<List<LugaresOEModel>>(
      stream: stream.lugaresStream,
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
                _lugarController.text = item.establecimientoLugar.toString().trim();
                idLugar = item.idLugar.toString().trim();

                Navigator.pop(context);
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(item.establecimientoLugar.toString().trim()),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _condicion(BuildContext context) {
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
                            itemCount: itemsCondicion.length,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  _condicionController.text = itemsCondicion[index];
                                  if (_condicionController.text == 'FLEXIBLE') {
                                    idCondicion = '1';
                                  } else if (_condicionController.text == 'NO FLEXIBLE') {
                                    idCondicion = '0';
                                  } else {
                                    idCondicion = '0';
                                  }

                                  Navigator.pop(context);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      itemsCondicion[index],
                                      style: TextStyle(
                                        color: (itemsCondicion[index] == 'FLEXIBLE') ? Colors.green : Colors.red,
                                      ),
                                    ),
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

  Widget _streamResponsable(EjecucionServicioBloc stream, ScrollController controller) {
    return StreamBuilder<List<ContactosOEModel>>(
      stream: stream.contactosStream,
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
                _responsableController.text = item.contactoCliente.toString().trim();
                idContacto = item.idContacto.toString().trim();
                if (item.cipCliente != '000') {
                  _cipResponsableController.text = item.cipCliente ?? '';
                } else {
                  _cipResponsableController.text = '';
                }

                Navigator.pop(context);
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(item.contactoCliente.toString().trim()),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _streamContacto(EjecucionServicioBloc stream, ScrollController controller) {
    return StreamBuilder<List<ContactosOEModel>>(
      stream: stream.contactosStream,
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
                _contactoController.text = item.contactoCliente.toString().trim();
                idContacto = item.idContacto.toString().trim();

                _telefonoContactoController.text = item.telefonoCliente ?? '';
                _emailContactoController.text = item.emailCliente ?? '';

                Navigator.pop(context);
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(item.contactoCliente.toString().trim()),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ControllerActividades extends ChangeNotifier {
  List<ActividadesOEModel> actividades = [];
  bool cargando = false;
  bool td1 = false, td2 = false, td3 = false, td4 = false, td5 = false, td6 = false;

  void saveActividad(ActividadesOEModel item) {
    actividades.removeWhere((element) => element.idDetallePeriodo == item.idDetallePeriodo);
    actividades.add(item);
    notifyListeners();
  }

  void removeActividad(String id) {
    actividades.removeWhere((item) => item.idDetallePeriodo == id);
    notifyListeners();
  }

  void clearActividades() {
    actividades.clear();
    notifyListeners();
  }

  void activeTipoDoc(int tipo, bool data) {
    switch (tipo) {
      case 1:
        td1 = data;
        break;
      case 2:
        td2 = data;
        break;
      case 3:
        td3 = data;
        break;
      case 4:
        td4 = data;
        break;
      case 5:
        td5 = data;
        break;
      case 6:
        td6 = data;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void changeCargando(bool b) {
    cargando = b;
    notifyListeners();
  }
}
