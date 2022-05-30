import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/database/Mantenimiento/vehiculo_database.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/Check%20List/check_list.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({Key? key}) : super(key: key);

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcodeData;
  QRViewController? controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller?.dispose();
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
          qrView(context),
          Positioned(
            bottom: 10,
            right: 1,
            left: 1,
            child: Center(child: resultadoScanQR()),
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

  Widget resultadoScanQR() {
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
      onQRViewCreated: (valoor) {
        return onQRViewCreated2(valoor);
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
    controller.scannedDataStream.listen((barcode) async {
      setState(() {
        this.barcodeData = barcode;
      });
      final _db = VehiculoDatabase();
      final _vehiculo = await _db.getQRVehiculoByPlaca('${barcodeData!.code}');

      if (_vehiculo.isNotEmpty) {
        Navigator.pop(context);
        final provider = Provider.of<ConductorController>(context, listen: false);
        provider.setData('', 'Seleccionar');
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
      } else {
        showToast2('Vehículo no encontrado', Colors.red);
      }
    });
  }
}
