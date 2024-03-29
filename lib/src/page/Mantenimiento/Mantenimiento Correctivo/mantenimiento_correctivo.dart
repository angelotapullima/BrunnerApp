import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/page/Home/menu_widget.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Correctivo/mant_correctivo.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Orden%20Habilitacion/orden_habilitacion_correctiva.dart';
import 'package:new_brunner_app/src/widget/option_widget.dart';

class MantenimientoCorrectivo extends StatelessWidget {
  const MantenimientoCorrectivo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Orden de Trabajo',
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
            titulo: 'Mantenimiento Correctivo',
            descripcion: '',
            icon: Icons.car_repair_outlined,
            color: Color(0XFF3498DB),
            ontap: () {
              final correctivoBloc = ProviderBloc.mantenimientoCorrectivo(context);
              correctivoBloc.getCategorias('');
              correctivoBloc.clearData();

              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const MantCorrectivo();
                  },
                ),
              );
            },
          ),
          SizedBox(height: ScreenUtil().setWidth(30)),
          OptionWidget(
            titulo: 'Orden Habilitación Correctiva',
            descripcion: '',
            icon: Icons.check_circle,
            color: Color(0XFF16A085),
            ontap: () {
              final consultaDetallespBloc = ProviderBloc.ordenHab(context);
              consultaDetallespBloc.clear();
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const OrdenHabilitacionCorrectiva();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
