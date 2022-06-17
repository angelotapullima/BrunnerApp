import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Empresa/clientes_model.dart';

class ClienteSearch extends StatefulWidget {
  const ClienteSearch({Key? key, required this.onChanged, required this.clientes}) : super(key: key);
  final ValueChanged<ClientesModel>? onChanged;
  final List<ClientesModel> clientes;

  @override
  State<ClienteSearch> createState() => _ClienteSearchState();
}

class _ClienteSearchState extends State<ClienteSearch> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchBloc = ProviderBloc.logisticaOP(context);
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
                  searchBloc.getProveedoresByQuery(query.trim());
                },
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  label: Text(
                    'Cliente',
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
                itemCount: widget.clientes.length + 1,
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
                            'Se encontraron ${widget.clientes.length} resultados',
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
                  var cliente = widget.clientes[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      widget.onChanged!(cliente);
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
                            '${cliente.nombreCliente}',
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
}
