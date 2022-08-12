import 'package:flutter/material.dart';
import 'package:new_brunner_app/src/page/Home/menu_widget.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: const MenuWidget(),
      ),
    );
  }
}
