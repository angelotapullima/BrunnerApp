import 'package:flutter/material.dart';
import 'package:new_brunner_app/src/bloc/checklist_bloc.dart';
import 'package:new_brunner_app/src/bloc/consulta_inspeccion_bloc.dart';
import 'package:new_brunner_app/src/bloc/data_user_bloc.dart';
import 'package:new_brunner_app/src/bloc/ejecucion_servicio_bloc.dart';
import 'package:new_brunner_app/src/bloc/logistica_op_bloc.dart';
import 'package:new_brunner_app/src/bloc/mantenimiento_correctivo_bloc.dart';
import 'package:new_brunner_app/src/bloc/modulos_bloc.dart';
import 'package:new_brunner_app/src/bloc/orden_habilitacion_bloc.dart';
import 'package:new_brunner_app/src/bloc/personas_bloc.dart';
import 'package:new_brunner_app/src/bloc/vehiculo_bloc.dart';

class ProviderBloc extends InheritedWidget {
  final userBloc = DataUserBloc();
  final modulosBloc = ModulosBloc();

  //Personas
  final personasBloc = PersonasBloc();

  //Mantenimiento
  final vehiculosBloc = VehiculoBloc();
  final checklistBloc = CheckListBloc();
  final consultaInspBloc = ConsultaInspeccionBloc();
  //Mantenimiento Correctivo
  final mantenimientoCorrectivoBloc = MantenimientoCorrectivoBloc();
  //Orden Habilitacion
  final ordenHabilitacionBloc = OrdenHabilitacionCorrectivaBloc();
  //Logistica
  final logisticaOPBloc = LogisticaOPBloc();
  //Residuos Solidos
  final ejecucionServicioBloc = EjecucionServicioBloc();

  ProviderBloc({Key? key, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static DataUserBloc user(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.userBloc;
  }

  static ModulosBloc modulo(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.modulosBloc;
  }

  static VehiculoBloc vehiculo(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.vehiculosBloc;
  }

  static CheckListBloc checklist(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.checklistBloc;
  }

  static ConsultaInspeccionBloc consultaInsp(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.consultaInspBloc;
  }

  static MantenimientoCorrectivoBloc mantenimientoCorrectivo(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.mantenimientoCorrectivoBloc;
  }

  static OrdenHabilitacionCorrectivaBloc ordenHab(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.ordenHabilitacionBloc;
  }

  static PersonasBloc personas(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.personasBloc;
  }

  static LogisticaOPBloc logisticaOP(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.logisticaOPBloc;
  }

  static EjecucionServicioBloc ejecucionServicio(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.ejecucionServicioBloc;
  }
}
