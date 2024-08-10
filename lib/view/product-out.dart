import 'dart:developer';

import 'package:app_tojoyo_mrp/components/button/button.floating.cart.dart';
import 'package:app_tojoyo_mrp/components/card/card.product-out.dart';
import 'package:app_tojoyo_mrp/controller/product-out.dart';
import 'package:app_tojoyo_mrp/model/product-out.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class ProductOutPage extends StatefulWidget {
  const ProductOutPage({Key? key}) : super(key: key);

  @override
  State<ProductOutPage> createState() => _ProductOutPageState();
}

class _ProductOutPageState extends State<ProductOutPage> {
  List<ProductOutModel> dataProductOut = [];
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
        ..text = DateFormat.yMMMd().format(selectedDateStart)
        ..selection = TextSelection.fromPosition(
          TextPosition(
              offset: _textDateStartController.text.length,
              affinity: TextAffinity.upstream),
        );
      _initPage();
    }
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setDateNow();
    _initPage();
  }

  void _initPage() async {
    setState(() {
      isLoading = true;
    });
    String date = _textDateStartController.text;
    ProductOutResponse productOutResponse = await getProductOutList(date);
    setState(() {
      isLoading = false;
    });
    if (!productOutResponse.error) {
      setState(() {
        dataProductOut = productOutResponse.data;
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
        title: const Text("Product Keluar"),
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
                      children: [
                        const Text(
                          "Data Product Keluar",
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
                                    children: dataProductOut.map((e) {
                                      return CustomCardProductOut(data: e);
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
                          Navigator.pushNamed(context, '/product-out-add',
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
