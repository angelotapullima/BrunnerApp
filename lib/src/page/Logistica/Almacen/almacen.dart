import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/page/Home/menu_widget.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/Notas%20Productos/notas_productos.dart';
import 'package:new_brunner_app/src/widget/option_widget.dart';

class Almacen extends StatelessWidget {
  const Almacen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final almacenBloc = ProviderBloc.almacen(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Almacén',
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
            titulo: 'Notas de Productos',
            descripcion: 'Registrar Ingresos y Salidas de Productos en Almacén',
            icon: Icons.edit_note,
            color: Color(0XFF148F77),
            ontap: () {
              almacenBloc.updateResp(100);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const NotasProductos();
                  },
                ),
              );
            },
          ),
          SizedBox(height: ScreenUtil().setWidth(30)),
          OptionWidget(
            titulo: 'Transferencia entre Almacenes',
            descripcion: 'Mover Recursos de un almacén a otro',
            icon: Icons.move_down,
            color: Color(0XFF2471A3),
            ontap: () {},
          ),
          SizedBox(height: ScreenUtil().setWidth(30)),
          OptionWidget(
            titulo: 'Consulta de Información',
            descripcion: 'Ver Información de los Almacenes',
            icon: Icons.search,
            color: Color(0XFF154360),
            ontap: () {},
          ),
        ],
      ),
    );
  }
}
