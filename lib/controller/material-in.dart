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

class MaterialInMutateResponse {
  bool error;
  String message;

  MaterialInMutateResponse({
    required this.error,
    required this.message,
  });
}

Future<MaterialInResponse> getMaterialInList(String date) async {
  MaterialInResponse materialInResponse = MaterialInResponse(
    error: true,
    message: "internal server error",
    data: [],
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    final response = await Dio().get("$hostApiAddress/material-in?date=$date",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ));
    log(response.data.toString());
    List<dynamic> materialInData = response.data['data'];
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

Future<MaterialInMutateResponse> addMaterialIn(
    Map<String, dynamic> data) async {
  MaterialInMutateResponse materialInMutateResponse = MaterialInMutateResponse(
    error: true,
    message: "internal server error",
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    var formData = FormData.fromMap(data);
    final response = await Dio().post("$hostApiAddress/material-in",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: formData);
    log(response.data.toString());
    materialInMutateResponse = MaterialInMutateResponse(
      error: false,
      message: "success",
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    materialInMutateResponse = MaterialInMutateResponse(
      error: true,
      message: "internal server error",
    );
  }
  return materialInMutateResponse;
}

Future<MaterialInResponse> getReportMaterialInList(
    String start, String end) async {
  MaterialInResponse materialInResponse = MaterialInResponse(
    error: true,
    message: "internal server error",
    data: [],
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    final response = await Dio()
        .get("$hostApiAddress/material-in-report?start=$start&end=$end",
            options: Options(
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer $token"
              },
            ));
    log(response.data.toString());
    List<dynamic> materialInData = response.data['data'];
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
