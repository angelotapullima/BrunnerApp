import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/consulta_oe_bloc.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Consulta%20Informacion%20OE/oes_model.dart';
import 'package:new_brunner_app/src/page/Residuos%20Solidos/Ejecucion%20Servicios/Consulta%20Info%20OE/aprobar_oe.dart';
import 'package:new_brunner_app/src/page/Residuos%20Solidos/Ejecucion%20Servicios/Consulta%20Info%20OE/eliminar_oe.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';
import 'package:new_brunner_app/src/widget/widget_all.dart';

class PendientesOES extends StatelessWidget {
  const PendientesOES({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _consultaOEBloc = ProviderBloc.consultaOE(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          'Listado de OES pendientes de aprobación',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(12),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _consultaOEBloc.getOESPendientes();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: StreamBuilder<bool>(
        stream: _consultaOEBloc.cargandoStream,
        builder: (_, t) {
          if (t.hasData && !t.data!) {
            return StreamBuilder<List<OESModel>>(
              stream: _consultaOEBloc.oesStream,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return SingleChildScrollView(
                      child: Column(
                        children: snapshot.data!.asMap().entries.map((item) {
                          int idx = item.key;
                          return _oesItem(context, item.value, idx + 1, _consultaOEBloc);
                        }).toList(),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text('No existen OES pendientes de aprobación'),
                    );
                  }
                } else {
                  return ShowLoadding(
                    active: true,
                    h: double.infinity,
                    w: double.infinity,
                    fondo: Colors.transparent,
                    colorText: Colors.black,
                  );
                }
              },
            );
          } else {
            return ShowLoadding(
              active: true,
              h: double.infinity,
              w: double.infinity,
              fondo: Colors.transparent,
              colorText: Colors.black,
            );
          }
        },
      ),
    );
  }

  Widget _oesItem(BuildContext context, OESModel item, int number, ConsultaOEBloc bloc) {
    return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          case 0:
            break;
          case 3:
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return AprobarOE(
                    modulo: 'oes',
                    id: item.idEjecucion.toString(),
                    onChanged: (val) {
                      if (val == 1) {
                        bloc.getOESPendientes();
                      }
                    },
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
            break;
          case 4:
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return EliminarOE(
                    modulo: 'oes',
                    id: item.idEjecucion.toString(),
                    estado: '1',
                    onChanged: (val) {
                      if (val == 1) {
                        bloc.getOESPendientes();
                      }
                    },
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
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => [
        options(Icons.remove_red_eye, Colors.blueGrey, 'Visualizar', Colors.black, 1),
        options(Icons.edit, Colors.green, 'Editar', Colors.black, 2),
        options(Icons.check, Colors.blue, 'Aprobar', Colors.black, 3),
        options(Icons.close, Colors.redAccent, 'Eliminar', Colors.redAccent, 4),
      ],
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(16),
          vertical: ScreenUtil().setHeight(10),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Text('$number'),
                SizedBox(width: ScreenUtil().setWidth(8)),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    padding: EdgeInsets.all(8),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        fileData('Empresa', item.nombreEmpresa ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                        fileData('Unidad Ejecutora', item.nombreDepartamento ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                        fileData('Sede', item.nombreSede ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                        fileData('Cliente', item.clienteNombre ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                        fileData('Descripción', item.descripcionEjecucion ?? '', 10, 12, FontWeight.w600, FontWeight.w500, TextAlign.start),
                        fileData('Solicitado por', "${item.nameCreated ?? ''} ${item.surmaneCreated ?? ''}", 10, 12, FontWeight.w600, FontWeight.w400,
                            TextAlign.start),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: ScreenUtil().setWidth(110),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    "${obtenerFecha(item.fechaEjecucion ?? '')}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenUtil().setSp(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
