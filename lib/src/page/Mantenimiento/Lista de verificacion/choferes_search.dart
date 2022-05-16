import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/choferes_model.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Lista%20de%20verificacion/Check%20List/check_list.dart';
import 'package:provider/provider.dart';

class ChoferesSearch extends StatefulWidget {
  const ChoferesSearch({Key? key, required this.page}) : super(key: key);
  final String page;

  @override
  State<ChoferesSearch> createState() => _ChoferesSearchState();
}

class _ChoferesSearchState extends State<ChoferesSearch> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchBloc = ProviderBloc.checklist(context);
    searchBloc.searchVehiculos('');
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
              child: Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: (query) {
                    searchBloc.searchVehiculos(query.trim());
                  },
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search),
                    label: Text(
                      'Nombre y apellido',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(12),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Expanded(
              child: StreamBuilder<List<ChoferesModel>>(
                stream: searchBloc.choferesStream,
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
                          var chofer = snapshot.data![index];
                          return InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              final provider = Provider.of<ConductorController>(context, listen: false);
                              String data = '';
                              if (widget.page == 'Check') {
                                data = '${chofer.dniChofer}  |  ${chofer.nombreChofer}';
                              } else {
                                data = '${chofer.nombreChofer}';
                              }
                              provider.setData(chofer.idChofer.toString(), data);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(16),
                                vertical: ScreenUtil().setHeight(8),
                              ),
                              child: Text('${chofer.dniChofer}  |  ${chofer.nombreChofer}'),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text('Sin conductores...'),
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
