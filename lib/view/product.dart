import 'dart:developer';

import 'package:app_tojoyo_mrp/components/button/button.floating.cart.dart';
import 'package:app_tojoyo_mrp/components/card/card.product.dart';
import 'package:app_tojoyo_mrp/components/dialog/confirmation.dart';
import 'package:app_tojoyo_mrp/controller/product.dart';
import 'package:app_tojoyo_mrp/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<ProductModel> dataProduct = [];
  bool isLoading = true;
  bool isLoadingDelete = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPage();
  }

  void _initPage() async {
    setState(() {
      isLoading = true;
    });
    ProductResponse productResponse = await getProductList();
    log(productResponse.message);
    if (!productResponse.error) {
      setState(() {
        dataProduct = productResponse.data;
        isLoading = false;
      });
    }
  }

  void _eventDelete(ProductModel data) async {
    setState(() {
      isLoadingDelete = true;
    });
    ProductMutateResponse productMutateResponse = await deleteProduct(data.id);
    if (!productMutateResponse.error) {
      setState(() {
        isLoadingDelete = false;
      });
      _initPage();
      Fluttertoast.showToast(
        msg: productMutateResponse.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: productMutateResponse.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _eventConfirmDelete(BuildContext rootContext, ProductModel data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogConfirmation(
          title: 'Confirmation',
          content: 'Apakah Anda Yakin Ingin Menghapus Data?',
          onYesTap: () {
            Navigator.pop(context);
            _eventDelete(data);
            // _eventAddToCart(product, qty, modalContext);
          },
          onNoTap: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produk"),
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
                  const Text(
                    "Data Produk",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                                    children: dataProduct.map((e) {
                                      return CustomCardProduct(
                                        data: e,
                                        onTap: (material) {
                                          Navigator.pushNamed(
                                              context, "/product-edit",
                                              arguments: e.id);
                                        },
                                        onDelete: (product) {
                                          _eventConfirmDelete(context, product);
                                        },
                                      );
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
                child: ButtonFloatingCart(
                  qty: 0,
                  onTapCart: () {
                    Navigator.pushNamed(context, '/product-add');
                  },
                ),
              ),
            ),
            Visibility(
              visible: isLoadingDelete,
              child: Container(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
