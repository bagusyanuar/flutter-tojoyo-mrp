import 'package:app_tojoyo_mrp/components/button/button-loading.dart';
import 'package:app_tojoyo_mrp/controller/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductEditPage extends StatefulWidget {
  const ProductEditPage({Key? key}) : super(key: key);

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  bool isLoading = false;
  bool isLoadingPage = false;
  int id = 0;
  TextEditingController _textNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int args = ModalRoute.of(context)!.settings.arguments as int;
      _initPage(args);
      setState(() {
        id = args;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textNameController.dispose();
    super.dispose();
  }

  void _initPage(int id) async {
    setState(() {
      isLoadingPage = true;
    });
    ProductByIDResponse productByIDResponse = await getProductByID(id);
    if (!productByIDResponse.error) {
      setState(() {
        isLoadingPage = false;
      });
      if (productByIDResponse.data != null) {
        _textNameController.text = productByIDResponse.data!.name;
      }
    }
  }

  void _eventPatch() async {
    Map<String, dynamic> data = {
      "name": _textNameController.text,
    };
    setState(() {
      isLoading = true;
    });
    ProductMutateResponse productMutateResponse = await patchProduct(id, data);
    if (!productMutateResponse.error) {
      _textNameController.text = '';
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: productMutateResponse.message,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Produk"),
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
                                "Nama Produk",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: _textNameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  hintText: "Nama produk",
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
                  onLoading: isLoading,
                  text: "Patch Produk",
                  onTap: () {
                    _eventPatch();
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
