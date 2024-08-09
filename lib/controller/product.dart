import 'dart:developer';

import 'package:app_tojoyo_mrp/controller/util.dart';
import 'package:app_tojoyo_mrp/model/product.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductResponse {
  bool error;
  String message;
  List<ProductModel> data;

  ProductResponse({
    required this.error,
    required this.message,
    required this.data,
  });
}

class ProductByIDResponse {
  bool error;
  String message;
  ProductModel? data;

  ProductByIDResponse({
    required this.error,
    required this.message,
    required this.data,
  });
}

class ProductMutateResponse {
  bool error;
  String message;

  ProductMutateResponse({
    required this.error,
    required this.message,
  });
}

Future<ProductResponse> getProductList() async {
  ProductResponse productResponse = ProductResponse(
    error: true,
    message: "internal server error",
    data: [],
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    final response = await Dio().get("$hostApiAddress/product",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ));
    log(response.data.toString());
    List<dynamic> productData = response.data['data'];
    List<ProductModel> data =
        productData.map((e) => ProductModel.fromJson(e)).toList();
    productResponse = ProductResponse(
      error: false,
      message: "success",
      data: data,
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    productResponse = ProductResponse(
      error: true,
      message: "internal server error",
      data: [],
    );
  }
  return productResponse;
}

Future<ProductMutateResponse> createProduct(Map<String, dynamic> data) async {
  ProductMutateResponse productMutateResponse = ProductMutateResponse(
    error: true,
    message: "internal server error",
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    var formData = FormData.fromMap(data);
    final response = await Dio().post("$hostApiAddress/product",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: formData);
    log(response.data.toString());
    productMutateResponse = ProductMutateResponse(
      error: false,
      message: "success",
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    productMutateResponse = ProductMutateResponse(
      error: true,
      message: "internal server error",
    );
  }
  return productMutateResponse;
}

Future<ProductMutateResponse> patchProduct(
    int id, Map<String, dynamic> data) async {
  ProductMutateResponse productMutateResponse = ProductMutateResponse(
    error: true,
    message: "internal server error",
  );
  log(data.toString());
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    var formData = FormData.fromMap(data);
    final response = await Dio().post("$hostApiAddress/product/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: formData);
    log(response.data.toString());
    productMutateResponse = ProductMutateResponse(
      error: false,
      message: "success",
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    productMutateResponse = ProductMutateResponse(
      error: true,
      message: "internal server error",
    );
  }
  return productMutateResponse;
}

Future<ProductMutateResponse> deleteProduct(int id) async {
  ProductMutateResponse productMutateResponse = ProductMutateResponse(
    error: true,
    message: "internal server error",
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    final response = await Dio().delete(
      "$hostApiAddress/product/$id/delete",
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      ),
    );
    log(response.data.toString());
    productMutateResponse = ProductMutateResponse(
      error: false,
      message: "success",
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    productMutateResponse = ProductMutateResponse(
      error: true,
      message: "internal server error",
    );
  }
  return productMutateResponse;
}

Future<ProductByIDResponse> getProductByID(int id) async {
  ProductByIDResponse productByIDResponse = ProductByIDResponse(
      error: true, message: "internal server error", data: null);
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    final response = await Dio().get(
      "$hostApiAddress/product/$id",
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      ),
    );
    dynamic productData = response.data['data'] as dynamic;
    ProductModel? productResult;
    if (productData != null) {
      productResult = ProductModel.fromJson(productData);
    }
    log(response.data.toString());
    productByIDResponse = ProductByIDResponse(
        error: false, message: "success", data: productResult);
  } on DioException catch (e) {
    log("Error ${e.response}");
    productByIDResponse = ProductByIDResponse(
        error: true, message: "internal server error", data: null);
  }
  return productByIDResponse;
}
