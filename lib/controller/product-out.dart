import 'dart:developer';

import 'package:app_tojoyo_mrp/controller/util.dart';
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

class ProductOutMutateResponse {
  bool error;
  String message;

  ProductOutMutateResponse({
    required this.error,
    required this.message,
  });
}

Future<ProductOutResponse> getProductOutList(String date) async {
  ProductOutResponse productOutResponse = ProductOutResponse(
    error: true,
    message: "internal server error",
    data: [],
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    final response = await Dio().get("$hostApiAddress/product-out?date=$date",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ));
    List<dynamic> productOutData = response.data['data'];
    log(productOutData.toString());
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

Future<ProductOutMutateResponse> addProductOut(
    Map<String, dynamic> data) async {
  ProductOutMutateResponse productOutMutateResponse = ProductOutMutateResponse(
    error: true,
    message: "internal server error",
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    var formData = FormData.fromMap(data);
    final response = await Dio().post("$hostApiAddress/product-out",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: formData);
    log(response.data.toString());
    productOutMutateResponse = ProductOutMutateResponse(
      error: false,
      message: "success",
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    productOutMutateResponse = ProductOutMutateResponse(
      error: true,
      message: e.response!.data["message"].toString(),
    );
  }
  return productOutMutateResponse;
}

Future<ProductOutResponse> getReportProductOutList(
    String start, String end) async {
  ProductOutResponse productOutResponse = ProductOutResponse(
    error: true,
    message: "internal server error",
    data: [],
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    final response = await Dio()
        .get("$hostApiAddress/product-out-report?start=$start&end=$end",
            options: Options(
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer $token"
              },
            ));
    List<dynamic> productOutData = response.data['data'];
    log(productOutData.toString());
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
