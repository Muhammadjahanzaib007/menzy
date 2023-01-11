import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:http_parser/http_parser.dart';
import 'package:menzy/Controllers/auth-controller.dart';
import 'package:menzy/Services/api-service.dart';
import 'package:menzy/View/Auth/login.dart';
import 'package:menzy/View/metaverse/metaverse.dart';

import '../../utils/App-Colors.dart';

class VideoController extends GetxController {
  VideoController();

  @override
  void onInit() async {
    super.onInit();
  }

  Future<dynamic> uploadVideo({
    BuildContext? context,
    var userId,
    File? videoFile,
    bool? fromunity,
  }) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(videoFile!.path,
          filename: videoFile.path.split('/').last,
          contentType: MediaType(
              'file', videoFile.path.split('/').last.split('.').last)),
      'user_id': userId,
    });

    var api = "upload-video";
    try {
      var response = await Get.put(ApiService())
          .callApiWithform(api: api, formData: formData);

      if (response?.statusCode == 200) {
        fromunity == true ? Get.offAll(MetaverseScreen()) : Get.back();
        Get.snackbar("Congrats", "File Uploaded Successfully",
            backgroundColor: AppColors.primarySplash,
            colorText: AppColors.white);
        return response!.data;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode! > 500) {
          Get.snackbar("Internal Server Error",
              "Something went wrong, please try again");
        } else if (e.response!.statusCode! == 401) {
          bool loggedOut = await AuthController()
              .logoutUser(context: context, isUnAuth: true);
          if (loggedOut) {
            Get.offAll(() => const Login());
          }
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
