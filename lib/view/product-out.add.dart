import 'package:app_tojoyo_mrp/components/button/button-loading.dart';
import 'package:app_tojoyo_mrp/controller/product.dart';
import 'package:app_tojoyo_mrp/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProductOutAddPage extends StatefulWidget {
  const ProductOutAddPage({Key? key}) : super(key: key);

  @override
  State<ProductOutAddPage> createState() => _ProductOutAddPageState();
}

class _ProductOutAddPageState extends State<ProductOutAddPage> {
  ProductModel? selectedProduct;
  List<ProductModel> dataProduct = [];
  String qty = '0';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPage();
  }

  void _initPage() async {
    ProductResponse productResponse = await getProductList();
    if (!productResponse.error) {
      setState(() {
        dataProduct = productResponse.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Product Keluar"),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
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
                                "Pilih Product",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: DropdownButton<ProductModel>(
                                isExpanded: true,
                                elevation: 16,
                                value: selectedProduct,
                                items: dataProduct
                                    .map<DropdownMenuItem<ProductModel>>(
                                        (element) {
                                  return DropdownMenuItem<ProductModel>(
                                    value: element,
                                    child: Text(element.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedProduct = value;
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
                                onChanged: (value) {
                                  // onChanged(value);
                                  setState(() {
                                    qty = value;
                                  });
                                },
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
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ButtonLoading(
                  onLoading: false,
                  text: "Tambah Product Keluar",
                  onTap: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
