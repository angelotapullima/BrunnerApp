import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Mantenimiento/inspeccion_api.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Consulta%20Informacion/check_categorias_inspeccion.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Consulta%20Informacion/observacion_inspeccion.dart';
import 'package:new_brunner_app/src/util/utils.dart';

class InspeccionDetalle extends StatefulWidget {
  const InspeccionDetalle({Key? key, required this.inspeccion}) : super(key: key);
  final InspeccionVehiculoModel inspeccion;

  @override
  State<InspeccionDetalle> createState() => _InspeccionDetalleState();
}

class _InspeccionDetalleState extends State<InspeccionDetalle> {
  final controller = CargandoController();
  @override
  Widget build(BuildContext context) {
    final inspeccionBloc = ProviderBloc.consultaInsp(context);
    inspeccionBloc.getDetalleInspeccionDetalle(widget.inspeccion.idInspeccionVehiculo.toString(), widget.inspeccion.tipoUnidad.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalle CheckList',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          StreamBuilder<List<InspeccionVehiculoModel>>(
            stream: inspeccionBloc.inspeccionDetalleStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  final dato = snapshot.data![0];

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: fileData('Lista de verificacion de unidades', 'N° ${dato.numeroInspeccionVehiculo}', 15),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(16),
                            vertical: ScreenUtil().setHeight(2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${obtenerFecha(widget.inspeccion.fechaInspeccionVehiculo.toString())} ${widget.inspeccion.horaInspeccionVehiculo}',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(11),
                                ),
                              ),
                            ],
                          ),
                        ),
                        placa(
                          dato.placaVehiculo.toString(),
                          Icons.bus_alert,
                          (dato.estadoCheckInspeccionVehiculo == '2')
                              ? Colors.orangeAccent
                              : (dato.estadoCheckInspeccionVehiculo == '3')
                                  ? Colors.redAccent
                                  : const Color(0XFF09AD92),
                        ),
                        const Divider(),
                        Text(
                          'INFORMACIÓN DEL CONDUCTOR',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(14)),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(8)),
                        fileData('N° Documento', '${dato.documentoChofer}', 13),
                        SizedBox(height: ScreenUtil().setHeight(5)),
                        fileData('Nombre y Apellido', '${dato.nombreChofer}', 13),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        const Divider(),
                        Text(
                          'PRE-USO DE VEHICULO',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(14)),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                              child: const Text('Estado'),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(16),
                            vertical: ScreenUtil().setHeight(4),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: ScreenUtil().setWidth(220)),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.green),
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.orangeAccent),
                                ),
                                child: const Icon(
                                  Icons.error_rounded,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CheckCategoriasInspeccion(
                          tipoUnidad: dato.tipoUnidad.toString(),
                          idInpeccionVehiculo: dato.idInspeccionVehiculo.toString(),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        const Divider(),
                        _imputText(dato.hidrolinaVehiculo.toString(), dato.kilometrajeVehiculo.toString()),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        const Divider(),
                        Text(
                          'REPORTE DE OBSERVACIONES',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(14)),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        ObservacionInspeccion(
                          tipoUnidad: dato.tipoUnidad.toString(),
                        ),
                        _buttonPDF(dato.idInspeccionVehiculo.toString()),
                        _buttonDelete(context),
                        SizedBox(height: ScreenUtil().setHeight(20)),
                      ],
                    ),
                  );
                } else {
                  return const Text('Sin datos encontrados...');
                }
              } else {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            },
          ),
          cargando(),
        ],
      ),
    );
  }

  cargando() {
    return AnimatedBuilder(
        animation: controller,
        builder: (_, c) {
          return (controller.cargando)
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(child: CupertinoActivityIndicator()),
                )
              : Container();
        });
  }

  Widget fileData(String titulo, String data, num size) {
    return RichText(
      text: TextSpan(
          text: '$titulo: ',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: ScreenUtil().setSp(size),
          ),
          children: [
            TextSpan(
              text: data,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtil().setSp(size),
              ),
            )
          ]),
    );
  }

  Widget placa(String titulo, IconData icon, Color color) {
    return Center(
      child: Container(
        height: ScreenUtil().setHeight(70),
        width: ScreenUtil().setWidth(155),
        margin: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(10),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: Stack(
          children: [
            Container(
              height: ScreenUtil().setHeight(70),
              width: ScreenUtil().setWidth(150),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(100),
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  titulo,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(20),
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(1),
                  bottom: ScreenUtil().setHeight(2),
                ),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imputText(String galones, String km) {
    final _hidrolinaController = TextEditingController();
    final _kilometrajeController = TextEditingController();
    _hidrolinaController.text = galones.trim();
    _kilometrajeController.text = km.trim();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(16),
          ),
          Text(
            'Hidrolina',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          TextField(
            controller: _hidrolinaController,
            keyboardType: TextInputType.number,
            readOnly: true,
            style: const TextStyle(
              color: Color(0xff808080),
            ),
            decoration: InputDecoration(
              suffix: const Text(
                'Galones',
                style: TextStyle(color: Colors.blueGrey),
              ),
              filled: true,
              fillColor: const Color(0xffeeeeee),
              labelStyle: const TextStyle(
                color: Color(0xff808080),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: Color(0xffeeeeee),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: Color(0xffeeeeee),
                ),
              ),
              hintText: '0.00',
              hintStyle: const TextStyle(
                color: Color(0xff808080),
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(16),
          ),
          Text(
            (widget.inspeccion.tipoUnidad == '1') ? 'Kilometraje' : 'Horometraje',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          TextField(
            controller: _kilometrajeController,
            keyboardType: TextInputType.number,
            readOnly: true,
            textInputAction: TextInputAction.done,
            style: const TextStyle(
              color: Color(0xff808080),
            ),
            decoration: InputDecoration(
              suffix: Text(
                (widget.inspeccion.tipoUnidad == '1') ? 'KM' : 'Horas',
                style: const TextStyle(color: Colors.blueGrey),
              ),
              filled: true,
              fillColor: const Color(0xffeeeeee),
              labelStyle: const TextStyle(
                color: Color(0xff808080),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: Color(0xffeeeeee),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: Color(0xffeeeeee),
                ),
              ),
              hintText: '0.00',
              hintStyle: const TextStyle(
                color: Color(0xff808080),
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
        ],
      ),
    );
  }

  Widget _buttonPDF(String idInspeccion) {
    return InkWell(
      onTap: () async {
        controller.changeCargando(true);
        final _api = InspeccionApi();
        final res = await _api.getPDF(idInspeccion);
        if (res.code == 1) {
          _api.openFile(url: res.message.toString());
        } else {
          showToast2(res.message.toString(), Colors.red);
        }
        controller.changeCargando(false);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0XFF09A8AD),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Descargar',
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(20),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(8),
            ),
            const Icon(
              Icons.picture_as_pdf,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonDelete(BuildContext context) {
    return InkWell(
      onTap: () {
        final consultaInspBloc = ProviderBloc.consultaInsp(context);
        consultaInspBloc.getInspeccionesVehiculoQuery();
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
        ),
        child: Center(
          child: Text(
            'Eliminar',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: ScreenUtil().setSp(20),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class CargandoController extends ChangeNotifier {
  bool cargando = false;

  void changeCargando(bool c) {
    cargando = c;
    notifyListeners();
  }
}
