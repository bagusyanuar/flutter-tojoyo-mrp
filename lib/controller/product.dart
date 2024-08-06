import 'dart:developer';

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

Future<ProductResponse> getProductList() async {
  ProductResponse productResponse = ProductResponse(
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
    List<dynamic> productData = [
      {
        "id": 1,
        "name": "Paha Ayam Goreng",
        "qty": 10,
        "unit": "pcs",
      },
      {
        "id": 2,
        "name": "Dada Ayam Goreng",
        "qty": 5,
        "unit": "pcs",
      },
    ];
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
