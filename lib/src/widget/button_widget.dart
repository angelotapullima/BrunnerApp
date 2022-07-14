import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({Key? key, required this.titulo, required this.color, required this.sizeTitle, required this.width, this.onTap})
      : super(key: key);
  final String titulo;
  final Function()? onTap;
  final Color color;
  final double width;
  final double sizeTitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            titulo,
            style: TextStyle(
              color: Colors.white,
              fontSize: sizeTitle,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
