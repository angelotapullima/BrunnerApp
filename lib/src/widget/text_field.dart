import 'package:flutter/material.dart';

class TextFieldSelect extends StatelessWidget {
  const TextFieldSelect(
      {Key? key,
      required this.label,
      required this.hingText,
      required this.controller,
      this.widget,
      required this.readOnly,
      this.ontap,
      this.icon,
      this.autofocus = false})
      : super(key: key);
  final String label;
  final String hingText;
  final Function()? ontap;
  final TextEditingController controller;
  final Widget? widget;
  final bool readOnly;
  final bool? icon;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      controller: controller,
      maxLines: null,
      style: const TextStyle(
        color: Color(0xff808080),
      ),
      autofocus: autofocus,
      onTap: ontap,
      decoration: InputDecoration(
        suffix: (icon == true) ? null : widget,
        suffixIcon: (icon == true) ? widget : null,
        filled: true,
        fillColor: const Color(0xffeeeeee),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Color(0xffeeeeee),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Color(0xffeeeeee),
          ),
        ),
        hintStyle: const TextStyle(
          color: Color(0xff808080),
        ),
        hintText: hingText,
        labelText: label,
      ),
    );
  }
}
