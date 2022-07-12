import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_brunner_app/src/api/Logistica/almacen_api.dart';
import 'package:new_brunner_app/src/bloc/logistica_almacen_bloc.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/detalle_recurso_logistica_model.dart';
import 'package:new_brunner_app/src/model/Logistica/Almacen/recurso_logistica_model.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/Notas%20Productos/confirmar.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/Notas%20Productos/search_recurso_logistica.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';
import 'package:new_brunner_app/src/widget/text_field.dart';

class Ingreso extends StatefulWidget {
  const Ingreso({Key? key, required this.idSede}) : super(key: key);
  final String idSede;

  @override
  State<Ingreso> createState() => _IngresoState();
}

class _IngresoState extends State<Ingreso> {
  final _searchController = TextEditingController();
  final _recursoController = TextEditingController();
  final _documentoController = TextEditingController();

  final _controller = IngresoController();
  @override
  Widget build(BuildContext context) {
    final almacenBloc = ProviderBloc.almacen(context);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(16),
              vertical: ScreenUtil().setHeight(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buscar Recurso en Base de Datos',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(8),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0XFF148F77)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            label: Text(
                              'Nombre Recurso',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(12),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          showToast2('Buscando recurso', Colors.black);
                          almacenBloc.getRecursosIngreso(widget.idSede, _searchController.text.trim());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: Color(0XFF148F77),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.transparent.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            'Buscar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                selectRecurso(almacenBloc),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (_, p) {
            return ShowLoadding(
              active: _controller.cargando,
              h: double.infinity,
              w: double.infinity,
              fondo: Colors.black.withOpacity(0.6),
              colorText: Colors.black,
            );
          },
        ),
      ],
    );
  }

  Widget selectRecurso(LogisticaAlmacenBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.respRecursoStream,
      builder: (_, r) {
        if (r.hasData) {
          if (r.data! == 1) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Divider(),
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
                  label: 'Seleccionar Recurso',
                  hingText: '',
                  controller: _recursoController,
                  widget: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.green,
                  ),
                  icon: true,
                  readOnly: true,
                  ontap: () {
                    FocusScope.of(context).unfocus();
                    bloc.searchRecursoIngreso(widget.idSede, '');
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return SearchRecursoLogistica(
                            idSede: widget.idSede,
                            onChanged: (recurso) async {
                              _controller.changeCargando(true);
                              final _api = AlmacenApi();
                              final res = await _api.getDetalleRecurso(recurso.idRecursoLogistica.toString());
                              if (res.isNotEmpty) {
                                saveRecurso(recurso, res);
                              } else {
                                Navigator.pop(context);
                              }
                              _controller.changeCargando(false);
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
                    if (_controller.recursos.isNotEmpty) {
                      if (_documentoController.text.isNotEmpty) {
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
                                  tipoRegistro: '1',
                                  dniSolicitante: '',
                                  nombreSolicitante: '',
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
                        showToast2('Debe ingresar Documento del Registro', Colors.redAccent);
                      }
                    } else {
                      showToast2('Debe seleccionar resursos', Colors.redAccent);
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
              ],
            );
          } else {
            if (r.data! == 2) {
              showToast2('No existen recursos similares con el Dato Ingresado', Colors.redAccent);
            }
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget _recursoAgregado(ItemRecursoModel item) {
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
                fileData('Denominación', item.denominacion ?? '', 10, 12, FontWeight.w500, FontWeight.w500, TextAlign.start),
                fileData('U.M.', item.unidadAlmacen ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                fileData('Detalle', item.detalle ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                fileData('Cantidad', item.cantidad ?? '', 10, 14, FontWeight.w500, FontWeight.w600, TextAlign.start),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            _controller.removeRecurso(item.idTipoRecurso ?? '');
          },
          icon: Icon(Icons.cancel),
          color: Colors.redAccent,
        ),
      ],
    );
  }

  void saveRecurso(RecursoLogisticaModel recurso, List<DetalleRecursoLogisticaModel> detalles) {
    final _denominacionController = TextEditingController();
    final _descripcionController = TextEditingController();
    final _ubicacionController = TextEditingController();
    final _unidadController = TextEditingController();
    final _detalleController = TextEditingController();
    final _cantidadController = TextEditingController();

    String idTipoRecurso = '';

    _denominacionController.text = '${recurso.nombreClaseLogistica} | ${recurso.nombreRecursoLogistica}';
    _unidadController.text = detalles[0].unidad ?? '';

    void _selectDetalle(List<DetallesRLModel> detalles) {
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
                            'Seleccionar Detalle',
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
                              itemCount: detalles.length,
                              itemBuilder: (_, index) {
                                var item = detalles[index];
                                return InkWell(
                                  onTap: () {
                                    idTipoRecurso = item.idTipoRecurso ?? '';
                                    _detalleController.text = item.nombreTipoRecurso ?? '';
                                    Navigator.pop(context);
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(item.nombreTipoRecurso ?? ''),
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

    //AGREGAR RECURSO

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
                              label: 'Descripcion',
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
                            TextFieldSelect(
                              label: 'Ubicación',
                              hingText: '',
                              controller: _ubicacionController,
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
                            TextFieldSelect(
                              label: 'Detalle',
                              hingText: 'Seleccionar',
                              controller: _detalleController,
                              widget: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                _selectDetalle(detalles[0].listDetalles!);
                              },
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
                                if (idTipoRecurso != '') {
                                  if (_cantidadController.text.isNotEmpty) {
                                    var cantidad = double.parse(_cantidadController.text.trim());

                                    if (cantidad > 0) {
                                      final r = ItemRecursoModel();
                                      r.idRecursoLogistica = recurso.idRecursoLogistica ?? '';
                                      r.unidadAlmacen = _unidadController.text;
                                      r.idTipoRecurso = idTipoRecurso;
                                      r.descripcionAlmacen = _descripcionController.text;
                                      r.ubicacionAlmacen = _ubicacionController.text;
                                      r.detalle = _detalleController.text;
                                      r.denominacion = _denominacionController.text;
                                      r.cantidad = _cantidadController.text;

                                      _controller.saveRecurso(r);
                                      Navigator.pop(context);
                                    } else {
                                      showToast2('La cantidad ingresada debe ser mayor que 0', Colors.redAccent);
                                    }
                                  } else {
                                    showToast2('Debe ingresar una Cantidad', Colors.redAccent);
                                  }
                                } else {
                                  showToast2('Debe seleccionar el detalle del recurso', Colors.redAccent);
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
}

class IngresoController extends ChangeNotifier {
  List<ItemRecursoModel> recursos = [];
  bool cargando = false;

  void saveRecurso(ItemRecursoModel item) {
    recursos.removeWhere((element) => element.idTipoRecurso == item.idTipoRecurso);
    recursos.add(item);
    notifyListeners();
  }

  void removeRecurso(String id) {
    recursos.removeWhere((item) => item.idTipoRecurso == id);
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

class ItemRecursoModel {
  String? idRecursoLogistica;
  String? unidadAlmacen;
  String? idTipoRecurso;
  String? descripcionAlmacen;
  String? ubicacionAlmacen;
  String? cantidad;
  String? detalle;
  String? denominacion;

  ItemRecursoModel({
    this.idRecursoLogistica,
    this.unidadAlmacen,
    this.idTipoRecurso,
    this.descripcionAlmacen,
    this.ubicacionAlmacen,
    this.cantidad,
    this.detalle,
    this.denominacion,
  });
}
