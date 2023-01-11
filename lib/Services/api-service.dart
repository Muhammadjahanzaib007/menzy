// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:menzy/Controllers/auth-controller.dart';
import 'package:menzy/Models/user.dart';
import 'package:menzy/View/Auth/login.dart';
import 'package:menzy/View/Home/home.dart';
import 'package:menzy/View/splash_screen.dart';
import 'package:menzy/utils/App-Contants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _endPoint = '/api/';
  static String bearer = 'bearer ';

  static getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(AppConstants.ACCESS_TOKEN) ?? '';
    print(token);
    return bearer + token;
  }

  static Future saveAccessToken(String tokenValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.setString(AppConstants.ACCESS_TOKEN, tokenValue);
    print(token);
    return token;
  }

  static Future saveTime(String timeValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var time = await prefs.setString(AppConstants.TIME, timeValue);
    print(time);
    return time;
  }

  Future<Response<dynamic>?> callApiWithform({
    String? api,
    FormData? formData,
  }) async {
    // try {
    Dio dio = Dio();

    dio.options.headers['Authorization'] = await getAccessToken();
    String SERVER_URL = AppConstants.SERVER_URL + _endPoint + "$api";

    var response = await dio.post(SERVER_URL, data: formData);
    if (response.statusCode == 200) {
      print("Get Data: ${response.data}");

      return response;
    } else {
      print("Response Message : ${response.statusMessage}");
      return response;
    }
    // } on DioError catch (e) {
    //   if (e.response != null) {
    //     if (e.response!.statusCode! > 500) {
    //       Get.snackbar("Internal Server Error ", "Somethinf went wrong, please try again",
    //           backgroundColor: Colors.black, colorText: Colors.red);
    //     } else if (e.response!.statusCode! == 401) {
    //       Get.put(AuthController())
    //           .logoutUser(context: context, isUnAuth: true)
    //           .then((value) => {Get.offAll(() => Login())});
    //       newAlert(context!, 'Error', 'Please login again, your session has been expired');
    //     } else if (e.response!.statusCode! >= 400) {
    //       Get.snackbar("Error", e.response!.statusMessage!,
    //           backgroundColor: Colors.black, colorText: Colors.red, duration: Duration(seconds: 5));
    //     }

    //     return e.response;
    //   } else {
    //     Get.snackbar("Http Error", "Something Went Wrong", backgroundColor: Colors.black, colorText: Colors.red);
    //   }

    //   if (EasyLoading.isShow) EasyLoading.dismiss();
    // }
  }

  Future<Response<dynamic>?> callApiWithMap(
      BuildContext? context, String api, String requestType,
      {required Map<String, dynamic> mapData}) async {
    try {
      Dio dio = Dio();
      dio.options.headers['Authorization'] = await getAccessToken();

      String SERVER_URL = AppConstants.SERVER_URL + _endPoint + "$api";
      var response;
      print(SERVER_URL);
      if (requestType == 'Get') {
        response = await dio.get(
          SERVER_URL,
        );
      } else if (requestType == 'Post') {
        response = await dio.post(SERVER_URL, data: mapData);
      } else if (requestType == 'Put') {
        response = await dio.put(SERVER_URL, data: mapData);
      } else if (requestType == 'Delete') {
        response = await dio.delete(SERVER_URL, data: mapData);
      }

      if (response.statusCode == 200) {
        print("Get Data: ${response.data}");
        return response;
      } else {
        print("Response Message : ${response.statusMessage}");
        return response;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode! > 500) {
          Get.snackbar("Error", "${e.response!.statusMessage}",
              backgroundColor: Colors.red, colorText: Colors.white);
        } else if (e.response!.statusCode! == 401) {
          Get.snackbar("Error", "${e.response!.data['message']}",
              backgroundColor: Colors.red, colorText: Colors.white);
        }

        return e.response;
      } else {}
    }
  }

  Future<Response<dynamic>?> signWithMap(BuildContext context, String api,
      {required Map<String, dynamic> mapData}) async {
    try {
      Dio dio = new Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 60 * 1000, // 60 seconds
          receiveTimeout: 60 * 1000));
      String SERVER_URL = AppConstants.SERVER_URL + _endPoint + "$api";
      var response;
      response = await dio.post(SERVER_URL, data: mapData);
      if (response.statusCode == 200) {
        print("Get Data: $response");
        return response;
      } else {
        print("Response Message : ${response.statusMessage}");
        return response;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.type == DioErrorType.connectTimeout) {
          throw Exception("Connection  Timeout Exception");
        }
        if (e.response!.statusCode! >= 500) {
          // newAlert(
          //     context, 'Error', 'Check your internet connection and try again');
        } else if (e.response!.statusCode! == 401) {
          Get.put(AuthController())
              .logoutUser(context: context, isUnAuth: true)
              .then((value) => {Get.offAll(() => Login())});
          // newAlert(context, 'Error',
          //     'Please login again, your session has been expired');
        }
      } else {
        // newAlert(context, 'No Internet',
        //     'Check your internet connection and try again');
      }
      print(e);

      return e.response;
    }
  }

  static Future<void> saveUserData(Response<dynamic> response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.ACCESS_TOKEN, response.data!['token']);
    await prefs.setInt(AppConstants.USER_ID, response.data!['id']);
    await prefs.setString(AppConstants.USER_NAME, response.data!['name']);
    await prefs.setString(AppConstants.USER_EMAIL, response.data!['email']);

  }

   static Future<User> getSavedUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString(AppConstants.ACCESS_TOKEN);
    int? id =   prefs.getInt(AppConstants.USER_ID);
    String? userName =   prefs.getString(AppConstants.USER_NAME);
    String? token =   prefs.getString(AppConstants.ACCESS_TOKEN);
    String? email =   prefs.getString(AppConstants.USER_NAME);
    return User(token: token,id: id,name: userName,email: email);
  }

  static Future<void> removeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(
      AppConstants.ACCESS_TOKEN,
    );
    await prefs.remove(
      AppConstants.USER_NAME,
    );
    await prefs.remove(
      AppConstants.USER_ID,
    );
    await prefs.remove(
      AppConstants.USER_EMAIL,
    );
  }
}
