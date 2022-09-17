import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/model/Logistica/Cotizacion/recurso_cotizacion_model.dart';

class SelectRecurso extends StatefulWidget {
  const SelectRecurso({Key? key, required this.onChanged, required this.recursos}) : super(key: key);
  final ValueChanged<RecursoCotizacionModel>? onChanged;
  final List<RecursoCotizacionModel> recursos;

  @override
  State<SelectRecurso> createState() => _SelectRecursoState();
}

class _SelectRecursoState extends State<SelectRecurso> {
  final searchController = TextEditingController();
  List<RecursoCotizacionModel> listrecursos = [];

  @override
  void initState() {
    listrecursos = widget.recursos;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                onChanged: searchRecurso,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  label: Text(
                    'Recurso',
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
              child: ListView.builder(
                itemCount: listrecursos.length + 1,
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
                            'Se encontraron ${listrecursos.length} resultados',
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
                  var recurso = listrecursos[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      widget.onChanged!(recurso);
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
                            '${recurso.nameRecurso}',
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

  void searchRecurso(String query) {
    final suggestions = widget.recursos.where((recurso) {
      final nameRecurso = recurso.nameRecurso!.toUpperCase();
      final input = query.toUpperCase();

      return nameRecurso.contains(input);
    }).toList();

    setState(() {
      listrecursos = suggestions;
    });
  }
}
