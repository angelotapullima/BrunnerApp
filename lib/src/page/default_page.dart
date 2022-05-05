import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/page/Home/menu_widget.dart';

class DefaultPage extends StatelessWidget {
  const DefaultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: const MenuWidget(),
      ),
      body: Center(
        child: SizedBox(
          width: ScreenUtil().setWidth(350),
          height: ScreenUtil().setHeight(350),
          child: const Image(
            image: AssetImage('assets/img/logo.png'),
          ),
        ),
      ),
    );
  }
}
