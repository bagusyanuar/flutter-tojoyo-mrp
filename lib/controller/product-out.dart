import 'dart:developer';

import 'package:app_tojoyo_mrp/model/product-out.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductOutResponse {
  bool error;
  String message;
  List<ProductOutModel> data;

  ProductOutResponse({
    required this.error,
    required this.message,
    required this.data,
  });
}

Future<ProductOutResponse> getProductOutList() async {
  ProductOutResponse productOutResponse = ProductOutResponse(
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
    List<dynamic> productOutData = [
      {
        "id": 1,
        "product": {"name": "Dada Ayam Goreng", "unit": "pcs"},
        "qty": 2,
        "date": "2024-07-02",
      },
      {
        "id": 2,
        "product": {"name": "Paha Ayam Goreng", "unit": "pcs"},
        "qty": 1,
        "date": "2024-07-02",
      },
      {
        "id": 3,
        "product": {"name": "Paha Ayam Goreng ", "unit": "pcs"},
        "qty": 10,
        "date": "2024-07-02",
      },
    ];
    List<ProductOutModel> data =
        productOutData.map((e) => ProductOutModel.fromJson(e)).toList();
    productOutResponse = ProductOutResponse(
      error: false,
      message: "success",
      data: data,
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    productOutResponse = ProductOutResponse(
      error: true,
      message: "internal server error",
      data: [],
    );
  }
  return productOutResponse;
}
