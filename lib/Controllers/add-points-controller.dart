import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:menzy/Services/api-service.dart';

class AddPointsController extends GetxController {
  AddPointsController();

  @override
  void onInit() async {
    super.onInit();
  }

  Future<dynamic> addPoints({
    BuildContext? context,
    String? email,
    var points,
  }) async {
    Map<String, dynamic> data = {
      'user_email': email,
      'points': points,
    };
    var api = "add-points";
    try {
      var response =
          await Get.put(ApiService()).signWithMap(context!, api, mapData: data);
      if (response?.statusCode == 200) {
        return response!.data;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode! > 500) {
          Get.snackbar("Internal Server Error",
              "Something went wrong, please try again");
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
