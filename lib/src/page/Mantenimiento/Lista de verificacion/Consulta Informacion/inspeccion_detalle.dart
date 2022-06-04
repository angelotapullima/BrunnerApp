import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Mantenimiento/inspeccion_api.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/Consulta%20Informacion/anular_inspeccion_vehiculo.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/Consulta%20Informacion/check_categorias_inspeccion.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/Consulta%20Informacion/observacion_inspeccion.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/text_field.dart';

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
          StreamBuilder<bool>(
            stream: inspeccionBloc.cargando2Stream,
            builder: (_, c) {
              if (c.hasData && !c.data!) {
                return StreamBuilder<List<InspeccionVehiculoModel>>(
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
                                      '${obtenerFecha(dato.fechaInspeccionVehiculo.toString())} ${dato.horaInspeccionVehiculo}',
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
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.redAccent),
                                      ),
                                      child: const Icon(
                                        Icons.cancel,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const CheckCategoriasInspeccion(),
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
                              (dato.estadoFinal == '1' && widget.inspeccion.estadoFinal == '1') ? _buttonDelete(context, dato) : Container(),
                              SizedBox(height: ScreenUtil().setHeight(20)),
                            ],
                          ),
                        );
                      } else {
                        return Center(child: Text('Sin datos encontrados...'));
                      }
                    } else {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                  },
                );
              } else {
                return Center(child: CupertinoActivityIndicator());
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
          TextFieldSelect(
            label: '',
            hingText: '0.00',
            controller: _hidrolinaController,
            readOnly: true,
            widget: Text(
              'Galones',
              style: TextStyle(color: Colors.blueGrey),
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
          TextFieldSelect(
            label: '',
            hingText: '0.00',
            controller: _kilometrajeController,
            readOnly: true,
            widget: Text(
              (widget.inspeccion.tipoUnidad == '1') ? 'KM' : 'Horas',
              style: const TextStyle(color: Colors.blueGrey),
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
              'Visualizar',
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

  Widget _buttonDelete(BuildContext context, InspeccionVehiculoModel inspeccion) {
    return InkWell(
      onTap: () {
        // final consultaInspBloc = ProviderBloc.consultaInsp(context);
        // consultaInspBloc.getInspeccionesVehiculoQuery();
        // Navigator.pop(context);

        anularCheck(context, inspeccion, 2);
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
            'Anular',
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
