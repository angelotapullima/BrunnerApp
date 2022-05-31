import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionWidget extends StatelessWidget {
  const OptionWidget({Key? key, required this.titulo, required this.descripcion, required this.icon, required this.color}) : super(key: key);
  final String titulo;
  final String descripcion;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: ScreenUtil().setHeight(200),
        width: ScreenUtil().setWidth(200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.transparent.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(200),
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(10)),
                  Padding(
                    padding: EdgeInsets.only(right: ScreenUtil().setWidth(8)),
                    child: Text(
                      descripcion,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(12),
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    icon,
                    color: Colors.white,
                    size: ScreenUtil().setHeight(35),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(10),
                  bottom: ScreenUtil().setHeight(10),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
