import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldSearch extends StatelessWidget {
  const TextFieldSearch({Key? key, required this.controller, this.onChanged}) : super(key: key);

  final Function(String v)? onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
        vertical: ScreenUtil().setHeight(10),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(8),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.left,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(16),
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.search),
          label: Text(
            'Buscar',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(14),
              fontWeight: FontWeight.w400,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
