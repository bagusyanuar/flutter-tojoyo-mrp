import 'dart:developer';

import 'package:app_tojoyo_mrp/components/button/button.floating.cart.dart';
import 'package:app_tojoyo_mrp/components/card/card.recipe.detail.dart';
import 'package:app_tojoyo_mrp/components/dialog/confirmation.dart';
import 'package:app_tojoyo_mrp/controller/recipe.dart';
import 'package:app_tojoyo_mrp/model/recipe.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({Key? key}) : super(key: key);

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  int productID = 0;
  RecipeModel? recipe;
  List<RecipeDetailModel> dataRecipeDetail = [];
  bool isLoading = true;
  bool isLoadingDelete = false;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int tmpProductID = ModalRoute.of(context)!.settings.arguments as int;
      setState(() {
        productID = tmpProductID;
      });
      _initPage(tmpProductID);
    });
    super.initState();
  }

  void _initPage(int id) async {
    setState(() {
      isLoading = true;
    });
    RecipeDetailResponse recipeDetailResponse = await getRecipeDetailList(id);
    if (!recipeDetailResponse.error) {
      if (recipeDetailResponse.recipe != null) {
        setState(() {
          dataRecipeDetail = recipeDetailResponse.data;
          recipe = recipeDetailResponse.recipe;
          isLoading = false;
        });
      }
    }
  }

  void _eventDelete(RecipeDetailModel data) async {
    setState(() {
      isLoadingDelete = true;
    });
    RecipeMutateResponse recipeMutateResponse = await deleteRecipe(data.id);
    if (!recipeMutateResponse.error) {
      setState(() {
        isLoadingDelete = false;
      });
      _initPage(productID);
      Fluttertoast.showToast(
        msg: recipeMutateResponse.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: recipeMutateResponse.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _eventConfirmDelete(BuildContext rootContext, RecipeDetailModel data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogConfirmation(
          title: 'Confirmation',
          content: 'Apakah Anda Yakin Ingin Menghapus Data?',
          onYesTap: () {
            Navigator.pop(context);
            _eventDelete(data);
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
              child: isLoading
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
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Data Resep ${recipe!.name}",
                            style: const TextStyle(
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
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: dataRecipeDetail.map((e) {
                                      return CustomCardRecipeDetail(
                                        data: e,
                                        onTap: (recipeDetailModel) {},
                                        onDelete: (recipeDetailModel) {
                                          _eventConfirmDelete(
                                              context, recipeDetailModel);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              onRefresh: () async {
                                _initPage(productID);
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
                          Navigator.pushNamed(context, '/recipe-detail-add',
                              arguments: productID);
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
