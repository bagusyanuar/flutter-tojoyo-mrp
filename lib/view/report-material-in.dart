import 'package:app_tojoyo_mrp/components/button/button.floating.cart.dart';
import 'package:app_tojoyo_mrp/components/card/card.material-in.dart';
import 'package:app_tojoyo_mrp/controller/material-in.dart';
import 'package:app_tojoyo_mrp/model/material-in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class ReportMaterialInPage extends StatefulWidget {
  const ReportMaterialInPage({Key? key}) : super(key: key);

  @override
  State<ReportMaterialInPage> createState() => _ReportMaterialInPageState();
}

class _ReportMaterialInPageState extends State<ReportMaterialInPage> {
  DateTime selectedDateStart = DateTime.now();
  DateTime selectedDateEnd = DateTime.now();
  TextEditingController _textDateStartController = TextEditingController();
  TextEditingController _textDateEndController = TextEditingController();
  List<MaterialInModel> dataMaterialIn = [];

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
        ..text = DateFormat.yMMMd().format(selectedDateStart)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _textDateStartController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  Future<void> _selectDateEnd(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateEnd,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateEnd) {
      setState(() {
        selectedDateEnd = picked;
      });
      _textDateEndController
        ..text = DateFormat.yMMMd().format(selectedDateEnd)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _textDateEndController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textDateStartController.dispose();
    _textDateEndController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPage();
  }

  void _initPage() async {
    MaterialInResponse materialInResponse = await getMaterialInList();
    if (!materialInResponse.error) {
      setState(() {
        dataMaterialIn = materialInResponse.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Bahan Baku Masuk"),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Data Bahan Baku Masuk",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                            hintText: "Tanggal Awal",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: const Text("sampai"),
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: AlwaysDisabledFocusNode(),
                          controller: _textDateEndController,
                          onTap: () {
                            _selectDateEnd(context);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            hintText: "Tanggal anhir",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(child: LayoutBuilder(
                    builder: (context, constraints) {
                      double height = constraints.maxHeight;
                      return RefreshIndicator(
                        child: SizedBox(
                          height: height,
                          width: double.infinity,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
