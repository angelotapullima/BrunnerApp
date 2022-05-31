import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/vehiculo_database.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/Check%20List/check_list.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRVehiculoPlaca extends StatefulWidget {
  const ScanQRVehiculoPlaca({Key? key, required this.modulo}) : super(key: key);
  final String modulo;

  @override
  State<ScanQRVehiculoPlaca> createState() => _ScanQRVehiculoPlacaState();
}

class _ScanQRVehiculoPlacaState extends State<ScanQRVehiculoPlaca> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcodeData;
  QRViewController? controller;
  final _controller = ContadorQrBloc();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    controller?.resumeCamera();
    return Scaffold(
      body: Stack(
        children: [
          qrView(
            context,
          ),
          Positioned(
            bottom: 10,
            right: 1,
            left: 1,
            child: Center(child: resultadoScanQRVehiculoPlaca()),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: SafeArea(
              child: BackButton(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget resultadoScanQRVehiculoPlaca() {
    return Text(
      'Escanear QR',
      style: TextStyle(color: Colors.white),
      maxLines: 3,
      textAlign: TextAlign.center,
    );
  }

  Widget qrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: (value) {
        return onQRViewCreated2(value);
      },
      overlay: QrScannerOverlayShape(
        borderWidth: ScreenUtil().setWidth(15),
        borderRadius: 10,
        borderLength: 40,
        borderColor: Colors.green,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  void onQRViewCreated2(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen(
      (barcode) async {
        final _db = VehiculoDatabase();
        final _vehiculo = await _db.getQRVehiculoByPlaca('${barcode.code}');

        if (_vehiculo.isNotEmpty) {
          _controller.changeValorQr(0);
          if (_controller.valor.value == 0) {
            Navigator.pop(context);
            switch (widget.modulo) {
              case 'CHECK':
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return CheckList(
                        vehiculo: _vehiculo[0],
                      );
                    },
                  ),
                );
                break;
              case 'OHC':
                showToast2('Consultando por placa de vehículo ${_vehiculo[0].placaVehiculo}', Colors.green);
                final consultaDetallespBloc = ProviderBloc.ordenHab(context);
                consultaDetallespBloc.getInspeccionesById(_vehiculo[0].placaVehiculo.toString(), _vehiculo[0].tipoUnidad.toString());
                Navigator.pop(context);
                break;
              default:
                showToast2('Inténtelo nuevamente', Colors.black);
                break;
            }
            _controller.changeValorQr(1);
          }
        } else {
          controller.pauseCamera();

          showToast2('Vehículo no encontrado', Colors.red);
          _controller.changeValorQr(1);
          controller.resumeCamera();
        }
      },
    );
  }
}

class ContadorQrBloc with ChangeNotifier {
  ValueNotifier<int> _valor = ValueNotifier(0);
  ValueNotifier<int> get valor => this._valor;

  ValueNotifier<bool> _cargando = ValueNotifier(false);
  ValueNotifier<bool> get cargando => this._cargando;

  void changeValorQr(int val) {
    _valor.value = val;
    notifyListeners();
  }

  void changeCargando(bool val) {
    _cargando.value = val;
    notifyListeners();
  }
}
