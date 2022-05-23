import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddAccionesResponsable extends StatelessWidget {
  const AddAccionesResponsable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mantenimiento Correctivo',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          // IconButton(
          //   autofocus: true,
          //   onPressed: () {
          //     filtroSearch();
          //   },
          //   icon: const Icon(Icons.search),
          // ),
        ],
      ),
    );
  }
}
