import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/personas_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Correctivo/asignar_responsable_mantenimiento.dart';
import 'package:provider/provider.dart';

class PersonMantenimiento extends StatefulWidget {
  const PersonMantenimiento({Key? key, required this.idInspeccionDetalle, required this.tipoUnidad}) : super(key: key);
  final String idInspeccionDetalle;
  final String tipoUnidad;

  @override
  State<PersonMantenimiento> createState() => _PersonMantenimientoState();
}

class _PersonMantenimientoState extends State<PersonMantenimiento> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchBloc = ProviderBloc.mantenimientoCorrectivo(context);
    searchBloc.getPersonasMantenimiento('');
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButton(),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(16),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(8),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  searchBloc.getPersonasMantenimiento(query.trim());
                },
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  label: Text(
                    'Nombre y apellido',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Expanded(
              child: StreamBuilder<List<PersonasModel>>(
                stream: searchBloc.personasStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length + 1,
                        itemBuilder: (_, index) {
                          if (index == 0) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Se encontraron ${snapshot.data!.length} resultados',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: ScreenUtil().setSp(10),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          index = index - 1;
                          var persona = snapshot.data![index];
                          return InkWell(
                            onTap: () {
                              if (widget.idInspeccionDetalle == '') {
                                Navigator.pop(context);
                                final provider = Provider.of<PersonaMantenimientoController>(context, listen: false);
                                String data = '';
                                data = '${persona.nombrePerson}';
                                provider.setData(persona.idPerson.toString(), data);
                              } else {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return AsignarResponsableMantenimiento(
                                        idIsnpeccionDetalle: widget.idInspeccionDetalle,
                                        idPerson: persona.idPerson.toString(),
                                        person: '${persona.nombrePerson}',
                                        tipoUnidad: widget.tipoUnidad,
                                      );
                                    },
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      var begin = const Offset(0.0, 1.0);
                                      var end = Offset.zero;
                                      var curve = Curves.ease;

                                      var tween = Tween(begin: begin, end: end).chain(
                                        CurveTween(curve: curve),
                                      );

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(16),
                                vertical: ScreenUtil().setHeight(8),
                              ),
                              child: Text('${persona.nombrePerson}'),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text('Sin información...'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PersonaMantenimientoController extends ChangeNotifier {
  ValueNotifier<String> id = ValueNotifier('');
  ValueNotifier<String> persona = ValueNotifier('Seleccionar...');

  ValueNotifier<String> get idS => id;
  ValueNotifier<String> get personaS => persona;

  void setData(String idC, String personaN) {
    id.value = idC;
    persona.value = personaN;
  }
}
