import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultNumberWidget extends StatelessWidget {
  const ResultNumberWidget({Key? key, required this.number}) : super(key: key);
  final int number;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Se encontraron ${number} resultados',
            style: TextStyle(
              color: Colors.grey,
              fontSize: ScreenUtil().setSp(10),
            ),
          ),
        ],
      ),
    );
  }
}
