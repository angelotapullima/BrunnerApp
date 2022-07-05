import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Residuo%20Solido/pos_api.dart';

import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/clientes_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/orden_ejecucion_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/personal_oe_model.dart';
import 'package:new_brunner_app/src/page/Residuos%20Solidos/Ejecucion%20Servicios/Consulta%20Info%20OE/POS/pendientes_pos.dart';
import 'package:new_brunner_app/src/page/Residuos%20Solidos/Ejecucion%20Servicios/Generar%20POS/generar_pos.dart';
import 'package:new_brunner_app/src/page/Residuos%20Solidos/Ejecucion%20Servicios/Generar%20POS/search_oe.dart';
import 'package:new_brunner_app/src/page/Residuos%20Solidos/Ejecucion%20Servicios/Generar%20POS/search_personal.dart';
import 'package:new_brunner_app/src/page/Residuos%20Solidos/Ejecucion%20Servicios/Generar%20POS/search_unidad_oe.dart';
import 'package:new_brunner_app/src/page/search_clientes.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';
import 'package:new_brunner_app/src/widget/text_field.dart';

class ResultPOS extends StatefulWidget {
  const ResultPOS(
      {Key? key, required this.idEmpresa, required this.idDepartamento, required this.idSede, required this.fechaIncio, required this.fechaFin})
      : super(key: key);
  final String idEmpresa;
  final String idDepartamento;
  final String idSede;
  final String fechaIncio;
  final String fechaFin;

  @override
  State<ResultPOS> createState() => _ResultPOSState();
}

