import 'dart:developer';

import 'package:app_tojoyo_mrp/controller/util.dart';
import 'package:app_tojoyo_mrp/model/material-in.dart';
import 'package:app_tojoyo_mrp/model/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaterialInResponse {
  bool error;
  String message;
  List<MaterialInModel> data;

  MaterialInResponse({
    required this.error,
    required this.message,
    required this.data,
  });
}

Future<MaterialInResponse> getMaterialInList() async {
  MaterialInResponse materialInResponse = MaterialInResponse(
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
    List<dynamic> materialInData = [
      {
        "id": 1,
        "material": {"name": "Tepung Terigu", "unit": "gram"},
        "qty": 500,
        "date": "2024-07-02",
      },
      {
        "id": 2,
        "material": {"name": "Gula", "unit": "gram"},
        "qty": 1500,
        "date": "2024-07-02",
      },
      {
        "id": 3,
        "material": {"name": "Telur", "unit": "kg"},
        "qty": 3,
        "date": "2024-07-02",
      },
    ];
    List<MaterialInModel> data =
        materialInData.map((e) => MaterialInModel.fromJson(e)).toList();
    materialInResponse = MaterialInResponse(
      error: false,
      message: "success",
      data: data,
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    materialInResponse = MaterialInResponse(
      error: true,
      message: "internal server error",
      data: [],
    );
  }
  return materialInResponse;
}
