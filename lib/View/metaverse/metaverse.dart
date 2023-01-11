import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:menzy/View/Home/home.dart';
import 'package:menzy/dbhelper/DataBaseHelper.dart';
import 'package:menzy/ui/stepsTracker/StepsTrackerScreen.dart';

import '../../Controllers/auth-controller.dart';
import '../../Controllers/steps-controller.dart';
import '../../Controllers/wallet_controller.dart';
import '../../Repository/user_repository.dart';
import '../../Utils/App-Colors.dart';
import '../../Utils/App-TextStyle.dart';
import '../../Widget/app_button.dart';
import '../../dbhelper/datamodel/StepsData.dart';
import '../../utils/Preference.dart';
import '../../utils/Utils.dart';
import '../Recording/video_capture_screen.dart';
import '../splash_screen.dart';

class MetaverseScreen extends StatefulWidget {
  @override
  _MetaverseScreenState createState() => _MetaverseScreenState();
}

double stamina = 100;
UnityWidgetController? unityWidgetController;

class _MetaverseScreenState extends State<MetaverseScreen> {
  bool isButtonShow = false;
  bool isAlertDialogShow = false;
  // final userRepo = UserRepository.instance;
  myFun() {
    // userRepo.updateToken();
    const oneHour = Duration(
      seconds: 5,
    );
    Timer.periodic(oneHour, (Timer t) async {
      if (mounted) {
        setState(() {
          isButtonShow = true;
        });
      }
    });
  }

  isFirstTime() async {
    if (Preference.shared.getBool(Preference.IS_USER_FIRSTTIME) == true)
      alertDialogShow();
  }

  alertDialogShow() async {
    Future.delayed(Duration(seconds: 0), () async {
      setState(() {
        isAlertDialogShow = true;
      });
      await showAlertDialog(context);
    });
  }

  final stepController = Get.put(StepsController());
  checkConnectivity() async {
    var subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        var listener =
            InternetConnectionChecker().onStatusChange.listen((status) {
          switch (status) {
            case InternetConnectionStatus.connected:
              print('Data connection is available.');
              DataBaseHelper().insertSteps(StepsData(
                  steps: stepController.currentStepCount,
                  targetSteps: stepController.targetSteps != null
                      ? stepController.targetSteps
                      : 6000,
                  cal: stepController.calories!.toInt(),
                  distance: stepController.distance,
                  duration: stepController.duration,
                  time: Utils.getCurrentDayTime(),
                  stepDate: stepController.oldTime.toString(),
                  dateTime: Utils.getCurrentDateTime()));
              stepController.getAllStepsData();
              // stepController.storeSteps(
              //     userId: UserId ?? 61, steps: stepController.currentStepCount);
              break;
            case InternetConnectionStatus.disconnected:
              print('You are disconnected from the internet.');

              stepController.setTime();
              break;
          }
        });

        print(listener);
      }
    });
    print(subscription);
  }

  @override
  void initState() {
    // checkConnectivity();
    myFun();
    super.initState();
    isFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Fluttertoast.showToast(msg: "To quit the App , Go back to home!");
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // key: _scaffoldKey,
        body: Column(
          children: [
            Expanded(
              child: isAlertDialogShow
                  ? Container(
                      color: AppColors.black,
                    )
                  : UnityWidget(
                      uiLevel: 0,
                      useAndroidViewSurface: true,
                      fullscreen: true,
                      onUnityCreated: onUnityCreated,
                      onUnityMessage: onUnityMessage,
                    ),
            ),
            Container(
              color: Colors.black87,
              child: Row(
                children: [
                  Container(
                    // width: MediaQuery.of(context).size.width * 0.35,
                    height: 50,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12))),
                    child: Row(
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 6),
                            width: 40,
                            child: Text(
                              "MNZ",
                              style: AppTextStyle.boldWhite12,
                            )),
                        SizedBox(
                          width: 4,
                        ),
                        GetBuilder<WalletController>(
                          // specify type as Controller
                          init:
                          WalletController(), // intialize with the Controller
                          builder: (cont) => Text(
                            "${cont.menzyBalance ?? "Connect wallet.."}",
                            style: AppTextStyle.regularWhite10,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () async {
                      if (unityWidgetController != null) {
                        await unityWidgetController!.pause();
                        Get.offAll(() => HomeScreen());
                      } else {
                        Get.snackbar(
                            "Alert", "Please wait,Unity Assets loading...",
                            backgroundColor: AppColors.primarySplash,
                            colorText: AppColors.white,
                            icon: Icon(
                              Icons.error,
                              color: AppColors.white,
                            ));
                      }
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                          // width: MediaQuery.of(context).size.width * 0.5,
                          // padding: EdgeInsets.all(6),
                          child: Image.asset(
                        'assets/images/menzy-logo.png',
                        height: 48,
                      )),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.offAll(StepsTrackerScreen());
                    },
                    child: Container(
                      height: 50,
                      // width: MediaQuery.of(context).size.width * 0.35,
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12))),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            child: Image.asset(
                              'assets/images/shoes.png',
                              height: 20,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          GetBuilder<StepsController>(
                            init: StepsController(),
                            builder: (cont) => Text(
                              cont.currentStepCount != null
                                  ? cont.currentStepCount.toString()
                                  : "0",
                              style: AppTextStyle.regularWhite12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Communication from Unity to Flutter
  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');

    if (message == "StartTheChallenge") {
      unityWidgetController!.pause();
      Get.offAll(() => CameraScreen(
            fromunity: true,
          ));
    } else if (message.toString().contains("Stamina")) {
      print(message.toString().split("Stamina").last);
      setState(() {
        stamina = double.parse(message.toString().split("Stamina").last);
      });
    } else {
      Get.snackbar("Error", "Error invoking function");
    }
  }

  var stepcont = Get.put(StepsController());
  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) async {
    unityWidgetController = controller;
    unityWidgetController?.postMessage('StepsCatcher', 'StepsFromFlutter',
        (stepcont.currentStepCount ?? 0).toString());
    print("to unity ${Get.find<AuthController>().user.value.name}");
    unityWidgetController?.postMessage('AuthHandler', 'GetUserName', Get.find<AuthController>().user.value.name);
    print("to unity ${FirebaseAuth.instance.currentUser?.email}");
    unityWidgetController?.postMessage(
        'AuthHandler', 'GetEmail', FirebaseAuth.instance.currentUser?.email);
    await unityWidgetController!.pause();
    Future.delayed(
      Duration(milliseconds: 100),
      () async {
        await unityWidgetController!.resume();
      },
    );
  }

  // Communication from Unity when new scene is loaded to Flutter
  void onUnitySceneLoaded(SceneLoaded sceneInfo) {
    print('Received scene loaded from unity: ${sceneInfo.name}');
    print(
        'Received scene loaded from unity buildIndex: ${sceneInfo.buildIndex}');
  }

  showAlertDialog(BuildContext context) async {
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
                  "Safety First!",
                  style: AppTextStyle.boldWhite30,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Always remember to be aware of your surroundings at all times. This game should not be played while driving.Have responsible & safe fun! ",
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
                text: "Ok",
                height: 50,
                bgColor: AppColors.secondary,
                onPressed: () {
                  Navigator.pop(context);
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
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    setState(() {
      isAlertDialogShow = false;
    });
  }
}
