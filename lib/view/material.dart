import 'package:app_tojoyo_mrp/components/button/button.floating.cart.dart';
import 'package:app_tojoyo_mrp/components/card/card.material.dart';
import 'package:app_tojoyo_mrp/components/dialog/confirmation.dart';
import 'package:app_tojoyo_mrp/controller/material.dart';
import 'package:app_tojoyo_mrp/model/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MaterialUnitPage extends StatefulWidget {
  const MaterialUnitPage({Key? key}) : super(key: key);

  @override
  State<MaterialUnitPage> createState() => _MaterialUnitPageState();
}

class _MaterialUnitPageState extends State<MaterialUnitPage> {
  List<MaterialModel> dataMaterial = [];
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
    MaterialResponse materialResponse = await getMaterialList();
    if (!materialResponse.error) {
      setState(() {
        dataMaterial = materialResponse.data;
        isLoading = false;
      });
    }
  }

  void _eventDelete(MaterialModel data) async {
    setState(() {
      isLoadingDelete = true;
    });
    MaterialMutateResponse materialMutateResponse =
        await deleteMaterial(data.id);
    if (!materialMutateResponse.error) {
      setState(() {
        isLoadingDelete = false;
      });
      _initPage();
      Fluttertoast.showToast(
        msg: materialMutateResponse.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: materialMutateResponse.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _eventConfirmDelete(BuildContext rootContext, MaterialModel data) {
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
        title: const Text("Bahan Baku"),
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
                    "Data Bahan Baku",
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
                                    children: dataMaterial.map((e) {
                                      return CustomCardMaterial(
                                        data: e,
                                        onTap: (material) {
                                          Navigator.pushNamed(
                                              context, "/material-edit",
                                              arguments: e.id);
                                        },
                                        onDelete: (material) {
                                          _eventConfirmDelete(
                                              context, material);
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
                child: isLoading
                    ? Container()
                    : ButtonFloatingCart(
                        qty: 0,
                        onTapCart: () {
                          Navigator.pushNamed(context, '/material-add');
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
