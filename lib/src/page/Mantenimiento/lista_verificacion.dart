import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/page/Home/menu_widget.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/lista_vehiculos_maquinarias.dart';

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
            child: option('Check List', 'Lista de unidades para generar un Check List', Icons.checklist, const Color(0XFF09AD92)),
          ),
          SizedBox(height: ScreenUtil().setWidth(30)),
          InkWell(
            onTap: () {},
            child: option('Consulta de Información', 'Lista los Check List generados', Icons.search, const Color(0XFF09A8AD)),
          ),
          // InkWell(
          //   onTap: () {},
          //   child: buttomItem('Consulta de Información', 'Lista los Check List generados'),
          // ),
        ],
      ),
    );
  }

  Widget option(String titulo, String descripcion, IconData icon, Color color) {
    return Center(
      child: Container(
        height: ScreenUtil().setHeight(200),
        width: ScreenUtil().setWidth(200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.transparent.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(200),
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(10)),
                  Text(
                    descripcion,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    icon,
                    color: Colors.white,
                    size: ScreenUtil().setHeight(35),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(10),
                  bottom: ScreenUtil().setHeight(10),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget buttomItem(String titulo, String descripcion) {
  //   return Container(
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.transparent.withOpacity(0.2),
  //           spreadRadius: 2,
  //           blurRadius: 5,
  //           offset: const Offset(0, 3), // changes position of shadow
  //         ),
  //       ],
  //     ),
  //     margin: EdgeInsets.symmetric(
  //       horizontal: ScreenUtil().setWidth(16),
  //       vertical: ScreenUtil().setWidth(10),
  //     ),
  //     padding: EdgeInsets.symmetric(
  //       vertical: ScreenUtil().setHeight(20),
  //       horizontal: ScreenUtil().setWidth(10),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               titulo,
  //               style: TextStyle(
  //                 fontSize: ScreenUtil().setSp(18),
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //             Text(
  //               descripcion,
  //               style: TextStyle(
  //                 fontSize: ScreenUtil().setSp(12),
  //                 fontWeight: FontWeight.w400,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const Icon(
  //           Icons.arrow_forward_ios,
  //           color: Colors.green,
  //         )
  //       ],
  //     ),
  //   );
  // }
}
