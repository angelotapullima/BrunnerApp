import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

PopupMenuItem options(IconData icon, Color colorIcon, String title, Color colorText, int value) {
  return PopupMenuItem(
    child: Row(
      children: [
        Icon(
          icon,
          color: colorIcon,
        ),
        SizedBox(
          width: ScreenUtil().setWidth(8),
        ),
        Text(
          title,
          style: TextStyle(color: colorText),
        ),
      ],
    ),
    value: value,
  );
}
