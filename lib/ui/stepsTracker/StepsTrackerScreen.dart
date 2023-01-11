import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:menzy/Controllers/steps-controller.dart';
import 'package:menzy/View/Home/home.dart';
import 'package:menzy/ui/recentActivities/RecentActivitiesScreen.dart';
import 'package:menzy/ui/stepsTracker/statitics-screen.dart';
import 'package:menzy/utils/App-Colors.dart';
import 'package:menzy/utils/App-TextStyle.dart';
import 'package:menzy/utils/Color.dart';
import 'package:menzy/utils/Preference.dart';
import 'package:menzy/utils/Utils.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../Controllers/auth-controller.dart';
import '../../Controllers/wallet_controller.dart';
import '../../View/Steps/step_history.dart';
import '../../View/splash_screen.dart';
import '../../localization/language/languages.dart';

class StepsTrackerScreen extends StatefulWidget {
  @override
  _StepsTrackerScreenState createState() => _StepsTrackerScreenState();
}

class _StepsTrackerScreenState extends State<StepsTrackerScreen> {
  final GlobalKey _key = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController targetStepController = TextEditingController();
  var controller = Get.put(StepsController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Get.to(() => HomeScreen());
        return true;
      },
      child: RepaintBoundary(
        key: _key,
        child: GetBuilder<StepsController>(
          // specify type as Controller
          init: StepsController(), // intialize with the Controller
          builder: (cont) => Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.background,
            body: SafeArea(
                child: Screenshot(
              controller: screenshotController,
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 4, bottom: 0, left: 0, right: 0),
                      width: Get.width,
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.to(() => HomeScreen());
                            },
                            icon: Icon(
                              CupertinoIcons.back,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Step Analytics",
                                  style: AppTextStyle.regularWhite16,
                                ),
                              ),
                              Image.asset('assets/images/foot.png'),
                            ],
                          ),
                          Image.asset(
                            "assets/images/male_avtar.jpeg",
                            height: 45,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "User ID: 9658",
                                style: AppTextStyle.regularWhite12,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Balance",
                                style: AppTextStyle.regularWhite12,
                              ),
                              GetBuilder<WalletController>(
                                // specify type as Controller
                                init:
                                    WalletController(), // intialize with the Controller
                                builder: (cont) => Text(
                                  "MNZ: ${cont.menzyBalance ?? "Connect Wallet"}",
                                  style: AppTextStyle.boldWhite18,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    // Container(
                    //   child: CommonTopBar(
                    //     Languages.of(context)!.txtStepsTracker,
                    //     this,
                    //     isShowBack: true,
                    //     isOptions: true,
                    //   ),
                    // ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, top: 8, bottom: 4),
                              child: Container(
                                width: Get.width,
                                child: Text(
                                  "Great Job ${Get.find<AuthController>().user.value.name ?? ''}",
                                  style: AppTextStyle.regularWhite16,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                  width: Get.width,
                                  child: Text.rich(TextSpan(
                                      text: 'You are',
                                      style: AppTextStyle.mediumWhite14,
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.baseline,
                                          baseline: TextBaseline.alphabetic,
                                          child: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  maxWidth: 100),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: Text(
                                                  "12% better",
                                                  style: AppTextStyle
                                                      .boldPrimary14,
                                                ),
                                              )),
                                        ),
                                        WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.baseline,
                                          baseline: TextBaseline.alphabetic,
                                          child: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  maxWidth: 200),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: Text(
                                                  "than last time!",
                                                  style: AppTextStyle
                                                      .mediumWhite14,
                                                ),
                                              )),
                                        ),
                                      ]))),
                            ),
                            stepsIndicator(),
                            otherInfo(fullHeight, context),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Charts",
                                        style: AppTextStyle.mediumWhite14,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StepsStatisticsScreen(
                                                      currentStepCount:
                                                          int.parse(cont
                                                              .currentStepCount
                                                              .toString())),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 53,
                                          width: 53,
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Image.asset(
                                            'assets/images/stats.png',
                                            color: Colors.white60,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Workout",
                                        style: AppTextStyle.mediumWhite14,
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: IconButton(
                                            onPressed: () {
                                              Get.to(() => StepHistory());
                                            },
                                            icon: Icon(
                                              Icons.history,
                                              color: Colors.white70,
                                              size: 30,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Screenshot",
                                        style: AppTextStyle.mediumWhite14,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          EasyLoading.show();
                                          RenderRepaintBoundary boundary = _key
                                                  .currentContext!
                                                  .findRenderObject()
                                              as RenderRepaintBoundary;

                                          ui.Image image =
                                              await boundary.toImage();
                                          ByteData? byteData =
                                              await image.toByteData(
                                                  format:
                                                      ui.ImageByteFormat.png);
                                          if (byteData != null) {
                                            Uint8List pngBytes =
                                                byteData.buffer.asUint8List();
                                            // ShowCapturedWidget(context, Uint8List.fromList(pngBytes));
                                            // Saving the screenshot to the gallery
                                            final result =
                                                await ImageGallerySaver.saveImage(
                                                    Uint8List.fromList(
                                                        pngBytes),
                                                    quality: 90,
                                                    name:
                                                        'screenshot-${DateTime.now()}.png');

                                            if (kDebugMode) {
                                              print(result);
                                            }
                                            EasyLoading.dismiss();
                                            Get.snackbar("Screenshot saved",
                                                "Screenshot is successfully saved in your gallery.",
                                                icon: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                ),
                                                backgroundColor:
                                                    AppColors.primarySplash,
                                                colorText: Colors.white);
                                            setState(() {
                                              var _message =
                                                  'New screenshot successfully saved!';
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            // color: Colors.white60,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Image.asset(
                                            'assets/images/screenshot_icon.png',
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 34),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'This is Test Mode',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Complete 10000 steps to get rewards',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 34),
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/male_avtar.jpeg'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),

                            recentActivities(fullHeight, fullWidth, context),
                            SizedBox(
                              height: 20,
                            )

                            // weeklyAverage(fullHeight, fullWidth, context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }

  otherInfo(double fullHeight, BuildContext context) {
    return GetBuilder<StepsController>(
        // specify type as Controller
        init: StepsController(), // intialize with the Controller
        builder: (cont) => Container(
              margin: EdgeInsets.only(top: fullHeight * 0.02),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "Time",
                        style: AppTextStyle.mediumWhite14,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<int>(
                          stream: cont.stopWatchTimer.rawTime,
                          builder: (context, snapshot) {
                            cont.time = snapshot.hasData
                                ? snapshot.data! + cont.oldTime!
                                : 0;
                            Preference.shared
                                .setInt(Preference.OLD_TIME, cont.time!);

                            cont.duration = StopWatchTimer.getDisplayTime(
                              cont.time!,
                              hours: true,
                              minute: true,
                              second: false,
                              milliSecond: false,
                              hoursRightBreak: "h ",
                            );
                            Preference.shared
                                .setString(Preference.DURATION, cont.duration!);
                            return Text(
                              cont.duration! + "m",
                              style: AppTextStyle.boldPrimary18,
                            );
                          }),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Text(Languages.of(context)!.txtKcal,
                            style: AppTextStyle.mediumWhite14),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${cont.calories?.toStringAsFixed(0)} Kcal",
                          style: AppTextStyle.boldPrimary18,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        // isKmSelected
                        //     ? 'Distance (${Languages.of(context)!.txtKM})'
                        //     : 'Distance (${Languages.of(context)!.txtMile})',
                        'Speed',
                        style: AppTextStyle.mediumWhite14,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${cont.distance?.toStringAsFixed(2)} km/h",
                        style: AppTextStyle.boldPrimary18,
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }

  recentActivities(double fullHeight, double fullWidth, BuildContext context) {
    return GetBuilder<StepsController>(
        // specify type as Controller
        init: StepsController(), // intialize with the Controller
        builder: (cont) => Visibility(
              visible: cont.recentActivityShow,
              child: Container(
                margin: EdgeInsets.only(
                    top: 30, left: fullWidth * 0.05, right: fullWidth * 0.05),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            Languages.of(context)!.txtRecentActivities,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colur.txt_white),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RecentActivitiesScreen()));
                          },
                          child: Text(
                            Languages.of(context)!.txtMore,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    recentActivitiesList(fullHeight, cont.isKmSelected)
                  ],
                ),
              ),
            ));
  }

  recentActivitiesList(double fullHeight, bool isKmSelected) {
    return GetBuilder<StepsController>(
        // specify type as Controller
        init: StepsController(), // intialize with the Controller
        builder: (cont) => Container(
              margin: EdgeInsets.only(top: 20),
              child: ListView.builder(
                  itemCount: cont.recentActivitiesData.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int index) {
                    return _activitiesView(context, index, fullHeight);
                  }),
            ));
  }

  _activitiesView(BuildContext context, int index, double fullheight) {
    return GetBuilder<StepsController>(
        // specify type as Controller
        init: StepsController(), // intialize with the Controller
        builder: (cont) => InkWell(
              // onTap: () {
              //   Navigator.push(
              //       context, MaterialPageRoute(builder: (context) => RunHistoryDetailScreen(recentActivitiesData[index])));
              // },
              child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(13.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        child: Image.file(
                          cont.recentActivitiesData[index].getImage()!,
                          errorBuilder: (
                            BuildContext context,
                            Object error,
                            StackTrace? stackTrace,
                          ) {
                            return Image.asset(
                              "assets/icons/ic_route_map.png",
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            );
                          },
                          height: 90,
                          width: 90,
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cont.recentActivitiesData[index].date!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: AppColors.primary),
                              ),
                              Row(
                                children: [
                                  Text(
                                    (cont.isKmSelected)
                                        ? cont.recentActivitiesData[index]
                                            .distance!
                                            .toString()
                                        : Utils.kmToMile(cont
                                                .recentActivitiesData[index]
                                                .distance!)
                                            .toStringAsFixed(2),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 21,
                                        color: AppColors.white),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 4),
                                    child: Text(
                                      (cont.isKmSelected)
                                          ? Languages.of(context)!.txtKM
                                          : Languages.of(context)!.txtMile,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: AppColors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: fullheight * 0.01),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Utils.secToString(cont
                                          .recentActivitiesData[index]
                                          .duration!),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: AppColors.white),
                                    ),
                                    Text(
                                      cont.recentActivitiesData[index].speed !=
                                              null
                                          ? (cont.isKmSelected)
                                              ? cont.recentActivitiesData[index]
                                                  .speed!
                                                  .toStringAsFixed(2)
                                              : Utils.minPerKmToMinPerMile(cont
                                                      .recentActivitiesData[
                                                          index]
                                                      .speed!)
                                                  .toStringAsFixed(2)
                                          : "Infinity",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: AppColors.white),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          cont.recentActivitiesData[index].cal!
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                              color: AppColors.white),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: Text(
                                            Languages.of(context)!.txtKcal,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: AppColors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  buildWeekCircularIndicator(double fullHeight, String weekDay, double value) {
    return Column(
      children: [
        CircularProgressIndicator(
          strokeWidth: 5,
          value: value,
          valueColor: AlwaysStoppedAnimation(Colur.txt_green),
          backgroundColor: Colur.progress_background_color,
        ),
        Container(
          margin: EdgeInsets.only(top: fullHeight * 0.02),
          child: Text(
            weekDay,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colur.txt_white),
          ),
        ),
      ],
    );
  }

  buildStepIndiactorRow(
      BuildContext context, double fullHeight, double fullWidth) {
    return GetBuilder<StepsController>(
        // specify type as Controller
        init: StepsController(), // intialize with the Controller
        builder: (cont) => Container(
              margin: EdgeInsets.only(
                left: fullWidth * 0.02,
                right: fullWidth * 0.02,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: fullHeight * 0.02),
                        width: fullWidth * 0.7,
                        height: fullHeight * 0.3,
                        child: stepsIndicator(),
                      ),
                      cont.isPause!
                          ? Text('')
                          : Container(
                              padding: EdgeInsets.all(4),
                              height: 30,
                              width: 80,
                              // decoration: BoxDecoration(
                              //   color: AppColors.white,
                              //   borderRadius: BorderRadius.circular(14),
                              // ),
                              child: Center(
                                child: Text(
                                  Languages.of(context)!.txtPaused,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (cont.isLocked) {
                              cont.isLocked = false;
                              cont.update();
                            } else {
                              cont.isLocked = true;
                              cont.update();
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cont.isLocked
                                  ? Colors.white60
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Image.asset(
                              'assets/images/lock_icon.png',
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            cont.isPause = !cont.isPause!;
                            Preference.shared
                                .setBool(Preference.IS_PAUSE, cont.isPause!);
                            cont.update();

                            Future.delayed(Duration(milliseconds: 100), () {
                              if (cont.isPause == true) {
                                if (cont.currentStepCount! > 0) {
                                  cont.currentStepCount =
                                      cont.currentStepCount! - 1;
                                } else {
                                  cont.currentStepCount = 0;
                                }
                                cont.stopWatchTimer.onExecute
                                    .add(StopWatchExecute.start);
                                cont.calculateDistance();
                                cont.calculateCalories();
                                cont.getTodayStepsPercent();
                                cont.checksteps();
                              } else {
                                cont.stopWatchTimer.onExecute
                                    .add(StopWatchExecute.stop);
                                cont.stepCountStream!.cancel();
                              }
                            });
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 64,
                                width: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                ),
                              ),
                              Image.asset(
                                cont.isPause == false
                                    ? "assets/icons/ic_play.png"
                                    : "assets/icons/ic_pause.png",
                                height: 18,
                                width: 14,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => StepsStatisticsScreen(currentStepCount: currentStepCount!)));
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              // color: Colors.white60,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Image.asset(
                              'assets/images/screenshot_icon.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => StepsStatisticsScreen(currentStepCount: currentStepCount!)));
                  //   },
                  //   child: Stack(
                  //     alignment: Alignment.center,
                  //     children: [
                  //       Container(
                  //         height: 44,
                  //         width: 44,
                  //         decoration: BoxDecoration(
                  //           shape: BoxShape.circle,
                  //           color: Colur.progress_background_color,
                  //         ),
                  //       ),
                  //       Image.asset(
                  //         "assets/icons/ic_statistics.png",
                  //         height: 15,
                  //         width: 19,
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ));
  }

  editTargetStepsBottomDialog(double fullHeight, double fullWidth) {
    return showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colur.white,
      builder: (context) {
        return GetBuilder<StepsController>(
            // specify type as Controller
            init: StepsController(), // intialize with the Controller
            builder: (cont) => Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    height: fullHeight * 0.5,
                    color: Colur.common_bg_dark,
                    child: Container(
                      decoration: new BoxDecoration(
                          color: Colur.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32))),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: fullHeight * 0.04,
                            horizontal: fullWidth * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Languages.of(context)!.txtEditTargetSteps,
                              style: TextStyle(
                                  color: Colur.txt_black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: fullHeight * 0.01),
                            Text(
                              Languages.of(context)!.txtEditStepsTargetDesc,
                              style: TextStyle(
                                  color: Colur.txt_grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: fullHeight * 0.04),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Languages.of(context)!.txtSteps,
                                      style: TextStyle(
                                          color: Colur.txt_black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Container(
                                      height: 60,
                                      width: 167,
                                      decoration: BoxDecoration(
                                          color: Colur.txt_grey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: TextFormField(
                                        maxLines: 1,
                                        maxLength: 7,
                                        controller: targetStepController,
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        style: TextStyle(
                                            color: Colur.txt_white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700),
                                        cursorColor: Colur.txt_white,
                                        decoration: InputDecoration(
                                          counterText: "",
                                          border: InputBorder.none,
                                        ),
                                        onEditingComplete: () {
                                          FocusScope.of(context).unfocus();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: fullHeight * 0.04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 165,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colur.light_red_stop_gredient1,
                                        Colur.light_red_gredient2
                                      ]),
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0.0, 25),
                                          spreadRadius: 2,
                                          blurRadius: 50,
                                          color: Colur.red_gradient_shadow,
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colur.transparent,
                                      child: InkWell(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            Navigator.pop(context);
                                          },
                                          child: Center(
                                            child: Text(
                                              Languages.of(context)!.txtCancel,
                                              style: TextStyle(
                                                  color: Colur.txt_white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          )),
                                    ),
                                  ),
                                  Container(
                                    width: 165,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colur.green_gradient_color1,
                                        Colur.green_gradient_color2
                                      ]),
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0.0, 25),
                                          spreadRadius: 2,
                                          blurRadius: 50,
                                          color: Colur.green_gradient_shadow,
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colur.transparent,
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              cont.targetSteps = int.parse(
                                                  targetStepController.text);
                                            });
                                            if (cont.targetSteps! > 50) {
                                              Preference.shared.setInt(
                                                  Preference.TARGET_STEPS,
                                                  cont.targetSteps!);
                                              FocusScope.of(context).unfocus();
                                              Navigator.pop(context);
                                            } else {
                                              //TODO
                                            }
                                          },
                                          child: Center(
                                            child: Text(
                                              Languages.of(context)!.txtSave,
                                              style: TextStyle(
                                                  color: Colur.txt_white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
      },
    ).whenComplete(() {
      controller.getStepsDataForCurrentWeek();
      FocusScope.of(context).unfocus();
    });
  }

  stepsIndicator() {
    return GetBuilder<StepsController>(
        // specify type as Controller
        init: StepsController(), // intialize with the Controller
        builder: (cont) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 230,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Container(
                              width: Get.width,
                              child: Text("Steps",
                                  style: AppTextStyle.boldWhite18)),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 90.0, right: 8, left: 20),
                            child: Container(
                              width: Get.width,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cont.currentStepCount != null
                                        ? cont.currentStepCount.toString()
                                        : "0",
                                    style: TextStyle(
                                        fontSize: 88,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.white),
                                  ),
                                  Image.asset(
                                    'assets/images/foot.png',
                                    height: 30,
                                    width: 20,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
