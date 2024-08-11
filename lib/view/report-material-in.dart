import 'dart:developer';
import 'dart:io';

import 'package:app_tojoyo_mrp/components/button/button-loading.dart';
import 'package:app_tojoyo_mrp/components/button/button.floating.cart.dart';
import 'package:app_tojoyo_mrp/components/card/card.material-in.dart';
import 'package:app_tojoyo_mrp/controller/material-in.dart';
import 'package:app_tojoyo_mrp/model/material-in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
        ..text = DateFormat("yyyy-MM-dd").format(selectedDateEnd)
        ..selection = TextSelection.fromPosition(
          TextPosition(
              offset: _textDateEndController.text.length,
              affinity: TextAffinity.upstream),
        );
      _initPage();
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
    _setDateNow();
    _initPage();
  }

  void _setDateNow() {
    DateTime now = DateTime.now();
    setState(() {
      selectedDateStart = now;
      selectedDateEnd = now;
    });
    _textDateStartController
      ..text = DateFormat("yyyy-MM-dd").format(selectedDateStart)
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: _textDateStartController.text.length,
          affinity: TextAffinity.upstream));

    _textDateEndController
      ..text = DateFormat("yyyy-MM-dd").format(selectedDateEnd)
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: _textDateEndController.text.length,
          affinity: TextAffinity.upstream));
  }

  void _initPage() async {
    setState(() {
      isLoading = true;
    });
    String start = _textDateStartController.text;
    String end = _textDateEndController.text;
    MaterialInResponse materialInResponse =
        await getReportMaterialInList(start, end);
    setState(() {
      isLoading = false;
    });
    if (!materialInResponse.error) {
      setState(() {
        dataMaterialIn = materialInResponse.data;
      });
    }
  }

  Future<void> _requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> _createPdf() async {
    await _requestPermission();
    final pdf = pw.Document();

    final headers = ["Tanggal", "Nama", "Qty"];

    List<List<String>> data = [];

    for (var element in dataMaterialIn) {
      List<String> tmpData = [
        element.date,
        element.name,
        element.qty.toString()
      ];
      data.add(tmpData);
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Center(
              child: pw.Text(
                  'Laporan Bahan Baku Masuk Periode ${_textDateStartController.text} - ${_textDateEndController.text}'),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              data: data,
              headers: headers,
              border: pw.TableBorder.all(),
              cellAlignment: pw.Alignment.center,
            )
          ],
        ),
      ),
    );

    final output = await getExternalStorageDirectory();
    String fileName =
        DateFormat("yyyyMMddHHmmss").format(DateTime.now()).toString();
    final file = File("${output!.path}/laporan-bahan-baku-masuk-$fileName.pdf");
    await file.writeAsBytes(await pdf.save());
    Fluttertoast.showToast(
      msg: "Export PDF Berhasil",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    log("PDF saved at ${file.path}");
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
                  Expanded(
                    child: LayoutBuilder(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 20,
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          child:
                                              const CircularProgressIndicator(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                    ),
                  ),
                  ButtonLoading(
                    onLoading: false,
                    text: "PDF",
                    onTap: () {
                      // _eventProduction();
                      _createPdf();
                    },
                  )
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
