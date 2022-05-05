import 'package:flutter/material.dart';
import 'package:new_brunner_app/src/bloc/data_user_bloc.dart';
import 'package:new_brunner_app/src/bloc/modulos_bloc.dart';

class ProviderBloc extends InheritedWidget {
  final userBloc = DataUserBloc();
  final modulosBloc = ModulosBloc();

  ProviderBloc({Key? key, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static DataUserBloc user(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.userBloc;
  }

  static ModulosBloc modulo(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.modulosBloc;
  }
}
