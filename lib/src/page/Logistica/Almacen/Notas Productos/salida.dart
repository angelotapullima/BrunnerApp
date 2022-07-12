import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Logistica/almacen_api.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/alertas_salida_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/recursos_almacen_model.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/Notas%20Productos/confirmar.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/Notas%20Productos/search_persons.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/Notas%20Productos/search_recursos.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/web_wiew.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/text_field.dart';

class Salida extends StatefulWidget {
  const Salida({Key? key, required this.idSede}) : super(key: key);
  final String idSede;

  @override
  State<Salida> createState() => _SalidaState();
}

class _SalidaState extends State<Salida> {
  final _documentoController = TextEditingController();
  final _personaController = TextEditingController();
  final _dniController = TextEditingController();
  final _recursoController = TextEditingController();
  final _controller = SalidaController();
  @override
  Widget build(BuildContext context) {
    final almacenBloc = ProviderBloc.almacen(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16), vertical: ScreenUtil().setHeight(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldSelect(
              label: 'Documento del Registro',
              hingText: '',
              controller: _documentoController,
              widget: Icon(
                Icons.edit_note,
                color: Colors.green,
              ),
              icon: true,
              readOnly: false,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Divider(),
            SizedBox(
              height: ScreenUtil().setHeight(5),
            ),
            Text(
              'Persona',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            TextFieldSelect(
              label: 'DNI',
              hingText: 'Seleccionar persona',
              controller: _dniController,
              widget: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.green,
              ),
              icon: true,
              readOnly: true,
              ontap: () {
                FocusScope.of(context).unfocus();
                almacenBloc.searchPersons('');
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return SearchPersonsAlmacen(
                        onChanged: (person) {
                          _dniController.text = person.dni ?? '';
                          _personaController.text = '${person.name} ${person.surname} ${person.surname2}';
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
              label: 'Nombre Completo',
              hingText: '',
              controller: _personaController,
              icon: false,
              readOnly: true,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Divider(),
            SizedBox(
              height: ScreenUtil().setHeight(5),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (_, f) {
                return (_controller.recursos.isEmpty)
                    ? Text(
                        'Información Registrada',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : ExpansionTile(
                        initiallyExpanded: true,
                        maintainState: true,
                        title: Text(
                          'Información Registrada',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        children: _controller.recursos.map((item) => _recursoAgregado(item)).toList(),
                      );
              },
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            TextFieldSelect(
              label: 'Recursos en Almacén',
              hingText: 'Seleccionar recurso',
              controller: _recursoController,
              widget: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.green,
              ),
              icon: true,
              readOnly: true,
              ontap: () {
                FocusScope.of(context).unfocus();
                almacenBloc.searchRecurso(widget.idSede, '');
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return SearchRecursosAlmacen(
                        idSede: widget.idSede,
                        onChanged: (recurso) {
                          mostrarlertas(recurso.idAlmacen ?? '');
                          saveRecurso(recurso);
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
              height: ScreenUtil().setHeight(20),
            ),
            InkWell(
              onTap: () async {
                FocusScope.of(context).unfocus();
                if (_documentoController.text.isNotEmpty) {
                  if (_dniController.text.isNotEmpty) {
                    if (_controller.recursos.isNotEmpty) {
                      String datos = '';
                      for (var i = 0; i < _controller.recursos.length; i++) {
                        var r = _controller.recursos[i];

                        if (i == _controller.recursos.length - 1) {
                          datos +=
                              '${r.idRecursoLogistica}/__/${r.unidadAlmacen}/__/${r.idTipoRecurso}/__/${r.descripcionAlmacen}/__/${r.ubicacionAlmacen}/__/${r.cantidad}';
                        } else {
                          datos +=
                              '${r.idRecursoLogistica}/__/${r.unidadAlmacen}/__/${r.idTipoRecurso}/__/${r.descripcionAlmacen}/__/${r.ubicacionAlmacen}/__/${r.cantidad}._._.';
                        }
                      }
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return Confirmar(
                                idSede: widget.idSede,
                                idAlmacenDestino: '0',
                                tipoRegistro: '0',
                                dniSolicitante: _dniController.text,
                                nombreSolicitante: _personaController.text,
                                comentarios: _documentoController.text,
                                datos: datos);
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
                    } else {
                      showToast2('Debe seleccionar resursos', Colors.redAccent);
                    }
                  } else {
                    showToast2('Debe seleccionar a una Persona', Colors.redAccent);
                  }
                } else {
                  showToast2('Campo Documento de Registro requerido', Colors.redAccent);
                }
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0XFF148F77),
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
                    'Generar Registro',
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
              height: ScreenUtil().setHeight(50),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recursoAgregado(RecursosAlmacenModel item) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(16),
              vertical: ScreenUtil().setHeight(10),
            ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
                fileData('Denominación', '${item.nombreClaseLogistica ?? ""} | ${item.nombreRecurso ?? ""}', 10, 12, FontWeight.w500, FontWeight.w500,
                    TextAlign.start),
                fileData('U.M.', item.unidadRecurso ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                fileData('Detalle', item.nombreTipoRecurso ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                fileData('Cantidad', item.cantidad ?? '', 10, 14, FontWeight.w500, FontWeight.w600, TextAlign.start),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            _controller.removeRecurso(item.idAlmacen ?? '');
          },
          icon: Icon(Icons.cancel),
          color: Colors.redAccent,
        ),
      ],
    );
  }

  void saveRecurso(RecursosAlmacenModel recurso) {
    final _denominacionController = TextEditingController();
    final _unidadController = TextEditingController();
    final _detalleController = TextEditingController();
    final _cantidadController = TextEditingController();

    _denominacionController.text =
        '${recurso.nombreClaseLogistica} | ${recurso.nombreRecurso} | ${recurso.stockAlmacen} ${recurso.unidadRecurso} ${recurso.nombreTipoRecurso}';
    _unidadController.text = recurso.unidadRecurso ?? '';
    _detalleController.text = recurso.nombreTipoRecurso ?? '';

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
                              'Agregar Recurso',
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
                              label: 'Denominación',
                              hingText: '',
                              controller: _denominacionController,
                              icon: false,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'U.M.',
                              hingText: '',
                              controller: _unidadController,
                              icon: false,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Detalle',
                              hingText: '',
                              controller: _detalleController,
                              icon: false,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Cantidad',
                              hingText: '',
                              controller: _cantidadController,
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
                                if (_cantidadController.text.isNotEmpty) {
                                  var stock = double.parse(recurso.stockAlmacen ?? '0');
                                  var cantidad = double.parse(_cantidadController.text.trim());

                                  if (stock > 0) {
                                    if (cantidad > 0) {
                                      if (cantidad <= stock) {
                                        final r = RecursosAlmacenModel();
                                        r.idAlmacen = recurso.idAlmacen;
                                        r.idSede = recurso.idSede;
                                        r.idRecursoLogistica = recurso.idRecursoLogistica;
                                        r.idTipoRecurso = recurso.idTipoRecurso;
                                        r.unidadAlmacen = recurso.unidadAlmacen;
                                        r.stockAlmacen = recurso.stockAlmacen;
                                        r.descripcionAlmacen = recurso.descripcionAlmacen;
                                        r.ubicacionAlmacen = recurso.ubicacionAlmacen;
                                        r.idClaseLogistica = recurso.idClaseLogistica;
                                        r.nombreRecurso = recurso.nombreRecurso;
                                        r.unidadRecurso = recurso.unidadRecurso;
                                        r.idTipoLogistica = recurso.idTipoLogistica;
                                        r.nombreClaseLogistica = recurso.nombreClaseLogistica;
                                        r.nombreTipoLogistica = recurso.nombreTipoLogistica;
                                        r.nombreTipoRecurso = recurso.nombreTipoRecurso;
                                        r.estadoTipoRecurso = recurso.estadoTipoRecurso;
                                        r.cantidad = '-${_cantidadController.text.trim()}';
                                        _controller.saveRecurso(r);
                                        Navigator.pop(context);
                                      } else {
                                        showToast2('La cantidad ingresada debe ser menor que el Stock disponible', Colors.redAccent);
                                      }
                                    } else {
                                      showToast2('La cantidad ingresada debe ser mayor que 0', Colors.redAccent);
                                    }
                                  } else {
                                    Navigator.pop(context);
                                    showToast2('Recurso sin stock disponible', Colors.black);
                                  }
                                } else {
                                  showToast2('Debe ingresar una Cantidad', Colors.redAccent);
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

  void mostrarlertas(String idAlmacen) async {
    final _api = AlmacenApi();
    final res = await _api.getAlertasSalidas(idAlmacen);

    if (res.isNotEmpty) {
      Widget _alerta(AlertaSalidaModel alert) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return WebPage(
                    title: alert.comentario ?? '',
                    url: alert.link ?? '$apiBaseURL',
                  );
                },
              ),
            );
          },
          child: Column(
            children: [
              fileData('Descripción de Orden', alert.comentario ?? '', 10, 12, FontWeight.w500, FontWeight.w500, TextAlign.start),
              fileData('Cantidad', alert.stock ?? '', 10, 12, FontWeight.w500, FontWeight.w500, TextAlign.start),
              fileData('Orden de Salida', 'Ver', 10, 14, FontWeight.w500, FontWeight.w600, TextAlign.start),
              Divider(),
            ],
          ),
        );
      }

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.orangeAccent,
                  size: ScreenUtil().setHeight(50),
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                Text(
                  'Producto Pendiente de Salida',
                ),
              ],
            ),
            content: SizedBox(
              height: ScreenUtil().setHeight(60) * (res.length + 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: res.map((e) => _alerta(e)).toList(),
                  ),
                  Spacer(),
                  Text(
                    'Tener en cuenta estas observaciones',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
    }
  }
}

class SalidaController extends ChangeNotifier {
  List<RecursosAlmacenModel> recursos = [];
  bool cargando = false;

  void saveRecurso(RecursosAlmacenModel item) {
    recursos.removeWhere((element) => element.idAlmacen == item.idAlmacen);
    recursos.add(item);
    notifyListeners();
  }

  void removeRecurso(String id) {
    recursos.removeWhere((item) => item.idAlmacen == id);
    notifyListeners();
  }

  void clearRecuros() {
    recursos.clear();
    notifyListeners();
  }

  void changeCargando(bool c) {
    cargando = c;
    notifyListeners();
  }
}
