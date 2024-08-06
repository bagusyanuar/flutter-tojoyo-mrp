import 'dart:developer';

import 'package:app_tojoyo_mrp/controller/util.dart';
import 'package:app_tojoyo_mrp/model/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaterialResponse {
  bool error;
  String message;
  List<MaterialModel> data;

  MaterialResponse({
    required this.error,
    required this.message,
    required this.data,
  });
}

Future<MaterialResponse> getMaterialList() async {
  MaterialResponse materialResponse = MaterialResponse(
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
    List<dynamic> materialData = [
      {
        "id": 1,
        "name": "Dada Ayam",
        "qty": 4,
        "unit": "pcs",
      },
      {
        "id": 2,
        "name": "Paha Ayam",
        "qty": 10,
        "unit": "pcs",
      },
      {
        "id": 3,
        "name": "Tepung Terigu",
        "qty": 1000,
        "unit": "gram",
      },
      {
        "id": 4,
        "name": "Kepala Ayam",
        "qty": 2,
        "unit": "pcs",
      },
      {
        "id": 5,
        "name": "Air",
        "qty": 10,
        "unit": "Liter",
      },
      {
        "id": 6,
        "name": "Garam",
        "qty": 500,
        "unit": "gram",
      },
      {
        "id": 7,
        "name": "Lengkuas",
        "qty": 20,
        "unit": "pcs",
      },
      {
        "id": 8,
        "name": "Sereh",
        "qty": 10,
        "unit": "batang",
      },
      {
        "id": 9,
        "name": "Daun Pandan",
        "qty": 5,
        "unit": "lembar",
      },
    ];
    List<MaterialModel> data =
        materialData.map((e) => MaterialModel.fromJson(e)).toList();
    materialResponse = MaterialResponse(
      error: false,
      message: "success",
      data: data,
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    materialResponse = MaterialResponse(
      error: true,
      message: "internal server error",
      data: [],
    );
  }
  return materialResponse;
}
