import 'package:app_tojoyo_mrp/components/button/button-loading.dart';
import 'package:app_tojoyo_mrp/controller/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MaterialAddPage extends StatefulWidget {
  const MaterialAddPage({Key? key}) : super(key: key);

  @override
  State<MaterialAddPage> createState() => _MaterialAddPageState();
}

class _MaterialAddPageState extends State<MaterialAddPage> {
  String name = '';
  String qty = '0';
  String unit = '';
  bool isLoading = false;
  TextEditingController _textNameController = TextEditingController();
  TextEditingController _textUnitController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textNameController.dispose();
    _textUnitController.dispose();
    super.dispose();
  }

  void _initPage() {
    _textNameController.text = '';
    _textUnitController.text = '';
  }

  void _eventCreate() async {
    Map<String, dynamic> data = {
      "name": _textNameController.text,
      "unit": _textUnitController.text,
    };
    setState(() {
      isLoading = true;
    });
    MaterialMutateResponse materialMutateResponse = await createMaterial(data);
    if (!materialMutateResponse.error) {
      _textNameController.text = '';
      _textUnitController.text = '';
      setState(() {
        isLoading = false;
        name = '';
        unit = '';
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Bahan Baku"),
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
                                "Nama Bahan Baku",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: _textNameController,
                                // onChanged: (value) {
                                //   // onChanged(value);
                                //   setState(() {
                                //     name = value;
                                //   });
                                // },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  hintText: "Nama bahan baku",
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                "Satuan",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextField(
                              controller: _textUnitController,
                              // onChanged: (value) {
                              //   // onChanged(value);
                              //   setState(() {
                              //     unit = value;
                              //   });
                              // },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                hintText: "Satuan",
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
                  text: "Tambah Material",
                  onTap: () {
                    _eventCreate();
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
