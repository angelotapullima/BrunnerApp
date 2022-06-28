import 'package:flutter/material.dart';

class ResultPOS extends StatefulWidget {
  const ResultPOS({Key? key, required this.idEmpresa, required this.idDepartamento, required this.idSede}) : super(key: key);
  final String idEmpresa;
  final String idDepartamento;
  final String idSede;

  @override
  State<ResultPOS> createState() => _ResultPOSState();
}

class _ResultPOSState extends State<ResultPOS> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
