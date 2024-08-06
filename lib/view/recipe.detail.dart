import 'dart:developer';

import 'package:app_tojoyo_mrp/components/button/button.floating.cart.dart';
import 'package:app_tojoyo_mrp/components/card/card.recipe.detail.dart';
import 'package:app_tojoyo_mrp/controller/recipe.dart';
import 'package:app_tojoyo_mrp/model/recipe.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({Key? key}) : super(key: key);

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  int productID = 0;
  List<RecipeDetailModel> dataRecipeDetail = [];

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int tmpProductID = ModalRoute.of(context)!.settings.arguments as int;
      // log(productID.toString());
      setState(() {
        productID = tmpProductID;
      });
    });
    super.initState();
    _initPage();
  }

  void _initPage() async {
    RecipeDetailResponse recipeDetailResponse =
        await getRecipeDetailList(productID);
    log(recipeDetailResponse.message);
    if (!recipeDetailResponse.error) {
      setState(() {
        dataRecipeDetail = recipeDetailResponse.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resep"),
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
                      "Data Resep Dada Ayam Goreng",
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
                              children: dataRecipeDetail.map((e) {
                                return CustomCardRecipeDetail(
                                  data: e,
                                  onTap: (recipeDetailModel) {},
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        onRefresh: () async {
                          // _initPage();
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
                    Navigator.pushNamed(context, '/recipe-detail-add');
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
