import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/categoria_inspeccion_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/item_inspeccion_model.dart';

class CategoriasInspeccion extends StatelessWidget {
  const CategoriasInspeccion({Key? key, required this.tipoUnidad}) : super(key: key);
  final String tipoUnidad;

  @override
  Widget build(BuildContext context) {
    final _catInspeccionBloc = ProviderBloc.checklist(context);
    _catInspeccionBloc.getCatInspeccion(tipoUnidad);
    return StreamBuilder<List<CategoriaInspeccionModel>>(
      stream: _catInspeccionBloc.catInspeccionStream,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Column(
            children: snapshot.data!.map((categoria) => crearCategoriaInspeccion(categoria, context)).toList(),
          );
        } else {
          return const Center(
            child: Text('Sin categorias disponibles'),
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
      children: categoria.itemsInspeccion!.map((item) => crearItemInspeccion(context, item)).toList(),
    );
  }

  Widget crearItemInspeccion(BuildContext context, ItemInspeccionModel item) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
        vertical: ScreenUtil().setHeight(8),
      ),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.conteoItemInspeccion.toString().trim(),
            style: TextStyle(
              fontSize: ScreenUtil().setSp(13),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(200),
            child: Text(
              item.descripcionItemInspeccion.toString().trim(),
              style: TextStyle(
                fontSize: ScreenUtil().setSp(13),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueGrey),
            ),
            child: const Icon(
              Icons.circle_outlined,
              color: Colors.blueGrey,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueGrey),
            ),
            child: const Icon(
              Icons.circle_outlined,
              color: Colors.blueGrey,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueGrey),
            ),
            child: const Icon(
              Icons.circle_outlined,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
