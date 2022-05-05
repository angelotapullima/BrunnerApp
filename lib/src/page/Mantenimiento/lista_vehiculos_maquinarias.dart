import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/core/routes_constanst.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/vehiculo_model.dart';

class ListaVehiculosMaquinarias extends StatefulWidget {
  const ListaVehiculosMaquinarias({Key? key}) : super(key: key);

  @override
  State<ListaVehiculosMaquinarias> createState() => _ListaVehiculosMaquinariasState();
}

class _ListaVehiculosMaquinariasState extends State<ListaVehiculosMaquinarias> {
  final searchController = TextEditingController();
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
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) {
                          final vehiculo = snapshot.data![index];
                          return _vehiculoItem(vehiculo);
                        });
                  } else {
                    return Container();
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
    Color color = Colors.green;

    switch (vehiculo.estadoInspeccionVehiculo) {
      case '1':
        color = Colors.green;
        break;
      case '2':
        color = Colors.deepOrangeAccent;
        break;
      case '3':
        color = Colors.deepOrangeAccent;
        break;
      default:
        color = Colors.green;
        break;
    }
    return Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(16),
          vertical: ScreenUtil().setHeight(10),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(
              width: ScreenUtil().setWidth(100),
              child: Stack(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(100),
                    height: ScreenUtil().setHeight(100),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(100),
                    height: ScreenUtil().setHeight(100),
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
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(90)),
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
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(90)),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Text(vehiculo.razonSocialVehiculo.toString())),
          ],
        ));
  }
}
