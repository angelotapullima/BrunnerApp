import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/vehiculo_model.dart';
import 'package:provider/provider.dart';

class VehiculosSearch extends StatefulWidget {
  const VehiculosSearch({Key? key, required this.tipoUnidad}) : super(key: key);
  final String tipoUnidad;

  @override
  State<VehiculosSearch> createState() => _VehiculosSearchState();
}

class _VehiculosSearchState extends State<VehiculosSearch> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchBloc = ProviderBloc.vehiculo(context);
    searchBloc.searchVehiculosByPlaca('', widget.tipoUnidad);
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
                  searchBloc.searchVehiculosByPlaca(query.trim(), widget.tipoUnidad);
                },
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  label: Text(
                    'Placa',
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
              child: StreamBuilder<List<VehiculoModel>>(
                stream: searchBloc.searchVehiculoPlacaStream,
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
                          var vehiculo = snapshot.data![index];
                          return InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              final provider = Provider.of<VehiculosController>(context, listen: false);
                              String data = '';
                              data = '${vehiculo.placaVehiculo}';
                              provider.setData(vehiculo.idVehiculo.toString(), data);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(16),
                                vertical: ScreenUtil().setHeight(8),
                              ),
                              child: Text('${vehiculo.placaVehiculo}'),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text('Sin vehiculos...'),
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
}

class VehiculosController extends ChangeNotifier {
  ValueNotifier<String> id = ValueNotifier('');
  ValueNotifier<String> placa = ValueNotifier('Seleccione');

  ValueNotifier<String> get idS => id;
  ValueNotifier<String> get placaS => placa;

  void setData(String idC, String placaN) {
    id.value = idC;
    placa.value = placaN;
  }
}
