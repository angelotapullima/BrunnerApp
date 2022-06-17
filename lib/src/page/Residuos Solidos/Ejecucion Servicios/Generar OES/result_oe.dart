import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/model/Empresa/clientes_model.dart';
import 'package:new_brunner_app/src/widget/text_field.dart';

class ResultOE extends StatefulWidget {
  const ResultOE({Key? key, required this.clientes}) : super(key: key);
  final List<ClientesModel> clientes;

  @override
  State<ResultOE> createState() => _ResultOEState();
}

class _ResultOEState extends State<ResultOE> {
  final _clienteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
        child: Column(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            // TextFieldSelect(
            //   label: 'Cliente',
            //   hingText: 'Seleccionar',
            //   controller: _clienteController,
            //   widget: Icon(
            //     Icons.keyboard_arrow_down,
            //     color: Colors.green,
            //   ),
            //   icon: true,
            //   readOnly: true,
            //   ontap: () {
            //     FocusScope.of(context).unfocus();
            //     Navigator.push(
            //       context,
            //       PageRouteBuilder(
            //         pageBuilder: (context, animation, secondaryAnimation) {
            //           return ClienteSearch(
            //             clientes: widget.clientes,
            //             onChanged: (cliente) {
            //               _clienteController.text = cliente.nombreCliente ?? '';
            //             },
            //           );
            //         },
            //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //           var begin = const Offset(0.0, 1.0);
            //           var end = Offset.zero;
            //           var curve = Curves.ease;

            //           var tween = Tween(begin: begin, end: end).chain(
            //             CurveTween(curve: curve),
            //           );

            //           return SlideTransition(
            //             position: animation.drive(tween),
            //             child: child,
            //           );
            //         },
            //       ),
            //     );
            //   },
            // ),
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
                _seleccionar(context, 'Seleccionar', _streamCliente);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _seleccionar(BuildContext context, String titulo, Widget stream(ScrollController controller)) {
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
                          child: stream(controller),
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

  Widget _streamCliente(ScrollController controller) {
    return ListView.builder(
      controller: controller,
      itemCount: widget.clientes.length,
      itemBuilder: (_, index) {
        var item = widget.clientes[index];
        return InkWell(
          onTap: () {
            _clienteController.text = item.nombreCliente.toString().trim();
            //idEmpresa = item.idEmpresa.toString().trim();

            Navigator.pop(context);
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(item.nombreCliente.toString().trim()),
            ),
          ),
        );
      },
    );
  }
}
