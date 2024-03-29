import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:new_brunner_app/src/page/Home/menu.dart';
import 'package:new_brunner_app/src/page/Importaciones%20y%20Suministros/Cotizacion/cotizaciones.dart';
import 'package:new_brunner_app/src/page/Logistica/Almacen/almacen.dart';
import 'package:new_brunner_app/src/page/Logistica/Orden%20Pedido/Consulta%20Informacion/consulta_informacion_orden_pedido.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/lista_verificacion.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/mantenimiento_correctivo.dart';
import 'package:new_brunner_app/src/page/Residuos%20Solidos/Ejecucion%20Servicios/ejecucion_servicios.dart';
import 'package:new_brunner_app/src/page/default_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String itemSeleccionado = '54';
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      borderRadius: 24,
      slideWidth: MediaQuery.of(context).size.width * 0.85,
      showShadow: false,
      angle: 0.0,
      menuBackgroundColor: Colors.white,
      mainScreenTapClose: true,
      //style: DrawerStyle.style1,
      menuScreen: Builder(
        builder: (context) => Menu(
          itemSeleccionado: itemSeleccionado,
          onSelectItem: (item) {
            setState(
              () {
                itemSeleccionado = item;
                ZoomDrawer.of(context)!.close();
              },
            );
          },
        ),
      ),
      mainScreen: obtenerPage(),
    );
  }

  Widget obtenerPage() {
    switch (itemSeleccionado) {
      case '35':
        return const ConsultaInformacionOrdenPedido();
      case '42':
        return const EjecucionServicios();
      case '44':
        return const Almacen();
      case '53':
        return const MantenimientoCorrectivo();
      case '54':
        return const ListaVerificacion();
      case '58':
        return const Cotizacion();
      default:
        return const DefaultPage();
    }
  }
}
