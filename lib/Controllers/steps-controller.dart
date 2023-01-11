import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:menzy/Controllers/auth-controller.dart';
import 'package:menzy/Models/get-step-model.dart';
import 'package:menzy/Services/api-service.dart';
import 'package:menzy/View/Auth/login.dart';
import 'package:menzy/View/Home/home.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../Utils/App-Colors.dart';
import '../Utils/App-TextStyle.dart';
import '../View/metaverse/metaverse.dart';
import '../Widget/app_button.dart';
import '../dbhelper/DataBaseHelper.dart';
import '../dbhelper/datamodel/StepsData.dart';
import '../localization/locale_constant.dart';
import '../utils/Debug.dart';
import '../utils/Preference.dart';
import '../utils/Utils.dart';
import 'authentication.dart';

class StepsController extends GetxController {
  StepsController();
  bool? isPause = true;
  bool isLocked = false;
  int? targetSteps;
  int? oldStepCount;
  int? totalSteps;
  double? distance;
  String? duration;
  int? time;
  int? oldTime;
  double? calories;
  List<double>? stepsPercentValue = [];
  List<String> weekDates = [];
  final StopWatchTimer stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  int? height;
  int? weight;
  bool _isBannerAdReady = false;
  bool isReset = false;
  int? currentStepCount;
  var newTargetSteps;
  StreamSubscription<StepCount>? stepCountStream;
  bool isKmSelected = true;
  int? last7DaysSteps;
  Future<void> signout() async {
    await Authentification().signOut();
  }

  DateTime currentDate = DateTime.now();

  List<StepsData>? stepsData;
  Map<String, int> map = {};
  List<String> allDaysInSingleWord =
      DateFormat.EEEE(getLocale().languageCode).dateSymbols.NARROWWEEKDAYS;

  bool recentActivityShow = false;
  List<dynamic> recentActivitiesData = [];
  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  List<StepsData> allStepsData = [];

  @override
  void onInit() async {
    checkPermsion();
    super.onInit();
  }

  countStep() async {
    var status = await Permission.activityRecognition.request();
    print(status.isGranted);
    if (status.isGranted) {
      stepCountStream = Pedometer.stepCountStream.listen((value) async {
        print("hello$value");

        totalSteps = value.steps;
        Preference.shared.setInt(Preference.TOTAL_STEPS, totalSteps!);

        currentStepCount = currentStepCount! + 1;
        Preference.shared.setInt(Preference.CURRENT_STEPS, currentStepCount!);
        update();

        bool? isReady = (await unityWidgetController?.isReady());
        if (unityWidgetController != null && isReady == true)
          unityWidgetController?.postMessage('StepsCatcher', 'StepsFromFlutter',
              (currentStepCount ?? 0).toString());
      }, onError: (error) {
        totalSteps = 0;
        Debug.printLog("Error: $error");
      }, cancelOnError: false);
    }
  }

  getisPauseFromPrefs() {
    isPause = Preference.shared.getBool(Preference.IS_PAUSE) ?? true;

    if (isPause == true) {
      if (currentStepCount! > 0) {
        currentStepCount = currentStepCount! - 1;
      } else {
        currentStepCount = 0;
      }
      stopWatchTimer.onExecute.add(StopWatchExecute.start);
      calculateDistance();
      calculateCalories();
      getTodayStepsPercent();
      checksteps();
    }
  }

  getAllStepsData() async {
    allStepsData = await DataBaseHelper().getAllStepsData();
    update();
    // var yesterDay = DateTime.now().subtract(Duration(days: 1));
    // yesterDay = DateTime(
    //     yesterDay.year, yesterDay.month, yesterDay.day, 00, 00, 00, 00, 00);
    // allStepsData.length;
    // if (allStepsData.length == 0) {
    //   newTargetSteps = 6000;
    // } else {
    //   print(yesterDay.toString());
    //   newTargetSteps = allStepsData
    //       .where((element) => element.stepDate == yesterDay.toString())
    //       .first
    //       .steps;
    // }
  }

  _checkMapData() async {
    var result = await DataBaseHelper().getRecentTasksAsStream();
    recentActivitiesData.addAll(result);

    if (result.isEmpty || result.length == 0) {
      recentActivityShow = false;
      update();
    } else {
      recentActivityShow = true;
      update();
    }
  }

