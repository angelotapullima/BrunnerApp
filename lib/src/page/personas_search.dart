import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/personas_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Correctivo/asignar_responsable_mantenimiento.dart';

class PersonasSearch extends StatefulWidget {
  const PersonasSearch({Key? key, required this.cargo, required this.onChanged, required this.idInspeccionDetalle, this.tipoUnidad})
      : super(key: key);
  final String cargo;
  final ValueChanged<PersonasModel>? onChanged;
  final String idInspeccionDetalle;
  final String? tipoUnidad;

  @override
  State<PersonasSearch> createState() => _PersonasSearchState();
}

class _PersonasSearchState extends State<PersonasSearch> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchBloc = ProviderBloc.personas(context);

    if (widget.cargo == 'MANTENIMIENTO') {
      searchBloc.searchPersonasMantenimiento('');
    } else {
      searchBloc.searchPersons('');
    }

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
                  if (widget.cargo == 'MANTENIMIENTO') {
                    searchBloc.searchPersonasMantenimiento(query.trim());
                  } else {
                    searchBloc.searchPersons(query.trim());
                  }
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
                stream: searchBloc.searchStream,
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
                          var person = snapshot.data![index];
                          return InkWell(
                            onTap: () {
                              if (widget.idInspeccionDetalle != '') {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return AsignarResponsableMantenimiento(
                                        idIsnpeccionDetalle: widget.idInspeccionDetalle.toString(),
                                        idPerson: person.idPerson.toString(),
                                        person: '${person.nombrePerson}',
                                        tipoUnidad: widget.tipoUnidad.toString(),
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
                              } else {
                                Navigator.pop(context);
                                widget.onChanged!(person);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(16),
                                vertical: ScreenUtil().setHeight(8),
                              ),
                              child: Text('${person.dniPerson}  |  ${person.nombrePerson}'),
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
