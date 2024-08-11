import 'package:app_tojoyo_mrp/components/card/card.mrp.dart';
import 'package:app_tojoyo_mrp/controller/product.dart';
import 'package:app_tojoyo_mrp/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MRPPage extends StatefulWidget {
  const MRPPage({Key? key}) : super(key: key);

  @override
  State<MRPPage> createState() => _MRPPageState();
}

class _MRPPageState extends State<MRPPage> {
  List<ProductModel> dataProduct = [];
  bool isLoading = true;

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
    if (!productResponse.error) {
      setState(() {
        dataProduct = productResponse.data;
        isLoading = false;
      });
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Data Product",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                                      return CustomCardMRP(
                                        data: e,
                                        onTap: (productModel) {
                                          Navigator.pushNamed(
                                              context, "/mrp-detail",
                                              arguments: productModel.id);
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
          ],
        ),
      ),
    );
  }
}
