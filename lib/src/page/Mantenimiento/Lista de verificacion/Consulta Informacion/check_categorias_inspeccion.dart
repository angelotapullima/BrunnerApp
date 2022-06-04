import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_item_model.dart';

class CheckCategoriasInspeccion extends StatelessWidget {
  const CheckCategoriasInspeccion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inspeccionBloc = ProviderBloc.consultaInsp(context);

    return StreamBuilder<List<CategoriaInspeccionModel>>(
      stream: inspeccionBloc.catInspeccionStream,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Column(
            children: snapshot.data!.map((categoria) => crearCategoriaInspeccion(categoria, context)).toList(),
          );
        } else {
          return SizedBox(
            height: ScreenUtil().setHeight(30),
            child: const Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget crearCategoriaInspeccion(CategoriaInspeccionModel categoria, BuildContext context) {
    return ExpansionTile(
      backgroundColor: Colors.white,
      onExpansionChanged: (valor) {},
      maintainState: true,
      title: Text(
        categoria.descripcionCatInspeccion.toString(),
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: ScreenUtil().setSp(14),
          fontWeight: FontWeight.w500,
        ),
      ),
      children: categoria.checkInspeccionVehiculoItem!.map((item) => crearItemInspeccion(context, item)).toList(),
    );
  }

  Widget crearItemInspeccion(BuildContext context, InspeccionVehiculoItemModel item) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
        vertical: ScreenUtil().setHeight(8),
      ),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: (item.valueCheckItemInsp == '') ? Colors.blueGrey.withOpacity(0.15) : Colors.transparent,
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.conteoCheckItemInsp.toString().trim(),
            style: TextStyle(
              fontSize: ScreenUtil().setSp(13),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(200),
            child: Text(
              item.descripcionCheckItemInsp.toString().trim(),
              style: TextStyle(
                fontSize: ScreenUtil().setSp(13),
              ),
            ),
          ),
          check(
            context,
            (item.valueCheckItemInsp == '1') ? Icons.check_circle : Icons.circle_outlined,
            (item.valueCheckItemInsp == '1') ? Colors.green : Colors.blueGrey,
            '1',
            item,
          ),
          check(
            context,
            (item.valueCheckItemInsp == '2') ? Icons.error_rounded : Icons.circle_outlined,
            (item.valueCheckItemInsp == '2') ? Colors.orangeAccent : Colors.blueGrey,
            '2',
            item,
          ),
          check(
            context,
            (item.valueCheckItemInsp == '3') ? Icons.cancel : Icons.circle_outlined,
            (item.valueCheckItemInsp == '3') ? Colors.redAccent : Colors.blueGrey,
            '3',
            item,
          ),
        ],
      ),
    );
  }

  Widget check(BuildContext context, IconData icon, Color color, String value, InspeccionVehiculoItemModel item) {
    return Container(
      decoration: BoxDecoration(
        color: (item.valueCheckItemInsp == '') ? Colors.blueGrey.withOpacity(0.1) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: color),
      ),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }
}
