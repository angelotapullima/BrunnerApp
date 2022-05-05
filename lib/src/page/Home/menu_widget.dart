import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ZoomDrawer.of(context)!.toggle();
      },
      child: Container(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(24),
        ),
        height: ScreenUtil().setHeight(45),
        width: ScreenUtil().setWidth(45),
        child: const Icon(Icons.menu),
      ),
    );
  }
}
