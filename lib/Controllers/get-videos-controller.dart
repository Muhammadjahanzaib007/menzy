import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:menzy/Controllers/auth-controller.dart';
import 'package:menzy/Models/get-videos-model.dart';
import 'package:menzy/Services/api-service.dart';
import 'package:menzy/View/Auth/login.dart';

class GetVideoController extends GetxController {
  GetVideoController();
  List<Data> menzyVideos = [];

  @override
  void onInit() async {
    // await getVideo();
    super.onInit();
  }

  Future<dynamic> getVideo({
    BuildContext? context,
    var userId,
    File? videoFile,
  }) async {
    var api = "all-videos";
    try {
      var response = await Get.put(ApiService())
          .callApiWithMap(context!, api, 'Get', mapData: {});

      if (response?.statusCode == 200) {
        var result = GetVideosModel.fromJson(response?.data);
        menzyVideos = result.data!;
        return response!.data;
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
