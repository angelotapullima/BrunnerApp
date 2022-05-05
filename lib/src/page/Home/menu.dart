import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Menu/modulos_model.dart';
import 'package:new_brunner_app/src/model/Menu/submodulo_model.dart';
import 'package:new_brunner_app/src/page/Home/infouser.dart';
import 'package:new_brunner_app/src/page/Login/logout_page.dart';

class Menu extends StatelessWidget {
  final String? itemSeleccionado;
  final ValueChanged<String>? onSelectItem;
  const Menu({Key? key, @required this.itemSeleccionado, @required this.onSelectItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuBloc = ProviderBloc.modulo(context);
    menuBloc.getModulosUser();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Container(
          margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
          height: ScreenUtil().setHeight(50),
          child: Image.asset(
            'assets/img/logo.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(8),
                ),
                const InfoUser(),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Container(
                  height: ScreenUtil().setHeight(1),
                  width: ScreenUtil().setWidth(200),
                  color: Colors.green,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                StreamBuilder<List<ModulosModel>>(
                    stream: menuBloc.modulosStream,
                    builder: (_, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Container();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: snapshot.data!.map((item) => createModulos(item, context)).toList(),
                      );
                    }),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const LogoutPage();
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10), horizontal: ScreenUtil().setWidth(15)),
                    child: Text(
                      'CERRAR SESION',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(13),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
                // Column(
                //   children: widgets,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createModulos(ModulosModel modulo, BuildContext context) {
    return (modulo.idModulo == '9')
        ? InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const LogoutPage();
                  },
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10), horizontal: ScreenUtil().setWidth(15)),
              child: Text(
                modulo.nombreModulo.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(13),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          )
        : ExpansionTile(
            onExpansionChanged: (valor) {},
            maintainState: true,
            title: Text(
              modulo.nombreModulo.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(13),
                fontWeight: FontWeight.w400,
              ),
            ),
            children: modulo.subModulos!.map((item) => createSubModulo(item, context)).toList(),
          );
  }

  Widget createSubModulo(SubModuloModel item, BuildContext context) {
    return InkWell(
      onTap: () {
        onSelectItem!(item.idSubModulo.toString());
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: ScreenUtil().setHeight(5),
        ),
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(10), bottom: ScreenUtil().setHeight(10), left: ScreenUtil().setWidth(20)),
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(20), color: (itemSeleccionado == item.idSubModulo.toString()) ? Colors.green : Colors.transparent),
        child: Row(
          children: [
            SizedBox(
              child: SvgPicture.asset(
                'assets/svg/arrow.svg',
                color: (itemSeleccionado == item.idSubModulo.toString()) ? Colors.green : Colors.black,
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(19),
            ),
            Text(
              item.nameSubModulo.toString(),
              style: TextStyle(
                color: (itemSeleccionado == item.idSubModulo.toString()) ? Colors.green : Colors.black,
                fontSize: ScreenUtil().setSp(13),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget construirItem(ModulosModel item, BuildContext context) {
  //   return InkWell(
  //     onTap: () {
  //       // if (item.orden == 9) {
  //       //   Navigator.push(
  //       //     context,
  //       //     PageRouteBuilder(
  //       //       opaque: false,
  //       //       pageBuilder: (context, animation, secondaryAnimation) {
  //       //         //return LogoutPage();
  //       //         return Container();
  //       //       },
  //       //     ),
  //       //   );
  //       // } else {
  //       //   onSelectItem!(item);
  //       // }
  //     },
  //     child: Container(
  //       margin: EdgeInsets.only(
  //         bottom: ScreenUtil().setHeight(5),
  //       ),
  //       padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(15), horizontal: ScreenUtil().setWidth(5)),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       child: Row(
  //         children: [
  //           // Icon(
  //           //   item.icon,
  //           //   color: (itemSeleccionado == item) ? Colors.white : Colors.black,
  //           // ),
  //           // SizedBox(
  //           //   width: ScreenUtil().setWidth(19),
  //           // ),
  //           Text(
  //             item.nombreModulo.toString(),
  //             style: TextStyle(
  //               color: Colors.black,
  //               fontSize: ScreenUtil().setSp(13),
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
