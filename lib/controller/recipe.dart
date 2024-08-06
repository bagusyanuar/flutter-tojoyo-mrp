import 'dart:developer';

import 'package:app_tojoyo_mrp/model/product.dart';
import 'package:app_tojoyo_mrp/model/recipe.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeResponse {
  bool error;
  String message;
  List<RecipeModel> data;

  RecipeResponse({
    required this.error,
    required this.message,
    required this.data,
  });
}

class RecipeDetailResponse {
  bool error;
  String message;
  List<RecipeDetailModel> data;

  RecipeDetailResponse({
    required this.error,
    required this.message,
    required this.data,
  });
}

Future<RecipeResponse> getRecipeList() async {
  RecipeResponse recipeResponse = RecipeResponse(
    error: true,
    message: "internal server error",
    data: [],
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    // final response = await Dio().get("$hostApiAddress/material",
    //     options: Options(
    //       headers: {
    //         "Accept": "application/json",
    //         "Authorization": "Bearer $token"
    //       },
    //     ));
    // log(response.data.toString());
    // List<dynamic> materialData = response.data['data'];
    List<dynamic> recipeData = [
      {
        "id": 1,
        "name": "Dada Ayam Goreng",
        "count": 3,
      },
      {
        "id": 2,
        "name": "Paha Ayam Goreng",
        "count": 3,
      },
    ];
    List<RecipeModel> data =
        recipeData.map((e) => RecipeModel.fromJson(e)).toList();
    recipeResponse = RecipeResponse(
      error: false,
      message: "success",
      data: data,
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    recipeResponse = RecipeResponse(
      error: true,
      message: "internal server error",
      data: [],
    );
  }
  return recipeResponse;
}

Future<RecipeDetailResponse> getRecipeDetailList(int id) async {
  RecipeDetailResponse recipeDetailResponse = RecipeDetailResponse(
    error: true,
    message: "internal server error",
    data: [],
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    // final response = await Dio().get("$hostApiAddress/material",
    //     options: Options(
    //       headers: {
    //         "Accept": "application/json",
    //         "Authorization": "Bearer $token"
    //       },
    //     ));
    // log(response.data.toString());
    // List<dynamic> materialData = response.data['data'];
    List<dynamic> recipeDetailData = [
      {
        "id": 1,
        "name": "Dada Ayam Goreng",
        "material": {"name": "Dada Ayam", "unit": "pc"},
        "qty": 1,
      },
      {
        "id": 2,
        "name": "Product B",
        "material": {"name": "Tepung", "unit": "gram"},
        "qty": 100,
      },
      {
        "id": 3,
        "name": "Product C",
        "material": {"name": "Lengkuas", "unit": "pcs"},
        "qty": 1,
      },
    ];
    List<RecipeDetailModel> data =
        recipeDetailData.map((e) => RecipeDetailModel.fromJson(e)).toList();
    recipeDetailResponse = RecipeDetailResponse(
      error: false,
      message: "success",
      data: data,
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    recipeDetailResponse = RecipeDetailResponse(
      error: true,
      message: "internal server error",
      data: [],
    );
  }
  return recipeDetailResponse;
}
