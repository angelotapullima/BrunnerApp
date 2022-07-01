import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Ejecucion%20Servicio/personal_oe_model.dart';

class PersonalSearch extends StatefulWidget {
  const PersonalSearch({Key? key, required this.onChanged, required this.id}) : super(key: key);
  final ValueChanged<PersonalOEModel>? onChanged;
  final String id;

  @override
  State<PersonalSearch> createState() => _PersonalSearchState();
}

class _PersonalSearchState extends State<PersonalSearch> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchBloc = ProviderBloc.pos(context);
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
                  searchBloc.searchUnidades(widget.id, query.trim());
                },
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  label: Text(
                    'Personal',
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
              child: StreamBuilder<List<PersonalOEModel>>(
                stream: searchBloc.personalStream,
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
                          var persona = snapshot.data![index];
                          return InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              widget.onChanged!(persona);
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
                                    '${persona.nombre}',
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
                      child: Text('Sin Personal...'),
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

  Widget fileData(String titulo, String data, num size) {
    return RichText(
      text: TextSpan(
        text: '$titulo ',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: ScreenUtil().setSp(size),
        ),
        children: [
          TextSpan(
            text: data,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: ScreenUtil().setSp(11),
            ),
          )
        ],
      ),
    );
  }
}
