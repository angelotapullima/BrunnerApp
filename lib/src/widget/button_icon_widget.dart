import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonIconWiget extends StatelessWidget {
  const ButtonIconWiget({Key? key, required this.title, required this.colorButton, required this.iconButton, required this.onPressed})
      : super(key: key);
  final String title;
  final Color colorButton;
  final IconData iconButton;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(colorButton),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(15),
            vertical: ScreenUtil().setHeight(4),
          ),
        ),
      ),
      icon: Icon(
        iconButton,
        size: ScreenUtil().setHeight(25),
      ),
      label: Text(
        title,
        style: TextStyle(fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.w500),
      ),
    );
  }
}
