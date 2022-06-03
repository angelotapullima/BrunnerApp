import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_item_model.dart';

class ObservacionInspeccion extends StatelessWidget {
  const ObservacionInspeccion({Key? key, required this.tipoUnidad}) : super(key: key);
  final String tipoUnidad;

  @override
  Widget build(BuildContext context) {
    final observacionesBloc = ProviderBloc.consultaInsp(context);

    return StreamBuilder<List<InspeccionVehiculoItemModel>>(
      stream: observacionesBloc.observacionesCkeckStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return Column(
              children: snapshot.data!.asMap().entries.map((item) {
                int idx = item.key;
                return crearObservacionInspeccion(context, item.value, idx + 1);
              }).toList(),
            );

            // return SizedBox(
            //   height: ScreenUtil().setHeight(160) * snapshot.data!.length,
            //   child: ListView.builder(
            //       physics: const NeverScrollableScrollPhysics(),
            //       itemCount: snapshot.data!.length,
            //       itemBuilder: (_, index) => crearObservacionInspeccion(context, snapshot.data![index], index + 1)),
            // );
          } else {
            return SizedBox(
              height: ScreenUtil().setHeight(20),
            );
          }
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

  Widget crearObservacionInspeccion(BuildContext context, InspeccionVehiculoItemModel item, int index) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
        vertical: ScreenUtil().setHeight(8),
      ),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: ScreenUtil().setWidth(20),
            child: Text(
              index.toString(),
              style: TextStyle(
                fontSize: ScreenUtil().setSp(13),
              ),
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fileData('Clase', item.nombreCategoria.toString(), 11),
              SizedBox(height: ScreenUtil().setHeight(6)),
              fileData('Denominación', item.descripcionCheckItemInsp.toString(), 11),
              SizedBox(height: ScreenUtil().setHeight(6)),
              fileData('Observación', item.observacionCkeckItemInsp.toString(), 12),
              SizedBox(height: ScreenUtil().setHeight(6)),
              fileData('Atención', item.atencionCheckItemInsp.toString(), 12),
              SizedBox(height: ScreenUtil().setHeight(6)),
              fileData('Responsable', item.responsableCheckItemInsp.toString(), 11),
            ],
          ))
        ],
      ),
    );
  }

  Widget fileData(String titulo, String data, num size) {
    return RichText(
      text: TextSpan(
          text: '$titulo: ',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: ScreenUtil().setSp(size),
          ),
          children: [
            TextSpan(
              text: data,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: ScreenUtil().setSp(size),
              ),
            )
          ]),
    );
  }
}
