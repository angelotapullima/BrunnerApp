import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/api/Consulta%20Externa/consulta_externa_api.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Logistica/Cotizacion/recurso_cotizacion_model.dart';
import 'package:new_brunner_app/src/page/Importaciones%20y%20Suministros/Cotizacion/Generar%20Cotizacion/seleccionar_recurso.dart';
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

  int initCharge = 0;

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

    if (initCharge == 0) {
      cotizacionBloc.clearControllers();
      initCharge++;
    }
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
                  SizedBox(height: ScreenUtil().setHeight(15)),
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
                  StreamBuilder<int>(
                    stream: cotizacionBloc.resultApiStream,
                    builder: (_, r) {
                      if (!r.hasData)
                        return ShowLoadding(
                            active: true, h: ScreenUtil().setHeight(100), w: double.infinity, colorText: Colors.black, fondo: Colors.transparent);
                      if (r.data == 0)
                        return ShowLoadding(
                            active: true, h: ScreenUtil().setHeight(100), w: double.infinity, colorText: Colors.black, fondo: Colors.transparent);
                      if (r.data == 2) return Center(child: Text('Comience a buscar recurso'));
                      return StreamBuilder<List<RecursoCotizacionModel>>(
                        stream: cotizacionBloc.recursoCotizacionStream,
                        builder: (_, snapshopt) {
                          if (!snapshopt.hasData) return Center(child: Text('Comience a buscar recurso'));
                          if (snapshopt.data!.isEmpty) return Center(child: Text('Recurso no encontrado'));
                          return ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return SelectRecurso(
                                      onChanged: (recurso) {
                                        saveRecurso(recurso);
                                      },
                                      recursos: snapshopt.data!,
                                    );
                                  },
                                ),
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(Colors.teal[700]),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(15),
                                  vertical: ScreenUtil().setHeight(4),
                                ),
                              ),
                            ),
                            icon: Icon(
                              Icons.search,
                              size: ScreenUtil().setHeight(20),
                            ),
                            label: Text(
                              'Seleccionar Recurso',
                              style: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.w400),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Divider(),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (_, f) {
                      return (_controller.recursos.isEmpty)
                          ? Text(
                              'Información Registrada',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(16),
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : ExpansionTile(
                              initiallyExpanded: true,
                              maintainState: true,
                              title: Text(
                                'Información Registrada',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              children: _controller.recursos.map((item) => _recursoAgregado(item)).toList(),
                            );
                    },
                  ),
                  SizedBox(height: ScreenUtil().setHeight(15)),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_numberDocController.value.text.isEmpty) return showToast2('Debe Ingresar un Número de Documento', Colors.redAccent);
                      if (_dataBeneficierController.value.text.isEmpty)
                        return showToast2('Debe Ingresar los Datos del Beneficiario', Colors.redAccent);
                      if (_phoneNumberController.value.text.isEmpty) return showToast2('Debe Ingresar un Número de Teléfono', Colors.redAccent);
                      if (_registerDocController.value.text.isEmpty) return showToast2('Debe Ingresar el Documento de Registro', Colors.redAccent);
                      if (_exchangeMoneyController.value.text.isEmpty) return showToast2('El Tipo de Cambio no debe estar vacío', Colors.redAccent);
                      if (_dateVigencyController.value.text.isEmpty) return showToast2('Debe Ingresar una Fecha de Vigencia', Colors.redAccent);
                      if (_controller.recursos.isEmpty) return showToast2('Sin recursos agregados', Colors.redAccent);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.teal[700]),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(15),
                          vertical: ScreenUtil().setHeight(4),
                        ),
                      ),
                    ),
                    icon: Icon(
                      Icons.check,
                      size: ScreenUtil().setHeight(22),
                    ),
                    label: Text(
                      'Generar Registro',
                      style: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
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
            color: Colors.teal[700],
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
            color: Colors.teal[700],
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
            color: Colors.teal[700],
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
            color: Colors.teal[700],
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
            color: Colors.teal[700],
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

  Widget _recursoAgregado(RecursoCotizacionModel item) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(16),
              vertical: ScreenUtil().setHeight(10),
            ),
            padding: EdgeInsets.all(8),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
                fileData('Denominación', item.nameRecurso ?? '', 10, 12, FontWeight.w500, FontWeight.w500, TextAlign.start),
                fileData('U.M.', item.unidadRecurso ?? '', 10, 12, FontWeight.w600, FontWeight.w400, TextAlign.start),
                fileData('Tipo Recurso', item.nameType ?? '', 10, 14, FontWeight.w500, FontWeight.w600, TextAlign.start),
                fileData('Cantidad', item.quantity ?? '', 10, 14, FontWeight.w500, FontWeight.w600, TextAlign.start),
                fileData('Descuento', item.percent ?? '', 10, 14, FontWeight.w500, FontWeight.w600, TextAlign.start),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            _controller.removeRecurso(item.idLogisticaRecurso!);
          },
          icon: Icon(Icons.cancel),
          color: Colors.redAccent,
        ),
      ],
    );
  }

  void saveRecurso(RecursoCotizacionModel recurso) {
    final _denominacionController = TextEditingController();
    final _unidadController = TextEditingController();
    final _typeController = TextEditingController();
    final _cantidadController = TextEditingController();
    final _percentController = TextEditingController();

    _denominacionController.text = recurso.nameRecurso ?? '';
    _unidadController.text = recurso.unidadRecurso ?? '';
    _typeController.text = recurso.nameType ?? '';
    _cantidadController.text = '1';
    _percentController.text = '0';

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
                initialChildSize: 0.9,
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
                              'Agregar Recurso',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(18),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            TextFieldSelect(
                              label: 'Denominación',
                              hingText: '',
                              controller: _denominacionController,
                              icon: false,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'U.M.',
                              hingText: '',
                              controller: _unidadController,
                              icon: false,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Tipo Recurso',
                              hingText: '',
                              controller: _typeController,
                              icon: false,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            TextFieldSelect(
                              label: 'Cantidad',
                              hingText: '',
                              controller: _cantidadController,
                              widget: Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                              icon: true,
                              readOnly: false,
                            ),
                            SizedBox(height: ScreenUtil().setHeight(10)),
                            TextFieldSelect(
                              label: 'Descuento %',
                              hingText: '',
                              controller: _percentController,
                              widget: selectPercent(_percentController),
                              icon: true,
                              readOnly: true,
                            ),
                            SizedBox(height: ScreenUtil().setHeight(10)),
                            InkWell(
                              onTap: () {
                                if (_cantidadController.value.text.isEmpty) return showToast2('Debe ingresar una Cantidad', Colors.redAccent);
                                final recursoSave = RecursoCotizacionModel();
                                recursoSave.idLogisticaRecurso = recurso.idLogisticaRecurso;
                                recursoSave.idClase = recurso.idClase;
                                recursoSave.nameRecurso = recurso.nameRecurso;
                                recursoSave.unidadRecurso = recurso.unidadRecurso;
                                recursoSave.idTypeLogistica = recurso.idTypeLogistica;
                                recursoSave.nameClase = recurso.nameClase;
                                recursoSave.nameType = recurso.nameType;
                                recursoSave.quantity = _cantidadController.text;
                                recursoSave.percent = _percentController.text;

                                _controller.saveRecurso(recursoSave);
                                Navigator.pop(context);
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

  Widget selectPercent(TextEditingController controller) {
    return PopupMenuButton(
      onSelected: (String value) {
        controller.text = value;
      },
      itemBuilder: (context) => [
        PopupMenuItem(child: Text('-30%'), value: '-30%'),
        PopupMenuItem(child: Text('-25%'), value: '-25%'),
        PopupMenuItem(child: Text('-20%'), value: '-20%'),
        PopupMenuItem(child: Text('-15%'), value: '-15%'),
        PopupMenuItem(child: Text('-10%'), value: '-10%'),
        PopupMenuItem(child: Text('-5%'), value: '-5%'),
        PopupMenuItem(child: Text('0%'), value: '0%'),
        PopupMenuItem(child: Text('5%'), value: '5%'),
        PopupMenuItem(child: Text('10%'), value: '10%'),
        PopupMenuItem(child: Text('15%'), value: '15%'),
        PopupMenuItem(child: Text('20%'), value: '20%'),
        PopupMenuItem(child: Text('25%'), value: '25%'),
        PopupMenuItem(child: Text('30%'), value: '30%'),
      ],
      child: Icon(Icons.percent, color: Colors.green),
    );
  }
}

class CotizationController extends ChangeNotifier {
  bool isLoadding = false;

  void changeIsLoading(bool value) {
    isLoadding = value;
    notifyListeners();
  }

  List<RecursoCotizacionModel> recursos = [];

  // void saveRecurso(RecursoCotizacionModel item) {
  //   recursos.add(item);
  //   final newListRecursos = recursos.map((data) => data).toSet().toList();
  //   recursos = newListRecursos;
  //   notifyListeners();
  // }

  void saveRecurso(RecursoCotizacionModel item) {
    recursos.removeWhere((element) => element.idLogisticaRecurso == item.idLogisticaRecurso);
    recursos.add(item);
    notifyListeners();
  }

  void removeRecurso(String id) {
    recursos.removeWhere((item) => item.idLogisticaRecurso == id);
    notifyListeners();
  }
}
