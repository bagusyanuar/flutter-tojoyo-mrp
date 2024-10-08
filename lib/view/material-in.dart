import 'package:app_tojoyo_mrp/components/button/button.floating.cart.dart';
import 'package:app_tojoyo_mrp/components/card/card.material-in.dart';
import 'package:app_tojoyo_mrp/controller/material-in.dart';
import 'package:app_tojoyo_mrp/model/material-in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class MaterialInPage extends StatefulWidget {
  const MaterialInPage({Key? key}) : super(key: key);

  @override
  State<MaterialInPage> createState() => _MaterialInPageState();
}

class _MaterialInPageState extends State<MaterialInPage> {
  List<MaterialInModel> dataMaterialIn = [];
  DateTime selectedDateStart = DateTime.now();
  TextEditingController _textDateStartController = TextEditingController();
  bool isLoading = true;

  Future<void> _selectDateStart(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateStart,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateStart) {
      setState(() {
        selectedDateStart = picked;
      });
      _textDateStartController
        ..text = DateFormat("yyyy-MM-dd").format(selectedDateStart)
        ..selection = TextSelection.fromPosition(
          TextPosition(
              offset: _textDateStartController.text.length,
              affinity: TextAffinity.upstream),
        );
      _initPage();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setDateNow();
    _initPage();
  }

  void _setDateNow() {
    DateTime now = DateTime.now();
    setState(() {
      selectedDateStart = now;
    });
    _textDateStartController
      ..text = DateFormat("yyyy-MM-dd").format(selectedDateStart)
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: _textDateStartController.text.length,
          affinity: TextAffinity.upstream));
  }

  void _initPage() async {
    setState(() {
      isLoading = true;
    });
    String date = _textDateStartController.text;
    MaterialInResponse materialInResponse = await getMaterialInList(date);
    setState(() {
      isLoading = false;
    });
    if (!materialInResponse.error) {
      setState(() {
        dataMaterialIn = materialInResponse.data;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textDateStartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bahan Baku Masuk"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Data Bahan Baku Masuk",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: AlwaysDisabledFocusNode(),
                            controller: _textDateStartController,
                            onTap: () {
                              _selectDateStart(context);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              hintText: "Tanggal",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(child: LayoutBuilder(
                    builder: (context, constraints) {
                      double height = constraints.maxHeight;
                      return RefreshIndicator(
                        child: SizedBox(
                          height: height,
                          width: double.infinity,
                          child: isLoading
                              ? Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        margin: const EdgeInsets.only(right: 5),
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.brown,
                                        ),
                                      ),
                                      const Text(
                                        "loading...",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.brown,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: dataMaterialIn.map((e) {
                                      return CustomCardMaterialIn(data: e);
                                    }).toList(),
                                  ),
                                ),
                        ),
                        onRefresh: () async {
                          _initPage();
                        },
                      );
                    },
                  ))
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: isLoading
                    ? Container()
                    : ButtonFloatingCart(
                        qty: 0,
                        onTapCart: () {
                          String date = _textDateStartController.text;
                          Navigator.pushNamed(context, '/material-in-add',
                              arguments: date);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
