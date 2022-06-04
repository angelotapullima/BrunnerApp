import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Login/login_api.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwdController = TextEditingController();

  final _controller = ControllerLogin();

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(150),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                      child: Image.asset('assets/img/logo.png'),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(18),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(30),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
                      child: TextField(
                        maxLines: 1,
                        controller: _usuarioController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Usuario',
                          label: const Text('Usuario'),
                          hintStyle: TextStyle(
                            color: const Color(0XFF808080),
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setSp(16),
                            fontStyle: FontStyle.normal,
                          ),
                          filled: true,
                          fillColor: const Color(0XFFEEEEEE),
                          contentPadding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(5), bottom: ScreenUtil().setHeight(1)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: const Color(0XFFEEEEEE), width: ScreenUtil().setWidth(1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: const Color(0XFFEEEEEE), width: ScreenUtil().setWidth(1)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: const Color(0XFFEEEEEE), width: ScreenUtil().setWidth(1)),
                          ),
                        ),
                        style: TextStyle(
                          color: const Color(0XFF585858),
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil().setSp(16),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(16),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
                      child: TextField(
                        maxLines: 1,
                        controller: _passwdController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Contraseña',
                          label: const Text('Contraseña'),
                          hintStyle: TextStyle(
                            color: const Color(0XFF808080),
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setSp(16),
                            fontStyle: FontStyle.normal,
                          ),
                          filled: true,
                          fillColor: const Color(0XFFEEEEEE),
                          contentPadding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(5), bottom: ScreenUtil().setHeight(1)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: const Color(0XFFEEEEEE), width: ScreenUtil().setWidth(1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: const Color(0XFFEEEEEE), width: ScreenUtil().setWidth(1)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: const Color(0XFFEEEEEE), width: ScreenUtil().setWidth(1)),
                          ),
                        ),
                        style: TextStyle(
                          color: const Color(0XFF585858),
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil().setSp(16),
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(50),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
                      width: double.infinity,
                      child: MaterialButton(
                        height: ScreenUtil().setHeight(48),
                        color: Colors.green,
                        textColor: Colors.white,
                        elevation: 0,
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final user = _usuarioController.text.trim();
                          final pass = _passwdController.text.trim();
                          if (user.isNotEmpty) {
                            if (pass.isNotEmpty) {
                              _controller.changeLoadding(true);
                              final _login = LoginApi();
                              final res = await _login.login(_usuarioController.text, _passwdController.text);

                              if (res.code == 1) {
                                Navigator.pushNamedAndRemoveUntil(context, homeRoute, (route) => false);
                              } else {
                                showToast2(res.message ?? '', Colors.black);
                              }
                              _controller.changeLoadding(false);
                            } else {
                              showToast2('Ingrese su contraseña', Colors.black);
                            }
                          } else {
                            showToast2('Ingrese su usuario', Colors.black);
                          }
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: Text(
                          'Ingresar',
                          style: Theme.of(context).textTheme.button!.copyWith(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(16),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: ScreenUtil().setHeight(16),
                    // ),
                    // Text(
                    //   '¿Olvidó la contraseña?',
                    //   style: TextStyle(
                    //     color: Colors.green,
                    //     fontWeight: FontWeight.w500,
                    //     fontSize: ScreenUtil().setSp(12),
                    //     fontStyle: FontStyle.normal,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, snapshot) {
                return ShowLoadding(
                  active: _controller.loadding,
                  h: double.infinity,
                  w: double.infinity,
                  fondo: Colors.black.withOpacity(.3),
                  colorText: Colors.black,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ControllerLogin extends ChangeNotifier {
  bool loadding = false;
  void changeLoadding(bool v) {
    loadding = v;
    notifyListeners();
  }
}
