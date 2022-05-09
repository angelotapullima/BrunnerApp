import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/check_item_inspeccion_model.dart';

class ObservacionesInspeccion extends StatelessWidget {
  const ObservacionesInspeccion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final observacionesBloc = ProviderBloc.checklist(context);

    return StreamBuilder<List<CheckItemInspeccionModel>>(
      stream: observacionesBloc.observacionesCkeckStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            // return Column(
            //   children: snapshot.data!.map((item) => crearObservacionInspeccion(context, item, 1)).toList(),
            // );

            return SizedBox(
              height: ScreenUtil().setHeight(80) * snapshot.data!.length,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => crearObservacionInspeccion(context, snapshot.data![index], index + 1)),
            );
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

  Widget crearObservacionInspeccion(BuildContext context, CheckItemInspeccionModel item, int index) {
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
          Text(
            index.toString(),
            style: TextStyle(
              fontSize: ScreenUtil().setSp(13),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(100),
            child: Text(
              '${item.descripcionCheckItemInsp.toString().trim()} [${item.conteoCheckItemInsp.toString().trim()}]',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(12),
              ),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(150),
            child: Text(
              item.observacionCkeckItemInsp.toString().trim(),
              style: TextStyle(
                fontSize: ScreenUtil().setSp(13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
