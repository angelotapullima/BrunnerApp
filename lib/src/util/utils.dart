import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

void showToast2(String texto, Color color) {
  Fluttertoast.showToast(msg: texto, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3, backgroundColor: color, textColor: Colors.white);
}

obtenerFecha(String date) {
  if (date == 'null' || date == '') {
    return '';
  }

  var fecha = DateTime.parse(date);

  final DateFormat fech = DateFormat('dd MMM yyyy', 'es');

  return fech.format(fecha);
}

obtenerFechaHora(String date) {
  if (date == 'null' || date == '') {
    return '';
  }

  var fecha = DateTime.parse(date);

  final DateFormat fech = DateFormat('dd MMM yyyy kk:mm:ss', 'es');

  return fech.format(fecha);
}

Widget fileData(String titulo, String data, num sizeT, num sizeD, FontWeight ft, FontWeight fd, TextAlign aling) {
  return RichText(
    textAlign: aling,
    text: TextSpan(
      text: '$titulo: ',
      style: TextStyle(
        color: Colors.black,
        fontWeight: ft,
        fontSize: ScreenUtil().setSp(sizeT),
      ),
      children: [
        TextSpan(
          text: data,
          style: TextStyle(
            color: Colors.black,
            fontWeight: fd,
            fontSize: ScreenUtil().setSp(sizeD),
          ),
        )
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
