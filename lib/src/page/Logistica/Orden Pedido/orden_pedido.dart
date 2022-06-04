import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/page/Home/menu_widget.dart';
import 'package:new_brunner_app/src/page/Logistica/Orden%20Pedido/Consulta%20Informacion/consulta_informacion_orden_pedido.dart';
import 'package:new_brunner_app/src/widget/option_widget.dart';

class OrdenPedido extends StatelessWidget {
  const OrdenPedido({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Orden de Pedido',
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
            onTap: () {
              // final searchVehiculoBloc = ProviderBloc.vehiculo(context);
              // searchVehiculoBloc.cargarVehiculos();
              // Navigator.push(
              //   context,
              //   PageRouteBuilder(
              //     pageBuilder: (context, animation, secondaryAnimation) {
              //       return const ListaVehiculosMaquinarias();
              //     },
              //   ),
              // );
            },

            child: const OptionWidget(
              titulo: 'Generar Orden de Pedido',
              descripcion: 'Generar Orden de Pedido',
              icon: Icons.edit_note,
              color: Color(0XFFF39C12),
            ),
            //child: option('Check List', 'Lista de unidades para generar un Check List', Icons.checklist, const Color(0XFF09AD92)),
          ),
          SizedBox(height: ScreenUtil().setWidth(30)),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const ConsultaInformacionOrdenPedido();
                  },
                ),
              );
            },
            child: const OptionWidget(
              titulo: 'Consulta de Información',
              descripcion: 'Ver Orden de Pedido Generadas y Pendientes',
              icon: Icons.search,
              color: Color(0XFF34495E),
            ),
            // child: option('Consulta de Información', 'Lista los Check List generados', Icons.search, const Color(0XFF09A8AD)),
          ),
        ],
      ),
    );
  }
}
