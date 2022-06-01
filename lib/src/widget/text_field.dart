import 'package:flutter/material.dart';

class TextFieldSelect extends StatelessWidget {
  const TextFieldSelect(
      {Key? key, required this.label, required this.hingText, required this.controller, required this.icon, required this.readOnly, this.ontap})
      : super(key: key);
  final String label;
  final String hingText;
  final Function()? ontap;
  final TextEditingController controller;
  final IconData icon;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      controller: controller,
      maxLines: null,
      style: const TextStyle(
        color: Color(0xff808080),
      ),
      onTap: ontap,
      decoration: InputDecoration(
        suffixIcon: Icon(
          icon,
          color: Colors.green,
        ),
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
