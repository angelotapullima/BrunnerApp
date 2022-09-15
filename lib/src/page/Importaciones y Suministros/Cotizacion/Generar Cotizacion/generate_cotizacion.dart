import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Consulta%20Externa/consulta_externa_api.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/button_icon_widget.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';
import 'package:new_brunner_app/src/widget/text_field.dart';

class GenerateCotizacion extends StatefulWidget {
  const GenerateCotizacion({Key? key}) : super(key: key);

  @override
  State<GenerateCotizacion> createState() => _GenerateCotizacionState();
}

class _GenerateCotizacionState extends State<GenerateCotizacion> {
  final _controller = CotizationController();
  final _typeDocController = TextEditingController();
  final _numberDocController = TextEditingController();
  final _dataBeneficierController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _registerDocController = TextEditingController();
  final _exchangeMoneyController = TextEditingController();
  final _dateVigencyController = TextEditingController();
  final _searchController = TextEditingController();

  final typeDocs = [
    {'id': '', 'name': 'Seleccionar'},
    {'id': '2', 'name': 'DNI'},
    {'id': '3', 'name': 'RUC'},
    {'id': '4', 'name': 'Carnet de Extranjería'},
    {'id': '5', 'name': 'Otros'},
  ];

  void initState() {
    DateTime date = DateTime.now().add(const Duration(days: 7));
    var dataInicio = "${date.year.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    var data =
        "${DateTime.now().year.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
    _dateVigencyController.text = dataInicio;
    Future.delayed(const Duration(microseconds: 100), () async {
      getExchangeMondey(data);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cotizacionBloc = ProviderBloc.cotizacion(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[700]!,
        title: Text(
          'Generar Cotización',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(14),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16), vertical: ScreenUtil().setHeight(10)),
                child: Column(
                  children: [
                    generalData(),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(16),
                        vertical: ScreenUtil().setHeight(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(8),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal[700]!),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(16),
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                label: Text(
                                  'Buscar Recurso en la Base de datos',
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
                              if (_searchController.value.text.isEmpty)
                                return showToast2('Debe ingresar el nombre del recurso a buscar', Colors.redAccent);
                              cotizacionBloc.getRecursosCotizacion(_searchController.value.text);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: Colors.teal[700]!,
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
                  ],
                )),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (_, p) {
              return ShowLoadding(
                active: _controller.isLoadding,
                h: double.infinity,
                w: double.infinity,
                fondo: Colors.black.withOpacity(0.6),
                colorText: Colors.black,
              );
            },
          ),
        ],
      ),
    );
  }

  void _selectTypeDoc() {
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
                initialChildSize: 0.7,
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
                            itemCount: typeDocs.length,
                            itemBuilder: (_, index) {
                              var item = typeDocs[index];
                              return InkWell(
                                onTap: () {
                                  _typeDocController.text = item["name"].toString();

                                  Navigator.pop(context);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(item["name"].toString()),
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

  Widget generalData() {
    return ExpansionTile(
      onExpansionChanged: (valor) {},
      maintainState: true,
      title: Text(
        'Datos Generales',
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: ScreenUtil().setSp(14),
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        TextFieldSelect(
          label: 'Tipo de Documento',
          hingText: 'Seleccionar tipo',
          controller: _typeDocController,
          widget: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.green,
          ),
          icon: true,
          readOnly: true,
          ontap: () {
            FocusScope.of(context).unfocus();
            _selectTypeDoc();
          },
        ),
        SizedBox(height: ScreenUtil().setHeight(15)),
        TextFieldSelect(
          label: 'Número de Documento',
          hingText: '',
          controller: _numberDocController,
          widget: Icon(
            Icons.numbers,
            color: Colors.green,
          ),
          icon: true,
          readOnly: false,
        ),
        SizedBox(height: ScreenUtil().setHeight(15)),
        TextFieldSelect(
          label: 'Datos del Beneficiario',
          hingText: '',
          controller: _dataBeneficierController,
          icon: false,
          readOnly: false,
        ),
        SizedBox(height: ScreenUtil().setHeight(15)),
        ButtonIconWiget(
          title: 'Buscar',
          iconButton: Icons.search,
          colorButton: Colors.teal[700]!,
          onPressed: () {
            FocusScope.of(context).unfocus();
            _dataBeneficierController.clear();
            searchDoc();
          },
        ),
        SizedBox(height: ScreenUtil().setHeight(15)),
        TextFieldSelect(
          label: 'Teléfono',
          hingText: '',
          controller: _phoneNumberController,
          keyboardType: TextInputType.number,
          widget: Icon(
            Icons.phone,
            color: Colors.green,
          ),
          icon: true,
          readOnly: false,
        ),
        SizedBox(height: ScreenUtil().setHeight(15)),
        TextFieldSelect(
          label: 'Email',
          hingText: '',
          controller: _emailController,
          widget: Icon(
            Icons.mail,
            color: Colors.green,
          ),
          icon: true,
          readOnly: false,
        ),
        SizedBox(height: ScreenUtil().setHeight(15)),
        TextFieldSelect(
          label: 'Documento del Registro',
          hingText: '',
          controller: _registerDocController,
          icon: false,
          readOnly: false,
        ),
        SizedBox(height: ScreenUtil().setHeight(15)),
        TextFieldSelect(
          label: 'Tipo de Cambio',
          hingText: '',
          keyboardType: TextInputType.number,
          controller: _exchangeMoneyController,
          icon: false,
          readOnly: false,
        ),
        SizedBox(height: ScreenUtil().setHeight(15)),
        TextFieldSelect(
          label: 'Fecha de Vigencia',
          hingText: '',
          controller: _dateVigencyController,
          widget: Icon(
            Icons.calendar_month,
            color: Colors.green,
          ),
          icon: true,
          readOnly: true,
          ontap: () {
            FocusScope.of(context).unfocus();
            selectdate(context, _dateVigencyController);
          },
        ),
      ],
    );
  }

  void searchDoc() async {
    switch (_typeDocController.value.text) {
      case 'DNI':
        if (_numberDocController.value.text.trim().length != 8) return showToast2('El DNI debe contener 8 dígitos', Colors.redAccent);
        final _api = ConsultaExternaApi();
        _controller.changeIsLoading(true);
        final res = await _api.searchDNI(_numberDocController.value.text);
        _controller.changeIsLoading(false);
        if (res.code != 200) return showToast2(res.message!, Colors.redAccent);
        showToast2('Datos Encontrados', Colors.teal[700]!);
        _dataBeneficierController.text = res.message!;
        break;
      case 'RUC':
        if (_numberDocController.value.text.trim().length != 11) return showToast2('El RUC debe contener 11 dígitos', Colors.redAccent);
        final _api = ConsultaExternaApi();
        _controller.changeIsLoading(true);
        final res = await _api.searchRUC(_numberDocController.value.text);
        _controller.changeIsLoading(false);
        if (res.code != 200) return showToast2(res.message!, Colors.redAccent);
        showToast2('Datos Encontrados', Colors.teal[700]!);
        _dataBeneficierController.text = res.message!;
        break;
      case 'Seleccionar':
        showToast2('Debe seleccionar un tipo de documento', Colors.redAccent);
        break;
      case '':
        showToast2('Debe seleccionar un tipo de documento', Colors.redAccent);
        break;
      default:
        showToast2('Otro Tipo de Documento Ingresado', Colors.black);
        break;
    }
  }

  void getExchangeMondey(String date) async {
    final _api = ConsultaExternaApi();
    final res = await _api.getTipoCambio(date);
    if (res.code == 200) _exchangeMoneyController.text = res.message!;
  }
}

class CotizationController extends ChangeNotifier {
  bool isLoadding = false;

  void changeIsLoading(bool value) {
    isLoadding = value;
    notifyListeners();
  }
}
