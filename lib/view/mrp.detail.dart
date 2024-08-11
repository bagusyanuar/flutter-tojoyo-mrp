import 'dart:developer';

import 'package:app_tojoyo_mrp/components/button/button-loading.dart';
import 'package:app_tojoyo_mrp/controller/mrp.dart';
import 'package:app_tojoyo_mrp/model/material.dart';
import 'package:app_tojoyo_mrp/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MRPDetailPage extends StatefulWidget {
  const MRPDetailPage({Key? key}) : super(key: key);

  @override
  State<MRPDetailPage> createState() => _MRPDetailPageState();
}

class _MRPDetailPageState extends State<MRPDetailPage> {
  int productID = 0;
  bool isLoadingPage = true;
  bool isLoading = false;
  ProductModel product = ProductModel(id: 0, name: "", qty: 0);
  List<MaterialModel> dataMaterialInventory = [];
  List<MaterialModel> dataBillsOfMaterial = [];
  int maxProduction = 0;
  TextEditingController _textProductionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int tmpProductID = ModalRoute.of(context)!.settings.arguments as int;
      // log(productID.toString());
      setState(() {
        productID = tmpProductID;
      });
      _initPage(tmpProductID);
    });
    super.initState();
  }

  void _initPage(int productID) async {
    setState(() {
      isLoadingPage = true;
    });
    MRPResponse mrpResponse = await getMRPData(productID);
    setState(() {
      isLoadingPage = false;
    });
    if (!mrpResponse.error) {
      if (mrpResponse.product != null) {
        setState(() {
          product = mrpResponse.product!;
          dataMaterialInventory = mrpResponse.materialInventory;
          dataBillsOfMaterial = mrpResponse.billsOfMaterial;
          maxProduction = mrpResponse.maxProduction;
        });
      }
    }
  }

  void _eventProduction() async {
    log(productID.toString());
    Map<String, dynamic> data = {
      "product_id": productID,
      "production": _textProductionController.text,
    };
    setState(() {
      isLoading = true;
    });
    MRPMutateResponse mrpMutateResponse = await createMRP(data);
    if (!mrpMutateResponse.error) {
      setState(() {
        isLoading = false;
        _textProductionController.text = '';
      });
      Fluttertoast.showToast(
        msg: mrpMutateResponse.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: mrpMutateResponse.message,
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
        title: const Text("MRP"),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Data ${product.name}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                                  child: SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 5),
                                          child: const Text(
                                              "Bahan Baku Terkait Tersedia"),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(width: 1),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children:
                                                dataMaterialInventory.map((e) {
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(e.name),
                                                    Text("${e.qty} ${e.unit}")
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        const Divider(),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 5),
                                          child: const Text(
                                              "Bahan Baku Terkait Dibutuhkan"),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(width: 1),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children:
                                                dataBillsOfMaterial.map((e) {
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(e.name),
                                                    Text("${e.qty} ${e.unit}")
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onRefresh: () async {
                                  _initPage(productID);
                                },
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Kemungkinan Produksi",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "$maxProduction",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Rencana Produksi",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _textProductionController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    hintText: "Jumlah",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        ButtonLoading(
                          onLoading: isLoading,
                          text: "Produksi",
                          onTap: () {
                            _eventProduction();
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
