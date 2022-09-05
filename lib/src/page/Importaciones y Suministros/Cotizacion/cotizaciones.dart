import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/page/Home/menu_widget.dart';
import 'package:new_brunner_app/src/page/Importaciones%20y%20Suministros/Cotizacion/Generar%20Cotizacion/generate_cotizacion.dart';
import 'package:new_brunner_app/src/widget/option_widget.dart';

class Cotizacion extends StatelessWidget {
  const Cotizacion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Cotización',
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
            titulo: 'Generar Cotización de Productos',
            descripcion: 'Generar Cotización de Productos de forma manual',
            icon: Icons.edit_note,
            color: Colors.teal[700]!,
            ontap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const GenerateCotizacion();
                  },
                ),
              );
            },
          ),
          SizedBox(height: ScreenUtil().setWidth(30)),
          OptionWidget(
            titulo: 'Consulta externa de Productos',
            descripcion: 'Revisar Consultas externas del producto',
            icon: Icons.remove_red_eye,
            color: Colors.blue[700]!,
            ontap: () {},
          ),
          SizedBox(height: ScreenUtil().setWidth(30)),
          OptionWidget(
            titulo: 'Consulta de Información',
            descripcion: 'Ver Cotización de productos generados de forma manual',
            icon: Icons.search,
            color: Colors.indigo,
            ontap: () {},
          ),
        ],
      ),
    );
  }
}
