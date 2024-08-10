import 'dart:developer';

import 'package:app_tojoyo_mrp/components/button/button-loading.dart';
import 'package:app_tojoyo_mrp/controller/material-in.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:app_tojoyo_mrp/controller/material.dart';
import 'package:app_tojoyo_mrp/model/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MaterialInAddPage extends StatefulWidget {
  const MaterialInAddPage({Key? key}) : super(key: key);

  @override
  State<MaterialInAddPage> createState() => _MaterialInAddPageState();
}

class _MaterialInAddPageState extends State<MaterialInAddPage> {
  MaterialModel? selectedMaterial;
  List<MaterialModel> dataMaterial = [];
  String qty = '0';
  String date = '';
  bool isLoading = false;
  bool isLoadingPage = true;
  TextEditingController _textQtyController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String args = ModalRoute.of(context)!.settings.arguments as String;
      setState(() {
        date = args;
      });
    });
    super.initState();
    _initPage();
  }

  void _initPage() async {
    setState(() {
      isLoadingPage = true;
    });
    _textQtyController.text = '0';
    MaterialResponse materialResponse = await getMaterialList();
    if (!materialResponse.error) {
      setState(() {
        dataMaterial = materialResponse.data;
        isLoadingPage = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textQtyController.dispose();
    super.dispose();
  }

  void _eventAddMaterialIn() async {
    if (selectedMaterial != null) {
      Map<String, dynamic> data = {
        "date": date,
        "material_id": selectedMaterial!.id,
        "qty": _textQtyController.text,
      };
      setState(() {
        isLoading = true;
      });
      MaterialInMutateResponse materialInMutateResponse =
          await addMaterialIn(data);
      if (!materialInMutateResponse.error) {
        _textQtyController.text = '0';
        setState(() {
          isLoading = false;
          selectedMaterial = null;
        });
        Fluttertoast.showToast(
          msg: materialInMutateResponse.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: materialInMutateResponse.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "silahkan memilih bahan baku..",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Bahan Baku Masuk"),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isLoadingPage
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double height = constraints.maxHeight;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            height: height,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: const Text(
                                      "Pilih Bahan Baku",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: DropdownButton<MaterialModel>(
                                      isExpanded: true,
                                      elevation: 16,
                                      value: selectedMaterial,
                                      items: dataMaterial
                                          .map<DropdownMenuItem<MaterialModel>>(
                                              (element) {
                                        return DropdownMenuItem<MaterialModel>(
                                          value: element,
                                          child: Text(element.name),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedMaterial = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: const Text(
                                      "Jumlah",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: TextField(
                                      controller: _textQtyController,
                                      // onChanged: (value) {
                                      //   // onChanged(value);
                                      //   setState(() {
                                      //     qty = value;
                                      //   });
                                      // },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        hintText: "Jumlah",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ButtonLoading(
                        onLoading: isLoading,
                        text: "Tambah Bahan",
                        onTap: () {
                          _eventAddMaterialIn();
                        },
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
