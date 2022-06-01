import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/text_field.dart';

class PedidosGenerados extends StatefulWidget {
  const PedidosGenerados({Key? key}) : super(key: key);

  @override
  State<PedidosGenerados> createState() => _PedidosGeneradosState();
}

class _PedidosGeneradosState extends State<PedidosGenerados> {
  final _empresaController = TextEditingController();
  final _proveedorController = TextEditingController();
  final _numeroOPController = TextEditingController();
  final _estadoController = TextEditingController();
  final _rendicionesController = TextEditingController();
  final _fechaInicioController = TextEditingController();
  final _fechaFinController = TextEditingController();

  List<String> _estadoItems = ['Todos', 'Atendidos', 'Sin Atención', 'Atención Parcial'];
  List<String> _rendicionesItems = ['Todos', 'Rendidos', 'Pendientes de Rendir'];
  String _estado = '';
  String _rendicion = '';
  @override
  void initState() {
    var dataInicio = "${DateTime.now().year.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-01";
    var dataFin =
        "${DateTime.now().year.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
    _fechaInicioController.text = dataInicio;
    _fechaFinController.text = dataFin;
    Future.delayed(const Duration(microseconds: 100), () async {
      filtroSearch();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF154360),
        title: Text(
          'Listado de Orden de Pedido Generadas',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(14),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            autofocus: true,
            onPressed: () {
              filtroSearch();
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  void filtroSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          child: Container(
            color: const Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.8,
                minChildSize: 0.3,
                maxChildSize: 0.9,
                builder: (_, controller) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(24),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: ScreenUtil().setHeight(16),
                            ),
                            Center(
                              child: Container(
                                width: ScreenUtil().setWidth(100),
                                height: ScreenUtil().setHeight(5),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            Text(
                              'Filtros',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(20),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            TextFieldSelect(
                              label: 'Empresa Contratante',
                              hingText: 'Seleccionar empresa',
                              controller: _empresaController,
                              icon: Icons.keyboard_arrow_down,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Proveedor',
                              hingText: 'Seleccionar proveedor',
                              controller: _proveedorController,
                              icon: Icons.keyboard_arrow_down,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Número de OP',
                              hingText: '',
                              controller: _numeroOPController,
                              icon: Icons.numbers,
                              readOnly: false,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Estado',
                              hingText: 'Seleccionar estado',
                              controller: _estadoController,
                              icon: Icons.keyboard_arrow_down,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                _selectData(
                                  context: context,
                                  lista: _estadoItems,
                                  initSize: 0.4,
                                  tipo: 'ESTADO',
                                );
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Rendiciones',
                              hingText: 'Seleccionar',
                              controller: _rendicionesController,
                              icon: Icons.keyboard_arrow_down,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                _selectData(context: context, lista: _rendicionesItems, initSize: 0.3, tipo: 'RENDICION');
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Fecha de Inicio',
                              hingText: 'Seleccionar',
                              controller: _fechaInicioController,
                              icon: Icons.calendar_month_outlined,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                selectdate(context, _fechaInicioController);
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Fecha de Término',
                              hingText: 'Seleccionar',
                              controller: _fechaFinController,
                              icon: Icons.calendar_month_outlined,
                              readOnly: true,
                              ontap: () {
                                FocusScope.of(context).unfocus();
                                selectdate(context, _fechaFinController);
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            InkWell(
                              onTap: () async {},
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green,
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
                                    'Buscar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(20),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectData({required BuildContext context, required List<String> lista, required double initSize, required String tipo}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          child: Container(
            color: const Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: initSize,
                minChildSize: 0.2,
                maxChildSize: 0.9,
                builder: (_, controller) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.grey[600],
                        ),
                        Text(
                          'Seleccionar',
                          style: TextStyle(
                            color: const Color(0xff5a5a5a),
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(20),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: lista.length,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  if (tipo == 'ESTADO') {
                                    _estadoController.text = lista[index];
                                    switch (lista[index]) {
                                      case 'Todos':
                                        _estado = '1';
                                        break;
                                      case 'Atendidos':
                                        _estado = '2';
                                        break;
                                      case 'Sin Atención':
                                        _estado = '3';
                                        break;
                                      case 'Atención Parcial':
                                        _estado = '4';
                                        break;
                                      default:
                                        _estadoController.text = 'Todos';
                                        _estado = '1';
                                        break;
                                    }
                                  } else {
                                    _rendicionesController.text = lista[index];
                                    switch (lista[index]) {
                                      case 'Todos':
                                        _estado = '1';
                                        break;
                                      case 'Rendidos':
                                        _estado = '2';
                                        break;
                                      case 'Pendientes de Rendir':
                                        _estado = '3';
                                        break;
                                      default:
                                        _rendicionesController.text = 'Todos';
                                        _estado = '1';
                                        break;
                                    }
                                  }
                                  Navigator.pop(context);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(lista[index]),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
