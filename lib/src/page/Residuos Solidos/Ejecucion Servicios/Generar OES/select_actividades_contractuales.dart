import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/actividades_oe_model.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/text_field.dart';

class ActividadesContractualesSelect extends StatefulWidget {
  const ActividadesContractualesSelect({Key? key, required this.onChanged, required this.idPeriodo}) : super(key: key);
  final ValueChanged<ActividadesOEModel>? onChanged;
  final String idPeriodo;

  @override
  State<ActividadesContractualesSelect> createState() => _ActividadesContractualesSelectState();
}

class _ActividadesContractualesSelectState extends State<ActividadesContractualesSelect> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchBloc = ProviderBloc.ejecucionServicio(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButton(),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(16),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(8),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  searchBloc.searchActividadesContractualesQuery(query.trim(), widget.idPeriodo);
                },
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  label: Text(
                    'Actividad',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Expanded(
              child: StreamBuilder<List<ActividadesOEModel>>(
                stream: searchBloc.actividadesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length + 1,
                        itemBuilder: (_, index) {
                          if (index == 0) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Se encontraron ${snapshot.data!.length} resultados',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: ScreenUtil().setSp(10),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          index = index - 1;
                          var actividad = snapshot.data![index];
                          return InkWell(
                            onTap: () {
                              addCantidad(context, actividad);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(16),
                                vertical: ScreenUtil().setHeight(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${actividad.total} | ${actividad.nombreActividad} ${actividad.descripcionDetallePeriodo} | ${actividad.cantDetallePeriodo} ${actividad.umDetallePeriodo}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: ScreenUtil().setSp(14),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text('Sin Actividades...'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addCantidad(BuildContext context, ActividadesOEModel actividad) {
    TextEditingController _itemNameController = TextEditingController();
    TextEditingController _observacionesController = TextEditingController();
    _itemNameController.text =
        '${actividad.total} | ${actividad.nombreActividad} ${actividad.descripcionDetallePeriodo} | ${actividad.cantDetallePeriodo} ${actividad.umDetallePeriodo}';
    _observacionesController.text = actividad.cantDetallePeriodo ?? '';
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
                initialChildSize: 0.8,
                minChildSize: 0.3,
                maxChildSize: 0.9,
                builder: (_, controller) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
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
                                  height: ScreenUtil().setHeight(20),
                                ),
                                Text(
                                  'ASIGNAR ${actividad.umDetallePeriodo}',
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
                                  label: 'ACTIVIDAD',
                                  hingText: '',
                                  controller: _itemNameController,
                                  readOnly: true,
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(16),
                                ),
                                TextFieldSelect(
                                  label: '${actividad.umDetallePeriodo}',
                                  hingText: 'AGREGAR ${actividad.umDetallePeriodo}',
                                  controller: _observacionesController,
                                  readOnly: false,
                                  autofocus: true,
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(20),
                                ),
                                InkWell(
                                  onTap: () {
                                    FocusScope.of(context).requestFocus(FocusNode());

                                    if (_observacionesController.text.isEmpty) {
                                      final actividadModel = ActividadesOEModel();
                                      actividadModel.idDetallePeriodo = actividad.idDetallePeriodo;
                                      actividadModel.idPeriodo = actividad.idPeriodo;
                                      actividadModel.total = actividad.total;
                                      actividadModel.nombreActividad = actividad.nombreActividad;
                                      actividadModel.descripcionDetallePeriodo = actividad.descripcionDetallePeriodo;
                                      actividadModel.cantDetallePeriodo = '0';
                                      actividadModel.umDetallePeriodo = actividad.umDetallePeriodo;
                                      widget.onChanged!(actividadModel);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else {
                                      double max = double.parse(actividad.total.toString());
                                      double min = double.parse(_observacionesController.text);

                                      if (min <= max) {
                                        final actividadModel = ActividadesOEModel();
                                        actividadModel.idDetallePeriodo = actividad.idDetallePeriodo;
                                        actividadModel.idPeriodo = actividad.idPeriodo;
                                        actividadModel.total = actividad.total;
                                        actividadModel.nombreActividad = actividad.nombreActividad;
                                        actividadModel.descripcionDetallePeriodo = actividad.descripcionDetallePeriodo;
                                        actividadModel.cantDetallePeriodo = '$min';
                                        actividadModel.umDetallePeriodo = actividad.umDetallePeriodo;
                                        widget.onChanged!(actividadModel);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      } else {
                                        showToast2('La cantidad máxima es ${actividad.total ?? ""}', Colors.redAccent);
                                      }
                                    }
                                  },
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
                                        'Agregar',
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
                                  height: ScreenUtil().setHeight(15),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Center(
                                    child: Text(
                                      'Volver',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: ScreenUtil().setSp(20),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
