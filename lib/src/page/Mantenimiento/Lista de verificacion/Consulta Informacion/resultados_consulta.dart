import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/Consulta%20Informacion/anular_inspeccion_vehiculo.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/Consulta%20Informacion/inspeccion_detalle.dart';
import 'package:new_brunner_app/src/util/utils.dart';

class ResultadosConsulta extends StatelessWidget {
  const ResultadosConsulta({Key? key, required this.inspecciones}) : super(key: key);
  final List<InspeccionVehiculoModel> inspecciones;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: inspecciones.length + 1,
        itemBuilder: (_, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(10),
                horizontal: ScreenUtil().setWidth(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Se encontraron ${inspecciones.length} resultados',
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
          return _inspeccionItem(context, inspecciones[index]);
        });
  }

  Widget _inspeccionItem(BuildContext context, InspeccionVehiculoModel inspeccion) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return InspeccionDetalle(
                inspeccion: inspeccion,
              );
            },
          ),
        );
      },
      child: (inspeccion.estadoFinal == '1')
          ? Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              confirmDismiss: (value) async {
                if (value == DismissDirection.endToStart) {
                  anularCheck(context, inspeccion, 1);
                  final consultaInspBloc = ProviderBloc.consultaInsp(context);
                  consultaInspBloc.getInspeccionesVehiculoQuery();

                  return true;
                } else {
                  return false;
                }
              },
              background: Container(
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(16)),
                color: Colors.redAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.cancel,
                          color: Colors.white,
                        ),
                        Text(
                          'Anular',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              child: contenido(inspeccion),
            )
          : contenido(inspeccion),
    );
  }

  Widget contenido(InspeccionVehiculoModel inspeccion) {
    Color colorEstado = const Color(0XFF09AD92);
    IconData iconEstado = Icons.checklist_rounded;
    String textEstado = 'No existe Check List';

    switch (inspeccion.estadoCheckInspeccionVehiculo) {
      case '1':
        colorEstado = const Color(0XFF09AD92);
        iconEstado = Icons.check_circle;
        textEstado = 'Habilitado';
        break;
      case '2':
        colorEstado = Colors.orangeAccent;
        iconEstado = Icons.error;
        textEstado = 'Habilitado con observaciones';
        break;
      case '3':
        colorEstado = Colors.redAccent;
        iconEstado = Icons.cancel;
        textEstado = 'Inhabilitado';
        break;
      default:
        colorEstado = const Color(0XFF09AD92);
        iconEstado = Icons.checklist_rounded;
        textEstado = 'No existe Check List';
        break;
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
        vertical: ScreenUtil().setHeight(10),
      ),
      decoration: BoxDecoration(
        color: (inspeccion.estadoFinal == '1') ? Colors.white : Colors.redAccent.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.transparent.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: ScreenUtil().setWidth(100),
            height: ScreenUtil().setHeight(120),
            child: Stack(
              children: [
                Container(
                  width: ScreenUtil().setWidth(100),
                  height: ScreenUtil().setHeight(120),
                  decoration: BoxDecoration(
                    color: colorEstado,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(100),
                  height: ScreenUtil().setHeight(120),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(90),
                      bottomLeft: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: '$apiBaseURL/${inspeccion.imageVehiculo}',
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                        child: const CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/img/icon_brunner.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: (inspeccion.tipoUnidad == '1') ? 'Vehiculo ' : 'Maquinaria ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil().setSp(11),
                        ),
                        children: [
                          TextSpan(
                            text: inspeccion.placaVehiculo ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -8,
                  top: -8,
                  child: PopupMenuButton(
                    padding: const EdgeInsets.all(1),
                    icon: Icon(
                      iconEstado,
                      color: Colors.white.withOpacity(0.9),
                      size: ScreenUtil().setHeight(20),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text(
                          textEstado,
                          style: TextStyle(color: colorEstado),
                        ),
                        value: 1,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(8),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fileData('N° CheckList', inspeccion.numeroInspeccionVehiculo.toString(), 12, 12, FontWeight.w400, FontWeight.w500, TextAlign.left),
                  fileData('Fecha', '${obtenerFecha(inspeccion.fechaInspeccionVehiculo.toString())} ${inspeccion.horaInspeccionVehiculo}', 11, 12,
                      FontWeight.w500, FontWeight.w400, TextAlign.left),
                  Text(
                    inspeccion.razonSocialVehiculo.toString(),
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(12),
                    ),
                  ),
                  fileData('Operador', inspeccion.nombreChofer.toString(), 11, 12, FontWeight.w500, FontWeight.w400, TextAlign.left),
                  fileData('Registrado por', inspeccion.nombreUsuario.toString(), 11, 12, FontWeight.w500, FontWeight.w400, TextAlign.left),
                ],
              ),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(4),
          ),
        ],
      ),
    );
  }
}
