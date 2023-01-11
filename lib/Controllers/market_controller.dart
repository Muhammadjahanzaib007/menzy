import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:menzy/Controllers/auth-controller.dart';
import 'package:menzy/Models/product_model.dart';
import 'package:menzy/View/Auth/login.dart';
import 'package:menzy/utils/App-Contants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarketPlaceController extends GetxController {
  MarketPlaceController();
  List<Product> products = [];
  bool isLoading = false;

  late SharedPreferences prefs;

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    await getProducts();
    super.onInit();
  }

  Future<dynamic> getProducts({
    BuildContext? context,
    var userId,
    File? videoFile,
  }) async {
    Dio dio = Dio();
    try {
      isLoading = true;
      update();
      var response = await dio.get(
        "${AppConstants.SERVER_URL}/api/get_products",
      );
      isLoading = false;
      print("==>>>>>>${response.data}");
      update();
      if (response.statusCode == 200) {
        var result = response.data['data'];
        List<Product> temp = [];
        result.forEach((e) {
          temp.add(Product.fromJson(e));
        });
        products = temp;
        update();
        return temp;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode! > 500) {
          Get.snackbar("Internal Server Error",
              "Something went wrong, please try again");
        } else if (e.response!.statusCode! == 401) {
          Get.put(AuthController())
              .logoutUser(context: context, isUnAuth: true)
              .then((value) => {Get.offAll(() => Login())});
          Get.snackbar(
              "Error", "Please login again, your session has been expired");
        } else if (e.response!.statusCode! >= 400) {
          Get.snackbar('Error', e.response!.statusMessage!);
        }
      } else {
        Get.snackbar(
            "No Internet", "Check your internet connection and try again");
      }

      print(e);

      return e.response;
    }
  }
}
