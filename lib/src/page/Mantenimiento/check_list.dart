import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/vehiculo_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/choferes_search.dart';
import 'package:provider/provider.dart';

class CheckList extends StatelessWidget {
  const CheckList({Key? key, required this.vehiculo}) : super(key: key);
  final VehiculoModel vehiculo;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ConductorController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Listado de verificación de unidade',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          placa(
            vehiculo.placaVehiculo.toString(),
            Icons.bus_alert,
            (vehiculo.estadoInspeccionVehiculo == '2')
                ? Colors.orangeAccent
                : (vehiculo.estadoInspeccionVehiculo == '3')
                    ? Colors.redAccent
                    : const Color(0XFF09AD92),
          ),
          const Divider(),
          const Text(
            'Información del conductor',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: ScreenUtil().setHeight(5)),
          ValueListenableBuilder(
            valueListenable: provider.conductorS,
            builder: (BuildContext context, String data, Widget? child) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const ChoferesSearch();
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
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(data),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          const Divider(),
          const Text(
            'Sistemas de la unidad',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: ScreenUtil().setHeight(5)),
        ],
      ),
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
}

class ConductorController extends ChangeNotifier {
  ValueNotifier<String> id = ValueNotifier('Seleccionar');
  ValueNotifier<String> conductor = ValueNotifier('Seleccionar');

  ValueNotifier<String> get idS => id;
  ValueNotifier<String> get conductorS => conductor;

  void setData(String idC, String conductorN) {
    id.value = idC;
    conductor.value = conductorN;
  }
}
