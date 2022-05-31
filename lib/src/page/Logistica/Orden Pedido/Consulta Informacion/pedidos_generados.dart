import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PedidosGenerados extends StatelessWidget {
  const PedidosGenerados({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF154360),
        title: Text(
          'Listado de Orden de Pedido Generadas',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(14),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            autofocus: true,
            onPressed: () {
              //filtroSearch();
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
