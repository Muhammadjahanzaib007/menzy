import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menzy/Controllers/auth-controller.dart';
import 'package:menzy/View/NFT/demo_nft_screen.dart';
import 'package:menzy/View/Recording/video_capture_screen.dart';
import 'package:menzy/View/choose_wallet.dart';
import 'package:menzy/View/connect-wallet.dart';
import 'package:menzy/View/metaverse/metaverse.dart';
import 'package:menzy/View/splash_screen.dart';
import 'package:menzy/ui/stepsTracker/StepsTrackerScreen.dart';
import 'package:menzy/utils/App-Contants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_button/slider_button.dart';

import '../../Controllers/wallet_controller.dart';
import '../../dbhelper/DataBaseHelper.dart';
import '../../dbhelper/datamodel/StepsData.dart';
import '../../utils/App-Colors.dart';
import '../../utils/App-TextStyle.dart';
import '../Steps/exit-app.dart';

int oldCount = 0;
var UserId;

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool secondButtonText = false;
  String? recodedPath;
  List<String>? videosPath = [];
  bool viewSlider = true;

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userId = prefs.getInt(AppConstants.USER_ID);
    setState(() {
      UserId = userId;
    });
  }

  checkWalletConnection() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('account') != null && pref.getInt('chainid') != null) {
      setState(() {
        iswalletconnected = true;
      });
    } else {
      setState(() {
        iswalletconnected = false;
      });
    }
  }

  File? videoFile;
  bool isLoading = false;
  getStepsData() async {
    var stepsData = await DataBaseHelper().getAllStepsData();

    stepsData.forEach((element) {
      oldCount += element.steps!;
    });
  }

  bool iswalletconnected = false;

  @override
  void initState() {
    getUserId();
    getStepsData();
    checkWalletConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: () async {
      //   Get.offAll(() => MyAppEx());
      //   return true;
      // },
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/images/male_avtar.jpeg",
                      height: 45,
                    ),
                  ),
                ),

                Image.asset(
                  "assets/images/logo.png",
                  width: 50,
                  height: 50,
                ),

                PopupMenuButton(
                    padding: const EdgeInsets.only(right: 1, top: 0),
                    iconSize: 42,
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 26,
                    ), // add this line
                    itemBuilder: (_) => <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  Get.find<AuthController>().user.value.name ?? 'John Doe',
                                  style: AppTextStyle.mediumGrey14,
                                ),
                              ),
                              value: '1'),
                          PopupMenuItem<String>(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  "Settings",
                                  style: AppTextStyle.mediumGrey14,
                                ),
                              ),
                              value: '2'),
                          PopupMenuItem<String>(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  "Log Out",
                                  style: AppTextStyle.mediumGrey14,
                                ),
                              ),
                              value: '3'),
                        ],
                    onSelected: (index) async {
                      switch (index) {
                        case '1':
                          // Get.to(() => CompleteProfile());
                          break;
                      }
                      switch (index) {
                        case '2':
                          break;
                      }
                      switch (index) {
                        case '3':
                          Get.put(AuthController()).logoutUser();
                          DataBaseHelper().deleteSteps();

                          break;
                      }
                    }),
                // Expanded(
                //   child: TextButton(
                //     onPressed: () {
                //       // Navigator.pop(context);

                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: [
                //         Icon(
                //           Icons.logout,
                //           color: Colors.white,
                //           size: 24,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
            InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20),
              child: Stack(
                children: [
                  Container(
                    height: 290,
                    width: double.infinity,
                    child: Stack(
                      children: <Widget>[
                        Center(
                            child: ClipOval(
                          child: Container(
                            color: AppColors.primary,
                            height: Get.width * 0.72, // height of the button
                            width: Get.width * 0.72, // width of the button
                          ),
                        )),
                        Center(
                          child: GestureDetector(
                            onTap: () {},
                            child: AvatarGlow(
                              glowColor: Color.fromRGBO(255, 255, 255, 0.8),
                              endRadius: 200.0,
                              duration: Duration(milliseconds: 2000),
                              repeat: true,
                              showTwoGlows: true,
                              repeatPauseDuration: Duration(milliseconds: 100),
                              child: ClipOval(
                                child: Container(
                                  //color: Colors.green,
                                  height:
                                      Get.width * 0.62, // height of the button
                                  width:
                                      Get.width * 0.62, // width of the button
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.white,
                                          width: 10.0,
                                          style: BorderStyle.solid),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(21.0, 10.0),
                                            blurRadius: 20.0,
                                            spreadRadius: 40.0)
                                      ],
                                      shape: BoxShape.circle),
                                  child: CircularPercentIndicator(
                                    radius: 90.0,
                                    lineWidth: 8.0,
                                    percent: 1.0,
                                    linearGradient: LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        Color(0xffffffff)
                                      ],
                                      stops: [0.0, 0.6],
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter,
                                      // tileMode: TileMode.repeated,
                                    ),
                                    center: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${stamina.toPrecision(1)}%",
                                          style: AppTextStyle.boldBlack34,
                                        ),
                                        Text(
                                          "Stamina",
                                          style: AppTextStyle.boldBlack18,
                                        ),
                                        Text(
                                          "Test Mode",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          width: Get.width * 0.35,
                                          child: Text(
                                            "Explore Menzy in test mode. Tokens are not rewarded in test mode.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // progressColor: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 10,
                    right: 10,
                    child: Visibility(
                      visible: viewSlider,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                width: 3.5, color: AppColors.lightPrimary)),
                        padding: EdgeInsets.all(0),
                        child: SliderButton(
                          action: () {
                            // Navigator.pop(context);
                            Get.offAll(() => MetaverseScreen());

                            setState(() {
                              viewSlider = false;
                            });
                            print("working");
                          },

                          ///Put label over here
                          label: Text.rich(
                            TextSpan(
                              text: 'MenzyVerse',
                              style: AppTextStyle.boldWhite18,
                              children: <TextSpan>[
                                TextSpan(
                                  text: '  Swipe to Enter',
                                  style: TextStyle(
                                      color: Colors.white38, fontSize: 12),
                                ),
                              ],
                            ),
                          ),

                          icon: Image.asset(
                            'assets/images/logo.png',
                            width: 52,
                          ),

                          //Adjust effects such as shimmer and flag vibration here
                          shimmer: true,
                          dismissible: false,
                          // vibrationFlag: true,

                          ///Change All the color and size from here.
                          width: 300,
                          height: 65,
                          radius: 50,

                          buttonColor: Colors.transparent,
                          backgroundColor: AppColors.primary,
                          highlightedColor: Colors.white,
                          baseColor: Colors.white12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            isLoading
                ? Container(
                    height: 400,
                    width: 200,
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        const LinearProgressIndicator(
                          backgroundColor: Colors.grey,
                          color: AppColors.white,
                          minHeight: 5,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Video Uploading...",
                          style: AppTextStyle.mediumWhite14,
                        )
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    Get.to(
                                      () => StepsTrackerScreen(),
                                    );
                                  },
                                  child: Container(
                                    height: 66,
                                    width: 66,
                                    decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        border: Border.all(
                                            color: AppColors.lightPrimary,
                                            width: 3),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Image.asset(
                                      'assets/images/shoes.png',
                                      fit: BoxFit.none,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Menzy Step",
                                  style: AppTextStyle.regularWhite10,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => CameraScreen());
                                  },
                                  child: Container(
                                    height: 66,
                                    width: 66,
                                    decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        border: Border.all(
                                            color: AppColors.lightPrimary,
                                            width: 3),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Image.asset(
                                      'assets/images/video.png',
                                      fit: BoxFit.scaleDown,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Menzy Move",
                                  style: AppTextStyle.regularWhite10,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    WalletController walletController =
                                        await Get.put(WalletController());
                                    await walletController.getValues();
                                    if (walletController
                                            .isWalletConnected.value ==
                                        false) {
                                      Get.to(() => ChooseWalletScreen());
                                    } else {
                                      Get.to(() => WalletScreen());
                                    }
                                  },
                                  child: Container(
                                    height: 66,
                                    width: 66,
                                    decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        border: Border.all(
                                            color: AppColors.lightPrimary,
                                            width: 3),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Image.asset(
                                      'assets/images/wallet.png',
                                      fit: BoxFit.none,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Menzy Wallet",
                                  style: AppTextStyle.regularWhite10,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    String? address =
                                        prefs.getString("account");
                                    int? chainid = prefs.getInt("chainid");
                                    if (address == null) {
                                      Get.snackbar("Connect Wallet",
                                          "Please connect your MetaMask wallet to the MENZY App",
                                          colorText: Colors.white);
                                    } else if (chainid == 56 || chainid == 97) {
                                      Get.to(() => DemoNFTScreen());
                                    } else
                                      Get.snackbar("Wrong Chain",
                                          "Connect your metamask BSC chain",
                                          colorText: Colors.white);
                                  },
                                  child: Container(
                                    height: 66,
                                    width: 66,
                                    decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        border: Border.all(
                                            color: AppColors.lightPrimary,
                                            width: 3),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Icon(
                                        Icons.house_outlined,
                                        size: 34,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Menzy NFT",
                                  style: AppTextStyle.regularWhite10,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                // Get.to(() => Marketscreen());
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Menzy Market",
                    style: AppTextStyle.boldWhite22.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // Get.to(() => Marketscreen());
              },
              child: Container(
                height: 170,
                child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: ((context, index) => Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 8, top: 8, bottom: 8),
                          child: Container(
                            width: 250,
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(15)),
                            child: Image.asset(
                              "assets/images/social.png",
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ))),
                // GetBuilder<MarketPlaceController>(
                //   init: MarketPlaceController(),
                //   builder: (cont) => cont.isLoading
                //       ? Center(child: CircularProgressIndicator())
                //       : ListView.builder(
                //           itemCount: (cont.products.length),
                //           scrollDirection: Axis.horizontal,
                //           itemBuilder: ((context, index) {
                //             Product product = cont.products[index];
                //             return Padding(
                //               padding: const EdgeInsets.only(
                //                   left: 10.0, right: 8, top: 8, bottom: 8),
                //               child: Container(
                //                 width: 300,
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(15),
                //                   color: AppColors.blueDark,
                //                 ),
                //                 child: Row(
                //                   children: [
                //                     Expanded(
                //                       child: Container(
                //                         decoration: BoxDecoration(
                //                             borderRadius: BorderRadius.only(
                //                                 topLeft: Radius.circular(15),
                //                                 bottomLeft:
                //                                     Radius.circular(15)),
                //                             color: AppColors.blueDark,
                //                             image: DecorationImage(
                //                               image: NetworkImage(
                //                                   "${AppConstants.SERVER_URL}/${product.image}"),
                //                               fit: BoxFit.fill,
                //                             )),
                //                       ),
                //                     ),
                //                     Expanded(
                //                       child: Container(
                //                         padding: EdgeInsets.all(10),
                //                         decoration: BoxDecoration(
                //                           borderRadius: BorderRadius.only(
                //                               topRight: Radius.circular(15),
                //                               bottomRight: Radius.circular(15)),
                //                           color: AppColors.blueDark,
                //                         ),
                //                         child: Column(
                //                           children: [
                //                             Align(
                //                               child: Text(
                //                                 (product.name ?? "")
                //                                     .toUpperCase(),
                //                                 style: AppTextStyle.boldWhite14,
                //                               ),
                //                               alignment: Alignment.topLeft,
                //                             ),
                //                             SizedBox(
                //                               height: 5,
                //                             ),
                //                             Align(
                //                               child: Text(
                //                                 "MNZ ${product.price} /-",
                //                                 style:
                //                                     AppTextStyle.boldPrimary14,
                //                               ),
                //                               alignment: Alignment.topLeft,
                //                             ),
                //                             SizedBox(
                //                               height: 10,
                //                             ),
                //                             Align(
                //                               child: Text(
                //                                 (product.description ?? ""),
                //                                 style:
                //                                     AppTextStyle.regularWhite12,
                //                                 overflow: TextOverflow.ellipsis,
                //                                 maxLines: 4,
                //                               ),
                //                               alignment: Alignment.topLeft,
                //                             ),
                //                             Spacer(),
                //                             Align(
                //                               child: Container(
                //                                 padding: EdgeInsets.only(
                //                                     top: 2,
                //                                     bottom: 3,
                //                                     left: 5,
                //                                     right: 5),
                //                                 decoration: BoxDecoration(
                //                                     color: product.status == 1
                //                                         ? Colors.green
                //                                         : Colors.redAccent,
                //                                     borderRadius:
                //                                         BorderRadius.circular(
                //                                             20)),
                //                                 child: Text(
                //                                   product.status == 1
                //                                       ? "In stock"
                //                                       : "Out of stock",
                //                                   style: AppTextStyle
                //                                       .regularWhite12,
                //                                 ),
                //                               ),
                //                               alignment: Alignment.bottomRight,
                //                             )
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             );
                //           })),
                // ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Pay with MNZ",
                style: AppTextStyle.mediumWhite16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
