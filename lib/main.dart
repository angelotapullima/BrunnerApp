import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/core/router.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/check_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  get splashRoute => null;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConductorController>(
          create: (_) => ConductorController(),
        ),
      ],
      child: ProviderBloc(
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Brunner',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            onGenerateRoute: Routers.generateRoute,
            initialRoute: splashRoute,
          ),
        ),
      ),
    );
  }
}
