import 'dart:developer';

import 'package:app_tojoyo_mrp/controller/util.dart';
import 'package:app_tojoyo_mrp/model/material.dart';
import 'package:app_tojoyo_mrp/model/product.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MRPResponse {
  bool error;
  String message;
  ProductModel? product;
  List<MaterialModel> materialInventory;
  List<MaterialModel> billsOfMaterial;
  int maxProduction;

  MRPResponse({
    required this.error,
    required this.message,
    required this.product,
    required this.materialInventory,
    required this.billsOfMaterial,
    required this.maxProduction,
  });
}

class MRPMutateResponse {
  bool error;
  String message;

  MRPMutateResponse({
    required this.error,
    required this.message,
  });
}

Future<MRPResponse> getMRPData(int productID) async {
  MRPResponse mrpResponse = MRPResponse(
    error: true,
    message: "internal server error",
    product: null,
    materialInventory: [],
    billsOfMaterial: [],
    maxProduction: 0,
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    final response = await Dio().get(
      "$hostApiAddress/mrp?product_id=$productID",
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      ),
    );
    log(response.data.toString());
    int tmpMaxProduction = response.data['data']['max_result'] as int;
    dynamic tmpProductData = response.data['data']['product'] as dynamic;
    ProductModel? tmpProduct;
    if (tmpProductData != null) {
      tmpProduct = ProductModel(
        id: tmpProductData['id'],
        name: tmpProductData['name'],
        qty: tmpProductData['qty'],
      );
    }
    List<dynamic> materialInventoryData =
        response.data['data']['material_inventory'];
    List<dynamic> billsOfMaterialData =
        response.data['data']['bills_of_material'];
    List<MaterialModel> dataMaterialInventory =
        materialInventoryData.map((e) => MaterialModel.fromJson(e)).toList();
    List<MaterialModel> dataBillsOfMaterial = billsOfMaterialData
        .map((e) => MaterialModel.fromJsonProductMaterial(e))
        .toList();
    mrpResponse = MRPResponse(
      error: false,
      message: "success",
      product: tmpProduct,
      materialInventory: dataMaterialInventory,
      billsOfMaterial: dataBillsOfMaterial,
      maxProduction: tmpMaxProduction,
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    mrpResponse = MRPResponse(
      error: true,
      message: "internal server error",
      product: null,
      materialInventory: [],
      billsOfMaterial: [],
      maxProduction: 0,
    );
  }
  return mrpResponse;
}

Future<MRPMutateResponse> createMRP(Map<String, dynamic> data) async {
  MRPMutateResponse mrpMutateResponse = MRPMutateResponse(
    error: true,
    message: "internal server error",
  );
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    var formData = FormData.fromMap(data);
    final response = await Dio().post("$hostApiAddress/mrp",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: formData);
    log(response.data.toString());
    mrpMutateResponse = MRPMutateResponse(
      error: false,
      message: "success",
    );
  } on DioException catch (e) {
    log("Error ${e.response}");
    mrpMutateResponse = MRPMutateResponse(
      error: true,
      message: "internal server error",
    );
  }
  return mrpMutateResponse;
}
