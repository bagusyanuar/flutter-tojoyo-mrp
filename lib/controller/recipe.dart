import 'dart:developer';

import 'package:app_tojoyo_mrp/controller/util.dart';
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
  RecipeModel? recipe;
  List<RecipeDetailModel> data;

  RecipeDetailResponse({
    required this.error,
    required this.message,
    required this.recipe,
    required this.data,
  });
}

class RecipeMutateResponse {
  bool error;
  String message;

  RecipeMutateResponse({
    required this.error,
    required this.message,
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
    final response = await Dio().get("$hostApiAddress/recipe",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ));
    List<dynamic> recipeData = response.data['data'];
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
    recipe: null,
    data: [],
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    final response = await Dio().get("$hostApiAddress/recipe/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ));
    log(response.data.toString());
    dynamic recipeData = response.data['data'] as dynamic;
    RecipeModel? tmpRecipe;
    List<RecipeDetailModel> data = [];
    if (recipeData != null) {
      tmpRecipe = RecipeModel.fromJsonDetail(recipeData);
      List<dynamic> recipeListData = recipeData['product_material'];
      data = recipeListData.map((e) => RecipeDetailModel.fromJson(e)).toList();
    }

    recipeDetailResponse = RecipeDetailResponse(
      error: false,
      message: "success",
      data: data,
      recipe: tmpRecipe,
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    recipeDetailResponse = RecipeDetailResponse(
        error: true, message: "internal server error", data: [], recipe: null);
  }
  return recipeDetailResponse;
}

Future<RecipeMutateResponse> addRecipe(
    int productID, Map<String, dynamic> data) async {
  RecipeMutateResponse recipeMutateResponse = RecipeMutateResponse(
    error: true,
    message: "internal server error",
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    var formData = FormData.fromMap(data);
    final response = await Dio().post("$hostApiAddress/recipe/$productID",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: formData);
    log(response.data.toString());
    recipeMutateResponse = RecipeMutateResponse(
      error: false,
      message: "success",
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    recipeMutateResponse = RecipeMutateResponse(
      error: true,
      message: "internal server error",
    );
  }
  return recipeMutateResponse;
}

Future<RecipeMutateResponse> deleteRecipe(int recipeID) async {
  RecipeMutateResponse recipeMutateResponse = RecipeMutateResponse(
    error: true,
    message: "internal server error",
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    final response = await Dio().delete(
      "$hostApiAddress/recipe/$recipeID/delete",
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      ),
    );
    log(response.data.toString());
    recipeMutateResponse = RecipeMutateResponse(
      error: false,
      message: "success",
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    recipeMutateResponse = RecipeMutateResponse(
      error: true,
      message: "internal server error",
    );
  }
  return recipeMutateResponse;
}
