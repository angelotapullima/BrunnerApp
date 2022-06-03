import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/vehiculo_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/Check%20List/check_list.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/scan_qr_vehiculo_placa.dart';
import 'package:new_brunner_app/src/util/utils.dart';

class ListaVehiculosMaquinarias extends StatefulWidget {
  const ListaVehiculosMaquinarias({Key? key}) : super(key: key);

  @override
  State<ListaVehiculosMaquinarias> createState() => _ListaVehiculosMaquinariasState();
}

class _ListaVehiculosMaquinariasState extends State<ListaVehiculosMaquinarias> {
  final searchController = TextEditingController();
  int initCount = 0;
  @override
  Widget build(BuildContext context) {
    final searchVehiculoBloc = ProviderBloc.vehiculo(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Listado de Vehículos y Maquinarias',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return ScanQRVehiculoPlaca(
                  modulo: 'CHECK',
                );
              },
            ),
          );
        },
        icon: Icon(
          Icons.qr_code_scanner_outlined,
        ),
        label: Text('Escanear'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(16),
              vertical: ScreenUtil().setHeight(10),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(8),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      //hintText: 'RUC o Razón Social del propietario, Placa, Marca',
                      label: Text(
                        'RUC o Razón Social del propietario, Placa, Marca',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(12),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    initCount++;
                    final query = searchController.text.trim();
                    searchVehiculoBloc.searchVehiculos(query);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.transparent.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      'Buscar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<VehiculoModel>>(
              stream: searchVehiculoBloc.searchVehiculoStream,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
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
                          final vehiculo = snapshot.data![index];
                          return _vehiculoItem(vehiculo);
                        });
                  } else {
                    if (initCount == 0) {
                      return const Center(
                        child: Text('¡Buscar ahora!'),
                      );
                    }
                    return const Center(
                      child: Text('No se encontraron resultados para su búsqueda'),
                    );
                  }
                } else {
                  return const Center(child: CupertinoActivityIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehiculoItem(VehiculoModel vehiculo) {
    Color colorEstado = const Color(0XFF09AD92);
    IconData iconEstado = Icons.checklist_rounded;
    String textEstado = 'No existe Check List';

    switch (vehiculo.estadoInspeccionVehiculo) {
      case '1':
        colorEstado = const Color(0XFF09AD92);
        iconEstado = Icons.check_circle;
        textEstado = 'Habilitado';
        break;
      case '2':
        colorEstado = Colors.orangeAccent;
        iconEstado = Icons.error;
        textEstado = 'Habilitado con observaciones';
        break;
      case '3':
        colorEstado = Colors.redAccent;
        iconEstado = Icons.cancel;
        textEstado = 'Inhabilitado';
        break;
      default:
        colorEstado = const Color(0XFF09AD92);
        iconEstado = Icons.checklist_rounded;
        textEstado = 'No existe Check List';
        break;
    }
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return CheckList(
                vehiculo: vehiculo,
              );
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(16),
          vertical: ScreenUtil().setHeight(10),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.transparent.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: ScreenUtil().setWidth(100),
              height: ScreenUtil().setHeight(120),
              child: Stack(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(100),
                    height: ScreenUtil().setHeight(120),
                    decoration: BoxDecoration(
                      color: colorEstado,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(100),
                    height: ScreenUtil().setHeight(120),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(90),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: '$apiBaseURL/${vehiculo.imagenVehiculo}',
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                          child: const CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/img/logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
                            text: (vehiculo.tipoUnidad == '1') ? 'Vehiculo ' : 'Maquinaria',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: ScreenUtil().setSp(11),
                            ),
                            children: [
                              TextSpan(
                                text: vehiculo.carroceriaVehiculo ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenUtil().setSp(11),
                                ),
                              )
                            ]),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -8,
                    top: -8,
                    child: PopupMenuButton(
                      padding: const EdgeInsets.all(1),
                      icon: Icon(
                        iconEstado,
                        color: Colors.white.withOpacity(0.9),
                        size: ScreenUtil().setHeight(20),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text(
                            textEstado,
                            style: TextStyle(color: colorEstado),
                          ),
                          value: 1,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(8),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fileData('Placa', vehiculo.placaVehiculo.toString(), 12, 12, FontWeight.w400, FontWeight.w500, TextAlign.left),
                    Text(
                      vehiculo.razonSocialVehiculo.toString(),
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(12),
                      ),
                    ),
                    fileData('RUC', vehiculo.rucVehiculo.toString(), 11, 12, FontWeight.w500, FontWeight.w400, TextAlign.left),
                    fileData('Marca', vehiculo.marcaVehiculo.toString(), 11, 12, FontWeight.w500, FontWeight.w400, TextAlign.left),
                    fileData('Modelo', vehiculo.modeloVehiculo.toString(), 11, 12, FontWeight.w500, FontWeight.w400, TextAlign.left),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(4),
            ),
            const Icon(
              Icons.checklist,
              color: Colors.green,
            ),
            SizedBox(
              width: ScreenUtil().setWidth(4),
            ),
          ],
        ),
      ),
    );
  }
}
