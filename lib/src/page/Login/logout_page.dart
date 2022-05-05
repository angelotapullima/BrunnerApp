import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/core/preferences.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  String nombre = '';
  @override
  void initState() {
    firstName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(.3),
      child: Stack(
        fit: StackFit.expand,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: const Color.fromRGBO(0, 0, 0, 0.3),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            margin: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(326),
              horizontal: ScreenUtil().setWidth(40),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(24),
                vertical: ScreenUtil().setHeight(10),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: ScreenUtil().setHeight(40),
                    child: Image.asset(
                      'assets/img/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),
                  Text(
                    '¿$nombre, estás seguro de cerrar sesión?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: ScreenUtil().setSp(15),
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(14),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(32),
                      ),
                      InkWell(
                        onTap: () {
                          Preferences.deleteAllData();
                          final menuBloc = ProviderBloc.modulo(context);
                          menuBloc.deleteAll();
                          Navigator.pushNamedAndRemoveUntil(context, loginRoute, (r) => false);
                        },
                        child: Text(
                          'Salir',
                          style: TextStyle(
                            color: const Color(0XFFFF0F00),
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(14),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void firstName() async {
    String? nomb = await Preferences.readData('person_name');
    if (nomb!.isNotEmpty) {
      var nombres = nomb.split(' ');
      nombre = nombres[0];
      setState(() {});
    }
  }
}
