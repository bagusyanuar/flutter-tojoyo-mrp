import 'dart:developer';

import 'package:app_tojoyo_mrp/components/button/button.floating.cart.dart';
import 'package:app_tojoyo_mrp/components/card/card.recipe.dart';
import 'package:app_tojoyo_mrp/controller/recipe.dart';
import 'package:app_tojoyo_mrp/model/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class RecipePge extends StatefulWidget {
  const RecipePge({Key? key}) : super(key: key);

  @override
  State<RecipePge> createState() => _RecipePgeState();
}

class _RecipePgeState extends State<RecipePge> {
  List<RecipeModel> dataRecipe = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPage();
    log("check");
  }

  void _initPage() async {
    RecipeResponse recipeResponse = await getRecipeList();
    log(recipeResponse.message);
    if (!recipeResponse.error) {
      setState(() {
        dataRecipe = recipeResponse.data;
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
                  const Text(
                    "Data Resep",
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
                              children: dataRecipe.map((e) {
                                return CustomCardRecipe(
                                  data: e,
                                  onTap: (recipeModel) {},
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
                    Navigator.pushNamed(context, '/recipe-add');
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
