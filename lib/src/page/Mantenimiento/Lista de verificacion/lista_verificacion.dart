import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/page/Home/menu_widget.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/Consulta%20Informacion/consulta_informacion.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/lista_vehiculos_maquinarias.dart';
import 'package:new_brunner_app/src/widget/option_widget.dart';

class ListaVerificacion extends StatelessWidget {
  const ListaVerificacion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Lista de verificación',
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
              final searchVehiculoBloc = ProviderBloc.vehiculo(context);
              searchVehiculoBloc.cargarVehiculos();
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const ListaVehiculosMaquinarias();
                  },
                ),
              );
            },

            child: const OptionWidget(
              titulo: 'Check List',
              descripcion: 'Lista de unidades para generar un Check List',
              icon: Icons.checklist,
              color: Color(0XFF09AD92),
            ),
            //child: option('Check List', 'Lista de unidades para generar un Check List', Icons.checklist, const Color(0XFF09AD92)),
          ),
          SizedBox(height: ScreenUtil().setWidth(30)),
          InkWell(
            onTap: () {
              final searchVehiculoBloc = ProviderBloc.vehiculo(context);
              searchVehiculoBloc.cargarVehiculos();
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const ConsultaInformacion();
                  },
                ),
              );
            },
            child: const OptionWidget(
              titulo: 'Consulta de Información',
              descripcion: 'Lista los Check List generados',
              icon: Icons.search,
              color: Color(0XFF09A8AD),
            ),
            // child: option('Consulta de Información', 'Lista los Check List generados', Icons.search, const Color(0XFF09A8AD)),
          ),
        ],
      ),
    );
  }
}
