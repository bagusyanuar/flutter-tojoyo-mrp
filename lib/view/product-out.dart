import 'package:app_tojoyo_mrp/components/button/button.floating.cart.dart';
import 'package:app_tojoyo_mrp/components/card/card.product-out.dart';
import 'package:app_tojoyo_mrp/controller/product-out.dart';
import 'package:app_tojoyo_mrp/model/product-out.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProductOutPage extends StatefulWidget {
  const ProductOutPage({Key? key}) : super(key: key);

  @override
  State<ProductOutPage> createState() => _ProductOutPageState();
}

class _ProductOutPageState extends State<ProductOutPage> {
  List<ProductOutModel> dataProductOut = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPage();
  }

  void _initPage() async {
    ProductOutResponse productOutResponse = await getProductOutList();
    if (!productOutResponse.error) {
      setState(() {
        dataProductOut = productOutResponse.data;
      });
    }
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Data Product Keluar Hari Ini",
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
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                child: ButtonFloatingCart(
                  qty: 0,
                  onTapCart: () {
                    Navigator.pushNamed(context, '/product-out-add');
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
