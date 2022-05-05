import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowLoadding extends StatelessWidget {
  const ShowLoadding({Key? key, required this.active, required this.h, required this.w, required this.colorText, required this.fondo})
      : super(key: key);
  final bool active;
  final double h, w;
  final Color colorText, fondo;

  @override
  Widget build(BuildContext context) {
    return (active)
        ? Container(
            height: h,
            width: w,
            color: fondo,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Text(
                  'Cargando...',
                  style: TextStyle(
                    color: colorText,
                    fontWeight: FontWeight.w400,
                    fontSize: ScreenUtil().setSp(14),
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
