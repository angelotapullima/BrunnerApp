import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/page/search_clientes.dart';
import 'package:new_brunner_app/src/widget/text_field.dart';

class ResultOE extends StatefulWidget {
  const ResultOE({Key? key, required this.id}) : super(key: key);
  final String id;

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

  @override
  Widget build(BuildContext context) {
    final ejecucionServicioBloc = ProviderBloc.ejecucionServicio(context);
    return SingleChildScrollView(
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
                ejecucionServicioBloc.sarchClientesByQuery('', widget.id);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return ClienteSearch(
                        id: widget.id,
                        onChanged: (cliente) {
                          _clienteController.text = cliente.nombreCliente ?? '';
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
                // _seleccionar(context, 'Seleccionar', _streamCliente);
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
                // _seleccionar(context, 'Seleccionar', _streamCliente);
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
                // _seleccionar(context, 'Seleccionar', _streamCliente);
              },
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            TextFieldSelect(
              label: 'Descripción General del Servicio',
              hingText: '',
              controller: _condicionController,
              widget: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.green,
              ),
              icon: true,
              readOnly: true,
              ontap: () {
                FocusScope.of(context).unfocus();
                // _seleccionar(context, 'Seleccionar', _streamCliente);
              },
            ),
            SizedBox(
              height: ScreenUtil().setHeight(15),
            ),
            TextFieldSelect(
              label: 'Fecha del Servicio',
              hingText: '',
              controller: _condicionController,
              widget: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.green,
              ),
              icon: true,
              readOnly: true,
              ontap: () {
                FocusScope.of(context).unfocus();
                // _seleccionar(context, 'Seleccionar', _streamCliente);
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
                // _seleccionar(context, 'Seleccionar', _streamCliente);
              },
            ),
            SizedBox(
              height: ScreenUtil().setHeight(15),
            ),
            TextFieldSelect(
              label: 'CIP Responsable Técnico',
              hingText: '',
              controller: _responsableController,
              widget: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.green,
              ),
              icon: true,
              readOnly: true,
              ontap: () {
                FocusScope.of(context).unfocus();
                // _seleccionar(context, 'Seleccionar', _streamCliente);
              },
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
                // _seleccionar(context, 'Seleccionar', _streamCliente);
              },
            ),
            SizedBox(
              height: ScreenUtil().setHeight(15),
            ),
            TextFieldSelect(
              label: 'Teléfono de Contacto',
              hingText: '',
              controller: _responsableController,
              widget: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.green,
              ),
              icon: true,
              readOnly: true,
              ontap: () {
                FocusScope.of(context).unfocus();
                // _seleccionar(context, 'Seleccionar', _streamCliente);
              },
            ),
            SizedBox(
              height: ScreenUtil().setHeight(15),
            ),
            TextFieldSelect(
              label: 'Email de Contacto',
              hingText: '',
              controller: _responsableController,
              widget: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.green,
              ),
              icon: true,
              readOnly: true,
              ontap: () {
                FocusScope.of(context).unfocus();
                // _seleccionar(context, 'Seleccionar', _streamCliente);
              },
            ),
            SizedBox(
              height: ScreenUtil().setHeight(25),
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
                // _seleccionar(context, 'Seleccionar', _streamCliente);
              },
            ),
          ],
        ),
      ),
    );
  }
}
