import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/page/Home/menu_widget.dart';
import 'package:new_brunner_app/src/page/Logistica/Orden%20Pedido/Consulta%20Informacion/pedidos_generados.dart';
import 'package:new_brunner_app/src/widget/option_widget.dart';

class ConsultaInformacionOrdenPedido extends StatelessWidget {
  const ConsultaInformacionOrdenPedido({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        leading: const MenuWidget(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: OptionWidget(
              titulo: 'Órdenes de Pedido Generadas',
              descripcion: 'Visualización de Órdenes de Pedido Generadas',
              icon: Icons.edit_note,
              color: Color(0XFF154360),
              ontap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const PedidosGenerados();
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: ScreenUtil().setWidth(30)),
          OptionWidget(
            titulo: 'Órdenes de Pedido Pendientes de Aprobación',
            descripcion: 'Visualización de Órdenes de Pedido Pendientes de Aprobación',
            icon: Icons.check_circle_outline,
            color: Color(0XFFF39C12),
            ontap: () {},
          ),
        ],
      ),
    );
  }
}
