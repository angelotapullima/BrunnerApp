import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/page/Logistica/Orden%20Pedido/Consulta%20Informacion/Ordenes%20Pedido%20Lista/detalle_oden_pedido.dart';
import 'package:new_brunner_app/src/widget/option_widget.dart';

class ConsultaInformacionAlmacen extends StatefulWidget {
  const ConsultaInformacionAlmacen({Key? key}) : super(key: key);

  @override
  State<ConsultaInformacionAlmacen> createState() => _ConsultaInformacionAlmacenState();
}

class _ConsultaInformacionAlmacenState extends State<ConsultaInformacionAlmacen> {
  final _controller = ControllerExpanded();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF154360),
        title: Text(
          'Consulta de Información',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimatedBuilder(
          animation: _controller,
          builder: (_, p) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OptionWidget(
                    titulo: 'Notas de Ingresos y Salidas Generadas',
                    descripcion: 'Visualizar Registros Generados',
                    icon: Icons.edit_note,
                    color: Color(0XFF148F77),
                    ontap: () {},
                  ),
                  SizedBox(height: ScreenUtil().setWidth(30)),
                  OptionWidget(
                    titulo: 'Notas de Ingresos y Salidas Pendientes de Aprobacion',
                    descripcion: 'Visualizar Registros Generados Pendientes de Aprobación',
                    icon: Icons.radio_button_unchecked_sharp,
                    color: Colors.orangeAccent,
                    ontap: () {
                      // Navigator.push(
                      //   context,
                      //   PageRouteBuilder(
                      //     pageBuilder: (context, animation, secondaryAnimation) {
                      //       return const NotasProductos();
                      //     },
                      //   ),
                      // );
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget option({required String titulo, required IconData icon, required Color color, Function()? ontap}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: ScreenUtil().setHeight(70),
        width: ScreenUtil().setWidth(155),
        margin: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(10),
        ),
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
        child: Stack(
          children: [
            Container(
              height: ScreenUtil().setHeight(70),
              width: ScreenUtil().setWidth(150),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(100),
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  titulo,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(1),
                  bottom: ScreenUtil().setHeight(2),
                ),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