  checkPermsion() async {
    var status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      getPreference();
      getisPauseFromPrefs();
      countStep();
      setTime();
      getAllStepsData();
      calculateDistance();
      DataBaseHelper().getAllStepsData();
      getStepsDataForCurrentWeek();
      getLast7DaysSteps();
      // _loadBanner();
      _checkMapData();
    }
  }

  checksteps() {
    if ((currentStepCount ?? 0) >= 15000) {
      if ((currentStepCount ?? 0) % 500 == 0) showAlertDialog();
    }
  }

  showAlertDialog() async {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/logo.png",
            height: 60,
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: Get.width,
            decoration: BoxDecoration(
                color: AppColors.primary,
                border: Border.all(color: AppColors.lightPrimary, width: 3),
                borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Daily Step Cap",
                  style: AppTextStyle.boldWhite22,
                ),
                Text(
                  "Reached!",
                  style: AppTextStyle.boldWhite30,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "We have detected suspicious activity. You have been temporarily locked. Please contact: support@menzy . io",
                  style: AppTextStyle.mediumWhite16,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 50,
              width: Get.width,
              child: AppButton(
                text: "Back",
                height: 50,
                bgColor: AppColors.secondary,
                onPressed: () {
                  Get.back();
                },
                textColor: AppColors.white,
                borderSideColor: AppColors.secondarylight,
                overlayColor: Colors.white,
                textStyle: AppTextStyle.mediumWhite16,
                width: 350,
              )),
        ],
      ),
    );

    // show the dialog
    Get.defaultDialog(content: alert, barrierDismissible: false);
  }

  getTodayStepsPercent() {
    var todayDate = getDate(DateTime.now()).toString();
    if (targetSteps == null) {
      targetSteps = 6000;
    }
    for (int i = 0; i < weekDates.length; i++) {
      if (todayDate == weekDates[i]) {
        double value = currentStepCount!.toDouble() / targetSteps!.toDouble();
        if (value <= 1.0) {
          if (stepsPercentValue!.isNotEmpty) {
            stepsPercentValue![i] = value;
          }
        } else {
          stepsPercentValue![i] = 1.0;
        }

        update();
      }
    }
  }

  // openPopUpMenu(fullHeight, fullWidth) async {
  //   final String? result = await Navigator.push(context, StepsPopUpMenu());
  //
  //   if (result == Constant.STR_EDIT_TARGET) {
  //     setState(() {
  //       var prefSteps = Preference.shared.getInt(Preference.TARGET_STEPS);
  //
  //       if (prefSteps != null) {
  //         targetStepController.text = prefSteps.toString();
  //       } else {
  //         targetStepController.text = 6000.toString();
  //       }
  //       editTargetStepsBottomDialog(fullHeight, fullWidth);
  //     });
  //   }
  //
  //   if (result == Constant.STR_RESET) {
  //     resetData();
  //   }
  //
  //   if (result == Constant.STR_TURNOFF) {
  //     setState(() {
  //       if (isPause!) {
  //         _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
  //         _stepCountStream!.cancel();
  //         isPause = false;
  //         Preference.shared.setBool(Preference.IS_PAUSE, isPause!);
  //       }
  //     });
  //   }
  // }

  getPreference() {
    targetSteps = Preference.shared.getInt(Preference.TARGET_STEPS) ?? 6000;
    currentStepCount = Preference.shared.getInt(Preference.CURRENT_STEPS) ?? 0;
    oldTime = Preference.shared.getInt(Preference.OLD_TIME) ?? 0;
    duration = Preference.shared.getString(Preference.DURATION) ?? "00h 0";
    distance = Preference.shared.getDouble(Preference.OLD_DISTANCE) ?? 0;
    calories = Preference.shared.getDouble(Preference.OLD_CALORIES) ?? 0;
    height = Preference.shared.getInt(Preference.HEIGHT) ?? 164;
    weight = Preference.shared.getInt(Preference.WEIGHT) ?? 50;
    isKmSelected = Preference.shared.getBool(Preference.IS_KM_SELECTED) ?? true;
  }

  resetData() {
    totalSteps = Preference.shared.getInt(Preference.TOTAL_STEPS);
    oldStepCount = Preference.shared.getInt(Preference.TOTAL_STEPS);
    if (totalSteps != null) {
      currentStepCount = totalSteps! - oldStepCount!;
    } else {
      currentStepCount = 0;
    }
    Preference.shared.setInt(Preference.CURRENT_STEPS, currentStepCount!);

    distance = 0;
    Preference.shared.setDouble(Preference.OLD_DISTANCE, distance!);

    calories = 0;
    Preference.shared.setDouble(Preference.OLD_CALORIES, calories!);

    oldTime = 0;
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);

    if (isPause!) stopWatchTimer.onExecute.add(StopWatchExecute.start);

    var todayDate = getDate(DateTime.now()).toString();
    for (int i = 0; i < weekDates.length; i++) {
      if (todayDate == weekDates[i]) {
        stepsPercentValue![i] = 0;
      }
    }
    update();
  }

  calculateDistance() {
    if (isKmSelected) {
      distance = currentStepCount! * 0.0008;
      Preference.shared.setDouble(Preference.OLD_DISTANCE, distance!);
    } else {
      distance = currentStepCount! * 0.0008 * 0.6214;
      Preference.shared.setDouble(Preference.OLD_DISTANCE, distance!);
    }

    update();
  }

  calculateCalories() {
    calories = currentStepCount! * 0.04;
    Preference.shared.setDouble(Preference.OLD_CALORIES, calories!);

    update();
  }

  setTime() async {
    DateTime? oldDate;
    var date = Preference.shared.getString(Preference.DATE);
    if (date != null) {
      oldDate = DateTime.parse(date);
    }

    var currentDate = getDate(DateTime.now());
    Preference.shared.setString(Preference.DATE, currentDate.toString());

    if (oldDate != null) {
      if (currentDate != oldDate) {
        DataBaseHelper().insertSteps(StepsData(
            steps: currentStepCount,
            targetSteps: targetSteps != null ? targetSteps : 6000,
            cal: calories!.toInt(),
            distance: distance,
            duration: duration,
            time: Utils.getCurrentDayTime(),
            stepDate: oldDate.toString(),
            dateTime: Utils.getCurrentDateTime()));
        await storeCurrentSteps(context: null);
        resetData();
      }
    }
  }

  getStepsDataForCurrentWeek() async {
    for (int i = 0; i <= 6; i++) {
      var currentWeekDates = getDate(DateTime.now()
          .subtract(Duration(days: currentDate.weekday - 1))
          .add(Duration(days: i)));
      weekDates.add(currentWeekDates.toString());
    }
    stepsData = await DataBaseHelper().getStepsForCurrentWeek();

    for (int i = 0; i < weekDates.length; i++) {
      bool isMatch = false;
      stepsData!.forEach((element) {
        if (element.stepDate == weekDates[i]) {
          isMatch = true;

          double value = element.steps!.toDouble() / targetSteps!.toDouble();
          if (value <= 1.0) {
            stepsPercentValue!.add(value);
          } else {
            stepsPercentValue!.add(1.0);
          }
        }
      });
      if (!isMatch) {
        stepsPercentValue!.add(0.0);
      }
    }
    update();
    getTodayStepsPercent();
  }

  getLast7DaysSteps() async {
    last7DaysSteps = await DataBaseHelper().getTotalStepsForLast7Days();
    update();
  }

  Future<dynamic> storeCurrentSteps({
    BuildContext? context,
  }) async {
    FormData formData = FormData.fromMap({
      "steps": currentStepCount ?? 0,
      'user_id': UserId,
      'date': DateTime.now()
    });

    var api = "steps/store";
    try {
      var response = await Get.put(ApiService())
          .callApiWithform(api: api, formData: formData);

      if (response?.statusCode == 200) {
        Fluttertoast.showToast(msg: "Record Saved Successfully");
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

//loop api
  Future<dynamic> syncStepHistoryData({
    BuildContext? context,
  }) async {
    getLast7DaysSteps();
    FormData formData = FormData.fromMap(
        {"steps": currentStepCount, 'user_id': UserId, 'date': DateTime.now()});

    var api = "steps/store";
    try {
      var response = await Get.put(ApiService())
          .callApiWithform(api: api, formData: formData);

      if (response?.statusCode == 200) {
        Fluttertoast.showToast(msg: "Record Saved Successfully");
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

  // get Steps from server
  Future<dynamic> getSteps({
    BuildContext? context,
  }) async {
    var api = "steps/get?user_id=$UserId";
    List<Data> getStepList = [];
    try {
      var response = await Get.put(ApiService())
          .callApiWithMap(context!, api, 'Get', mapData: {});

      if (response?.statusCode == 200) {
        var result = GetStepModel.fromJson(response?.data);
        getStepList = result.data!;
        getStepList.forEach((element) {
          DataBaseHelper().insertSteps(StepsData(
              steps: element.steps,
              targetSteps: 6000,
              cal: (double.parse(element.steps.toString()) / 14.0).toInt(),
              distance: element.steps! * 0.0008,
              duration: 0.toString(),
              time: element.date,
              stepDate: element.date,
              dateTime: element.date));
        });

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
