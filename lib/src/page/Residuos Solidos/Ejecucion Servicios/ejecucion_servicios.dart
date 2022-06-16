import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/page/Home/menu_widget.dart';
import 'package:new_brunner_app/src/page/Residuos%20Solidos/Ejecucion%20Servicios/Generar%20OES/generar_orden_ejecucion_servicio.dart';
import 'package:new_brunner_app/src/widget/option_widget.dart';

class EjecucionServicios extends StatelessWidget {
  const EjecucionServicios({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Ejecución del Servicio',
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
          OptionWidget(
            titulo: 'Generar Orden de Ejecución de Servicio',
            descripcion: 'Generar Orden de Ejecución de Servicio',
            icon: Icons.handshake,
            color: Color(0XFF73C6B6),
            ontap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const GenerarOrdenEjecucionServicio();
                  },
                ),
              );
            },
          ),
          SizedBox(height: ScreenUtil().setWidth(30)),
          OptionWidget(
            titulo: 'Generar Parte Operativo del Servicio (POS)',
            descripcion: '',
            icon: Icons.edit_note,
            color: Color(0XFFA569BD),
            ontap: () {
              // Navigator.push(
              //   context,
              //   PageRouteBuilder(
              //     pageBuilder: (context, animation, secondaryAnimation) {
              //       return const ConsultaInformacionEjecucionServicios();
              //     },
              //   ),
              // );
            },
          ),
          SizedBox(height: ScreenUtil().setWidth(30)),
          OptionWidget(
            titulo: 'Consulta de Información',
            descripcion: 'Ver Órdenes de Ejecución de Servicios, POS y Gestión de Combustible',
            icon: Icons.search,
            color: Color(0XFF85929E),
            ontap: () {},
          ),
        ],
      ),
    );
  }
}
