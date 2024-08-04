import 'package:app_tojoyo_mrp/components/button/button.floating.cart.dart';
import 'package:app_tojoyo_mrp/components/card/card.material.dart';
import 'package:app_tojoyo_mrp/controller/material.dart';
import 'package:app_tojoyo_mrp/model/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MaterialUnitPage extends StatefulWidget {
  const MaterialUnitPage({Key? key}) : super(key: key);

  @override
  State<MaterialUnitPage> createState() => _MaterialUnitPageState();
}

class _MaterialUnitPageState extends State<MaterialUnitPage> {
  List<MaterialModel> dataMaterial = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPage();
  }

  void _initPage() async {
    MaterialResponse materialResponse = await getMaterialList();
    if (!materialResponse.error) {
      setState(() {
        dataMaterial = materialResponse.data;
      });
    }
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
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: dataMaterial.map((e) {
                                return CustomCardMaterial(data: e);
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
                    Navigator.pushNamed(context, '/material-add');
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
