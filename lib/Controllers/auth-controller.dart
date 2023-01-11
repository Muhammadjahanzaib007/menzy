import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart'as firebase;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:http_parser/http_parser.dart';
import 'package:menzy/Services/api-service.dart';
import 'package:menzy/View/Auth/login.dart';
import 'package:menzy/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/App-Colors.dart';
import '../Models/user.dart';
import '../View/metaverse/metaverse.dart';
import '../View/splash_screen.dart';
import '../utils/App-Contants.dart';
import 'authentication.dart';

class AuthController extends GetxController {
  Rx<User> user = User().obs;
  RxBool remeberme = false.obs;
  late FirebaseMessaging _firebaseMessaging;

  @override
  Future<void> onInit() async {
    _firebaseMessaging = FirebaseMessaging.instance;
    super.onInit();
  }
  Future<Widget> checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLogin = prefs.getString(AppConstants.ACCESS_TOKEN);
    if (isLogin != null) {
      getuserinfo();
      return  MetaverseScreen();
    } else {
      return const Login();
    }
  }
  Future<void> getuserinfo()async{
    user.value = await  ApiService.getSavedUserData();
    update();
    refresh();
    await updateToken();
  }
  Future<void> updateToken() async {
    _firebaseMessaging = FirebaseMessaging.instance;
    String? devicetoken = await _firebaseMessaging.getToken();
    print("Token ===>>> $devicetoken");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt(AppConstants.USER_ID);
    var api = "api/updatetoken?user_id=$id&device_token=$devicetoken";

    try {
      var response = await Get.put(ApiService())
          .callApiWithMap(null, api, 'Post', mapData: {});

      if (response?.statusCode == 200) {
        // await FirebaseFirestore.instance.collection('users').doc(auth.FirebaseAuth.instance.currentUser?.uid).update({
        //   "token": token,
        // });
        print("doneeee");
      }


    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> onSigninCheck(BuildContext context) async {
    var pref = await SharedPreferences.getInstance();
    remeberme.value = pref.getBool(AppConstants.IS_LOGGED) ?? false;
    //FirebaseCrashlytics.instance.crash();

    if (remeberme.value) {
      getuserinfo();
      var api = "auth/stage";
        var response = await Get.put(ApiService()).callApiWithMap(
          context,
          api,
          'Get',
          mapData: {},
        );

        if (response != null && response.statusCode == 200) {
          // user.value = User.fromJson(response.data['profileStage']);
          if (response.data['data']['profileStage'] == 1) {
            // Get.offAll(() => CompleteProfile(
            //     // userName: user.value.name!,
            //     // email: user.value.email!,
            //     ));
          } else if (response.data['data']['profileStage'] == 2)
            Get.off(() => BottomAppBar());
          else
            Get.off(() => Login());
        } else {
          Get.off(() => Login());
        }

    } else
      Get.off(() => Login());
  }



  Future<dynamic> signInWithGoogle({
    BuildContext? context,

  }) async {
    final currentUser = await Authentification().signInWithGoogle();
    Map<String, dynamic> data = {
      'name': currentUser?.displayName,
      'email': currentUser?.email
    };
    print(data);
    var api = 'register-with-google';
    var response =
        await Get.put(ApiService()).signWithMap(context!, api, mapData: data);
print(response?.data);
    if (response?.statusCode == 200) {
      await ApiService.saveUserData(response!);
      await getuserinfo();
      return true;
    } else if (response?.statusCode == 400) {
      print(response?.data);
      Get.snackbar(
          "Error", "Something went Wrong , Please try again after a while",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<dynamic> signUpUser({
    BuildContext? context,
    required String name,
    required String email,
    required String password,

  }) async {
    Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'password': password,
    };
    var api = 'register';
    var response =
        await Get.put(ApiService()).signWithMap(context!, api, mapData: data);

    if (response?.statusCode == 200) {
      await ApiService.saveUserData(response!);
      getuserinfo();
      return response.data;
    } else if (response?.statusCode == 400) {
      Get.snackbar(
          "Error", "Something went Wrong , Please try again after a while",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<dynamic> verifyOTP({
    BuildContext? context,
    int? userId,
    String? otp,
  }) async {
    Map<String, dynamic> data = {
      'user_id': userId,
      'otp': otp,
    };
    var api = "otp-verification?user_id=$userId&otp=$otp";
    var response = await Get.put(ApiService())
        .callApiWithMap(context!, api, 'Get', mapData: data);

    if (response?.statusCode == 200) {
      return response?.data;
    }
  }

  Future<dynamic> updateProfile({
    BuildContext? context,
    String? userId,
    File? image,
    String? firstName,
    String? lastName,
    String? email,
    String? mobileNo,
    String? dob,
    var state,
    var city,
    String? address1,
    String? address2,
    String? zipCode,
    String? randomString,
  }) async {
    FormData formData = image != null
        ? FormData.fromMap({
            "user_image": await MultipartFile.fromFile(image.path,
                filename: image.path.split('/').last,
                contentType: MediaType(
                    'user_image', image.path.split('/').last.split('.').last)),
            'user_id': userId,
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'phone_number': mobileNo,
            'date_of_birth': dob,
            'state_id': state,
            'city_id': city,
            'zipcode': zipCode,
            'address_1': address1,
            'address_2': address2,
            'unique_formid': randomString
          })
        : FormData.fromMap({
            'user_id': userId,
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'phone_number': mobileNo,
            'date_of_birth': dob,
            'state_id': state,
            'city_id': city,
            'zipcode': zipCode,
            'address_1': address1,
            'address_2': address2,
            'unique_formid': randomString
          });
    var api = "update-profile";
    try {
      var response = await Get.put(ApiService())
          .callApiWithform(api: api, formData: formData);

      if (response?.statusCode == 200) {
        Get.snackbar("Congrats", "Profile Updated Successfully",
            backgroundColor: AppColors.lightPrimary, colorText: Colors.white);
        return response!.data;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode! > 500) {
          // Alert().newAlert(context!, 'Internal Server Error',
          //     'Something went wrong, please try again.');
        } else if (e.response!.statusCode! == 401) {
          Get.put(AuthController())
              .logoutUser(context: context, isUnAuth: true)
              .then((value) => {Get.offAll(() => Login())});
          // Alert().newAlert(context!, 'Error',
          //     'Please login again, your session has been expired');
        } else if (e.response!.statusCode! >= 400) {
          // Alert().newAlert(context!, 'Error', e.response!.statusMessage!);
        }
      } else {
        // Alert().newAlert(context!, 'No Internet',
        //     'Check your internet connection and try again.');
      }

      print(e);

      return e.response;
    }
  }

  // Future<SignUpModel?> signUpUser({

  Future<bool> signInUser({
    BuildContext? context,
    required String email,
    required String password,
  }) async {
    var api = "login";

    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };
    var response =
        await Get.put(ApiService()).signWithMap(context!, api, mapData: data);
    print("datatata ${response?.data}");
    if (response != null) {
      if (response.statusCode == 200) {
        // authservice?.logIn(
        //   email,
        //   password,
        // );

        await ApiService.saveUserData(response);
        getuserinfo();
        return true;
      } else if (response.statusCode == 400) {
        Get.snackbar("Error", "Invalid Credentials",
            backgroundColor: AppColors.red, colorText: Colors.white);
        return false;
      } else if (response.statusCode! >= 500) {
        Get.snackbar("Error", "Something went wrong, please try again.",
            backgroundColor: AppColors.red, colorText: Colors.white);
        return false;
      } else {
        Get.snackbar("Error", "${response.data['message']}",
            backgroundColor: AppColors.red, colorText: Colors.white);
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> forgetPassword({BuildContext? context, String? email}) async {
    var api = "forget-password?email=$email";
    Map<String, dynamic> data = {'email': email};
    var response = await Get.put(ApiService())
        .callApiWithMap(context!, api, 'Get', mapData: data);
    print(response?.data);
    if (response != null) {
      Get.snackbar("Response", response.data["message"],
          colorText: Colors.white);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changePassword(
      {BuildContext? context, String? oldPasswod, String? newPassword}) async {
    var api = "auth/changePassword";
    Map<String, dynamic> data = {'old': oldPasswod, 'new': newPassword};
    var response = await Get.put(ApiService())
        .callApiWithMap(context!, api, 'Put', mapData: data);
    if (response != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> resetPassword(
      {BuildContext? context, String? newPassword}) async {
    var api = "auth/resetPassword";
    Map<String, dynamic> data = {'password': newPassword};
    var response = await Get.put(ApiService())
        .callApiWithMap(context!, api, 'Post', mapData: data);
    if (response != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deactivateAccount(
      {BuildContext? context, String? password}) async {
    var api = "auth/account";
    Map<String, dynamic> data = {'password': password};
    var response = await Get.put(ApiService())
        .callApiWithMap(context!, api, 'Delete', mapData: data);
    if (response != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> logoutUser({BuildContext? context, bool? isUnAuth}) async {
    // await authservice?.logOut();
    await ApiService.removeUserData().then((value) => Get.offAll(Login()));
    return true;
  }

  Future<dynamic> resendOTP({
    BuildContext? context,
    String? email,
  }) async {
    var api = "resend-otp?email=$email";
    var response = await Get.put(ApiService())
        .callApiWithMap(context!, api, 'Get', mapData: {});

    if (response?.statusCode == 200) {
      Get.snackbar("Sent", "Email Sent", colorText: Colors.white);
      return response?.data;
    } else {
      Get.snackbar("Error", "${response!.statusMessage}",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }
}
