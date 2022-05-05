import 'package:flutter/material.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/page/Home/home.dart';
import 'package:new_brunner_app/src/page/Login/login.dart';
import 'package:new_brunner_app/src/page/splash.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const Login());
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const Splash());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const Home());

      default:
        return MaterialPageRoute(builder: (_) => const Splash());
    }
  }
}
