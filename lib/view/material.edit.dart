import 'package:app_tojoyo_mrp/components/button/button-loading.dart';
import 'package:app_tojoyo_mrp/controller/material.dart';
import 'package:app_tojoyo_mrp/model/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MaterialEditPage extends StatefulWidget {
  const MaterialEditPage({Key? key}) : super(key: key);

  @override
  State<MaterialEditPage> createState() => _MaterialEditPageState();
}

class _MaterialEditPageState extends State<MaterialEditPage> {
  bool isLoading = false;
  bool isLoadingPage = false;
  int id = 0;
  TextEditingController _textNameController = TextEditingController();
  TextEditingController _textUnitController = TextEditingController();

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
    _textUnitController.dispose();
    super.dispose();
  }

  void _initPage(int id) async {
    setState(() {
      isLoadingPage = true;
    });
    MaterialByIDResponse materialByIDResponse = await getMaterialyID(id);
    if (!materialByIDResponse.error) {
      setState(() {
        isLoadingPage = false;
      });
      if (materialByIDResponse.data != null) {
        _textNameController.text = materialByIDResponse.data!.name;
        _textUnitController.text = materialByIDResponse.data!.unit;
      }
    }
  }

  void _eventPatch() async {
    Map<String, dynamic> data = {
      "name": _textNameController.text,
      "unit": _textUnitController.text,
    };
    setState(() {
      isLoading = true;
    });
    MaterialMutateResponse materialMutateResponse =
        await patchMaterial(id, data);
    if (!materialMutateResponse.error) {
      _textNameController.text = '';
      _textUnitController.text = '';
      setState(() {
        isLoading = false;
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
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
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
        title: const Text("Edit Bahan Baku"),
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
                          : SingleChildScrollView(
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
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
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
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
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
                  text: "Update Material",
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
