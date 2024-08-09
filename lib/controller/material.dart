import 'dart:developer';

import 'package:app_tojoyo_mrp/controller/util.dart';
import 'package:app_tojoyo_mrp/model/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

class MaterialByIDResponse {
  bool error;
  String message;
  MaterialModel? data;

  MaterialByIDResponse({
    required this.error,
    required this.message,
    required this.data,
  });
}

class MaterialMutateResponse {
  bool error;
  String message;

  MaterialMutateResponse({
    required this.error,
    required this.message,
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
    final response = await Dio().get("$hostApiAddress/material",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ));
    log(response.data.toString());
    List<dynamic> materialData = response.data['data'];
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

Future<MaterialMutateResponse> createMaterial(Map<String, dynamic> data) async {
  MaterialMutateResponse materialMutateResponse = MaterialMutateResponse(
    error: true,
    message: "internal server error",
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    var formData = FormData.fromMap(data);
    final response = await Dio().post("$hostApiAddress/material",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: formData);
    log(response.data.toString());
    materialMutateResponse = MaterialMutateResponse(
      error: false,
      message: "success",
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    materialMutateResponse = MaterialMutateResponse(
      error: true,
      message: "internal server error",
    );
  }
  return materialMutateResponse;
}

Future<MaterialMutateResponse> patchMaterial(
    int id, Map<String, dynamic> data) async {
  MaterialMutateResponse materialMutateResponse = MaterialMutateResponse(
    error: true,
    message: "internal server error",
  );
  log(data.toString());
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    var formData = FormData.fromMap(data);
    final response = await Dio().post("$hostApiAddress/material/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: formData);
    log(response.data.toString());
    materialMutateResponse = MaterialMutateResponse(
      error: false,
      message: "success",
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    materialMutateResponse = MaterialMutateResponse(
      error: true,
      message: "internal server error",
    );
  }
  return materialMutateResponse;
}

Future<MaterialMutateResponse> deleteMaterial(int id) async {
  MaterialMutateResponse materialMutateResponse = MaterialMutateResponse(
    error: true,
    message: "internal server error",
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    final response = await Dio().delete(
      "$hostApiAddress/material/$id/delete",
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      ),
    );
    log(response.data.toString());
    materialMutateResponse = MaterialMutateResponse(
      error: false,
      message: "success",
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    materialMutateResponse = MaterialMutateResponse(
      error: true,
      message: "internal server error",
    );
  }
  return materialMutateResponse;
}

Future<MaterialByIDResponse> getMaterialyID(int id) async {
  MaterialByIDResponse materialByIDResponse = MaterialByIDResponse(
      error: true, message: "internal server error", data: null);
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    final response = await Dio().get(
      "$hostApiAddress/material/$id",
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      ),
    );
    dynamic materialData = response.data['data'] as dynamic;
    MaterialModel? materialResult;
    if (materialData != null) {
      materialResult = MaterialModel.fromJson(materialData);
    }
    log(response.data.toString());
    materialByIDResponse = MaterialByIDResponse(
        error: false, message: "success", data: materialResult);
  } on DioException catch (e) {
    log("Error ${e.response}");
    materialByIDResponse = MaterialByIDResponse(
        error: true, message: "internal server error", data: null);
  }
  return materialByIDResponse;
}