class _ResultPOSState extends State<ResultPOS> {
  final _personalController = TextEditingController();
  final _clienteController = TextEditingController();
  final _unidadController = TextEditingController();
  final _condicionesController = TextEditingController();
  String idUnidad = '';
  final _controller = POSController();
  @override
  Widget build(BuildContext context) {
    final posBloc = ProviderBloc.pos(context);
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
                  label: 'Unidad',
                  hingText: 'Seleccionar',
                  controller: _unidadController,
                  widget: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.green,
                  ),
                  icon: true,
                  readOnly: true,
                  ontap: () {
                    FocusScope.of(context).unfocus();
                    posBloc.searchUnidades('${widget.idEmpresa}${widget.idDepartamento}${widget.idSede}', '');
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return UnidadSearch(
                            id: '${widget.idEmpresa}${widget.idDepartamento}${widget.idSede}',
                            onChanged: (unidad) {
                              idUnidad = unidad.idVehiculo.toString();
                              _unidadController.text = unidad.placaVehiculo ?? '';
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
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, f) {
                    return (_controller.oes.isEmpty)
                        ? Text(
                            'INFORMACIÓN DEL CLIENTE',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        : ExpansionTile(
                            initiallyExpanded: true,
                            maintainState: true,
                            title: Text(
                              'INFORMACIÓN DEL CLIENTE',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            children: _controller.oes.map((item) => _oeAgregada(item)).toList(),
                          );
                  },
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
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
                    final clientesSearch = ProviderBloc.searchClientes(context);
                    clientesSearch.sarchClientesByQuery('', '${widget.idEmpresa}${widget.idDepartamento}${widget.idSede}');
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ClienteSearch(
                            id: '${widget.idEmpresa}${widget.idDepartamento}${widget.idSede}',
                            onChanged: (cliente) {
                              saveClienteOE(cliente);
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
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, f) {
                    return (_controller.personal.isEmpty)
                        ? Text(
                            'INFORMACIÓN DEL PERSONAL',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        : ExpansionTile(
                            initiallyExpanded: true,
                            maintainState: true,
                            title: Text(
                              'INFORMACIÓN DEL PERSONAL',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            children: _controller.personal.map((item) => _personaAgregada(item)).toList(),
                          );
                  },
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                TextFieldSelect(
                  label: 'Personal',
                  hingText: 'Seleccionar',
                  controller: _personalController,
                  widget: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.green,
                  ),
                  icon: true,
                  readOnly: true,
                  ontap: () {
                    FocusScope.of(context).unfocus();
                    posBloc.searchPersonal('${widget.idEmpresa}${widget.idDepartamento}${widget.idSede}', '');
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return PersonalSearch(
                            id: '${widget.idEmpresa}${widget.idDepartamento}${widget.idSede}',
                            onChanged: (persona) {
                              savePersonalOE(persona);
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
                  height: ScreenUtil().setHeight(10),
                ),
                Divider(),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Row(
                  children: [
                    Text(
                      'CONDICIONES ESPECIALES / OBSERVACIONES',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                TextFieldSelect(
                  label: '',
                  hingText: '',
                  controller: _condicionesController,
                  widget: Icon(
                    Icons.edit,
                    color: Colors.green,
                  ),
                  icon: true,
                  readOnly: false,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                InkWell(
                  onTap: () async {
                    if (idUnidad != '') {
                      if (_controller.oes.isNotEmpty) {
                        if (_controller.personal.isNotEmpty) {
                          String clientes = '';
                          String personal = '';
                          for (var i = 0; i < _controller.oes.length; i++) {
                            var oe = _controller.oes[i];
                            clientes +=
                                '${oe.oe!.idOE}-.-.${oe.oe!.numeroOE}-.-.${oe.idCliente}-.-.${oe.nombreCliente}-.-.${oe.oe!.codigoPeriodo}-.-.${oe.oe!.fechaPeriodo}-.-.${oe.oe?.lugarPeriodo ?? oe.oe?.clienteLugar}-.-.${oe.logoCliente}-.-.${oe.descripcion}/./.';
                          }

                          for (var i = 0; i < _controller.personal.length; i++) {
                            var per = _controller.personal[i];
                            personal +=
                                '${per.idPersona}-.-.${per.nombre}-.-.${per.cargo}-.-.${per.idCargo}-.-.${per.dni}-.-.${per.fechaPeriodo}-.-.${per.image}-.-.${per.valueAsistencia}-.-.${per.asistenciaProyectada}/./.';
                          }
                          _controller.changeCargando(true);
                          final _api = POSApi();
                          final res = await _api.saverPOS(widget.idEmpresa, widget.idDepartamento, widget.idSede, widget.fechaIncio, widget.fechaFin,
                              idUnidad, _condicionesController.text, clientes, personal);
                          if (res == 1) {
                            showToast2('POS generado correctamente', Colors.green);
                            Navigator.pop(context);
                            final _consultaOEBloc = ProviderBloc.consultaOE(context);
                            _consultaOEBloc.getPOSPendientes();
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  return const PendientesPOS();
                                },
                              ),
                            );
                          } else if (res == 200) {
                            showToast2('Problemas con la conexión, Inténtelo nuevamente', Colors.redAccent);
                          } else {
                            showToast2('Ocurrió un error, Inténtelo nuevamente', Colors.redAccent);
                          }
                          _controller.changeCargando(false);
                        } else {
                          showToast2('Debe seleccionar por lo menos a un personal', Colors.redAccent);
                        }
                      } else {
                        showToast2('Debe seleccionar por lo menos un cliente', Colors.redAccent);
                      }
                    } else {
                      showToast2('Debe seleccionar una unidad', Colors.redAccent);
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
                        'Guardar',
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
                  height: ScreenUtil().setHeight(5),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    posBloc.getDataFiltro();
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const GenerarPOS();
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
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        'Regresar',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: ScreenUtil().setSp(20),
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

  Widget _oeAgregada(ClientesOEModel item) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        _controller.removeOE(item.oe!.idOE.toString());
      },
      background: Container(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(16)),
        color: Colors.redAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(
              Icons.close,
              color: Colors.white,
            ),
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(16),
          vertical: ScreenUtil().setHeight(10),
        ),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              padding: EdgeInsets.all(8),
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
                  Container(
                    margin: EdgeInsets.all(10),
                    width: ScreenUtil().setWidth(60),
                    height: ScreenUtil().setHeight(60),
                    child: CachedNetworkImage(
                      imageUrl: '$apiBaseURL/${item.logoCliente}',
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                        child: const CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Icon(Icons.image),
                        ),
                      ),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${obtenerFecha(item.oe!.fechaPeriodo.toString())}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenUtil().setSp(10),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(5),
                        ),
                        fileData('Cliente', item.nombreCliente ?? '', 10, 12, FontWeight.w500, FontWeight.w500, TextAlign.start),
                        fileData('Lugar Ejecución', item.oe!.lugarPeriodo ?? item.oe!.clienteLugar ?? '', 10, 12, FontWeight.w600, FontWeight.w400,
                            TextAlign.start),
                        fileData('Descripción Particular', item.descripcion ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: ScreenUtil().setWidth(110),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    "OES: ${item.oe?.numeroOE ?? ''}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenUtil().setSp(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _personaAgregada(PersonalOEModel item) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        _controller.removePersonal(item.idPersona.toString());
      },
      background: Container(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(16)),
        color: Colors.redAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(
              Icons.close,
              color: Colors.white,
            ),
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(16),
          vertical: ScreenUtil().setHeight(10),
        ),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              padding: EdgeInsets.all(8),
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
                  Container(
                    margin: EdgeInsets.all(10),
                    width: ScreenUtil().setWidth(60),
                    height: ScreenUtil().setHeight(60),
                    child: CachedNetworkImage(
                      imageUrl: '$apiBaseURL/${item.image}',
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                        child: const CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Icon(Icons.image),
                        ),
                      ),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${obtenerFecha(item.fechaPeriodo.toString())}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenUtil().setSp(10),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(5),
                        ),
                        fileData('Nombre', item.nombre ?? '', 10, 12, FontWeight.w500, FontWeight.w500, TextAlign.start),
                        fileData(
                            'Cargo', "${item.cargo ?? ''}: ${item.detalleCargo ?? ''}", 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                        fileData('Asistencia', item.asistenciaProyectada ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: ScreenUtil().setWidth(110),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    "DNI: ${item.dni ?? ''}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenUtil().setSp(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveClienteOE(ClientesOEModel cliente) {
    final _clienteController = TextEditingController();
    final _oeController = TextEditingController();
    final _condigoContractualController = TextEditingController();
    final _fechaController = TextEditingController();
    final _lugarController = TextEditingController();
    final _descripcionController = TextEditingController();

    OrdenEjecucionModel? orden;

    final parteOperativoBloc = ProviderBloc.pos(context);
    parteOperativoBloc.searchOES(cliente.idCliente ?? '', '');
    _clienteController.text = cliente.nombreCliente ?? '';

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
                              'Agregar OES',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(18),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            TextFieldSelect(
                              label: 'Cliente',
                              hingText: '',
                              controller: _clienteController,
                              icon: false,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'OES',
                              hingText: 'Seleccionar',
                              controller: _oeController,
                              widget: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return OESearch(
                                        id: cliente.idCliente ?? '',
                                        onChanged: (oe) {
                                          orden = oe;
                                          _oeController.text = oe.numeroOE ?? '';
                                          _condigoContractualController.text = oe.codigoPeriodo ?? '';
                                          _fechaController.text = oe.fechaPeriodo ?? '';
                                          _lugarController.text = oe.lugarPeriodo ?? oe.clienteLugar ?? '';
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
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Codigo Contractual',
                              hingText: '',
                              controller: _condigoContractualController,
                              icon: false,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Fecha de Vigencia',
                              hingText: '',
                              controller: _fechaController,
                              widget: Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Lugar de Ejecución',
                              hingText: '',
                              controller: _lugarController,
                              icon: false,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Descripción Particular',
                              hingText: '',
                              controller: _descripcionController,
                              widget: Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: false,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            InkWell(
                              onTap: () {
                                if (orden?.idOE != null) {
                                  final client = ClientesOEModel();
                                  client.idCliente = cliente.idCliente;
                                  client.nombreCliente = cliente.nombreCliente;
                                  client.logoCliente = cliente.logoCliente;
                                  client.descripcion = _descripcionController.text;
                                  client.oe = orden;
                                  _controller.saveOE(client);
                                  Navigator.pop(context);
                                } else {
                                  showToast2('Debe seleccionar una OES', Colors.redAccent);
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

  void savePersonalOE(PersonalOEModel personal) {
    final _personaController = TextEditingController();
    final _cargoController = TextEditingController();
    final _vigenciaController = TextEditingController();
    final _asistenciaController = TextEditingController();

    _personaController.text = personal.nombre ?? '';
    _cargoController.text = "${personal.cargo ?? ''}: ${personal.detalleCargo ?? ''}";
    _vigenciaController.text = personal.fechaPeriodo ?? '';
    _asistenciaController.text = 'ASISTIO';
    //Para guardar el ID Asistencia
    final _valueAsistencia = TextEditingController();
    _valueAsistencia.text = '1';

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
                              'Agregar Personal',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(18),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            TextFieldSelect(
                              label: 'Nombre',
                              hingText: '',
                              controller: _personaController,
                              icon: false,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Cargo',
                              hingText: '',
                              controller: _cargoController,
                              icon: false,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Fecha del Periodo Laboral',
                              hingText: '',
                              controller: _vigenciaController,
                              widget: Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Asistencia',
                              hingText: '',
                              controller: _asistenciaController,
                              widget: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                _selectAsistencia(_asistenciaController, _valueAsistencia);
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            InkWell(
                              onTap: () {
                                final people = PersonalOEModel();
                                people.idPersona = personal.idPersona;
                                people.id = personal.id;
                                people.nombre = personal.nombre;
                                people.dni = personal.dni;
                                people.fechaPeriodo = personal.fechaPeriodo;
                                people.image = personal.image;
                                people.idCargo = personal.idCargo;
                                people.cargo = personal.cargo;
                                people.detalleCargo = personal.detalleCargo;
                                people.valueAsistencia = _valueAsistencia.text;
                                people.asistenciaProyectada = _asistenciaController.text;

                                _controller.savePersonal(people);
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

  void _selectAsistencia(TextEditingController _asis, TextEditingController _id) {
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
                          'Selecionar Asistencia',
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
                            itemCount: listAsist.length,
                            itemBuilder: (_, index) {
                              var item = listAsist[index];
                              return InkWell(
                                onTap: () {
                                  _asis.text = item.asistencia ?? '';
                                  _id.text = item.id.toString();
                                  Navigator.pop(context);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      item.asistencia ?? '',
                                      style: TextStyle(color: item.color, fontWeight: FontWeight.w600),
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
}

class POSController extends ChangeNotifier {
  List<ClientesOEModel> oes = [];
  List<PersonalOEModel> personal = [];
  bool cargando = false;

  void saveOE(ClientesOEModel item) {
    oes.removeWhere((element) => element.oe!.idOE == item.oe!.idOE);
    oes.add(item);
    notifyListeners();
  }

  void removeOE(String id) {
    oes.removeWhere((item) => item.oe!.idOE == id);
    notifyListeners();
  }

  void clearOE() {
    oes.clear();
    notifyListeners();
  }

  void savePersonal(PersonalOEModel item) {
    personal.removeWhere((element) => element.idPersona == item.idPersona);
    personal.add(item);
    notifyListeners();
  }

  void removePersonal(String id) {
    personal.removeWhere((item) => item.idPersona == id);
    notifyListeners();
  }

  void clearPersonal() {
    personal.clear();
    notifyListeners();
  }

  void changeCargando(bool c) {
    cargando = c;
    notifyListeners();
  }
}

class AsistenciaPersonal {
  String? id;
  String? asistencia;
  Color? color;

  AsistenciaPersonal({this.id, this.asistencia, this.color});
}

final List<AsistenciaPersonal> listAsist = [
  AsistenciaPersonal(id: '1', asistencia: 'ASISTIO', color: Colors.black),
  AsistenciaPersonal(id: '2', asistencia: 'FALTO', color: Colors.redAccent),
  AsistenciaPersonal(id: '3', asistencia: '50% ASISTIO', color: Colors.pink),
  AsistenciaPersonal(id: '61', asistencia: 'ASISTIO + 1 HR', color: Colors.greenAccent),
  AsistenciaPersonal(id: '10', asistencia: 'ASISTIO + 2 HR', color: Colors.greenAccent),
  AsistenciaPersonal(id: '63', asistencia: 'ASISTIO + 3 HR', color: Colors.greenAccent),
  AsistenciaPersonal(id: '4', asistencia: 'ASISTIO + 4 HR', color: Colors.green),
  AsistenciaPersonal(id: '65', asistencia: 'ASISTIO + 5 HR', color: Colors.greenAccent),
  AsistenciaPersonal(id: '66', asistencia: 'ASISTIO + 6 HR', color: Colors.greenAccent),
  AsistenciaPersonal(id: '67', asistencia: 'ASISTIO + 7 HR', color: Colors.greenAccent),
  AsistenciaPersonal(id: '5', asistencia: 'ASISTIO + 8 HR', color: Colors.blueGrey),
  AsistenciaPersonal(id: '8', asistencia: 'ASISTIO + 200%', color: Colors.deepPurple),
  AsistenciaPersonal(id: '7', asistencia: 'DESCANSO SEMANAL', color: Colors.brown),
  AsistenciaPersonal(id: '15', asistencia: 'DESCANSO REMUNERADO', color: Colors.deepOrange),
];
