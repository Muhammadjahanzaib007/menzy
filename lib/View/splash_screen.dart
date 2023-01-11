import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menzy/Services/api-service.dart';
import 'package:menzy/utils/App-Contants.dart';
import 'package:menzy/utils/App-TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/App-Colors.dart';
import 'metaverse/metaverse.dart';
import 'onboarding_screen.dart';


String? profileImage;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

var isLogin;

class _SplashScreenState extends State<SplashScreen> {
  double value = 0;
  // void determinateIndicator() {
  //   Timer.periodic(Duration(milliseconds: 10), (Timer timer) {
  //     setState(() {
  //       if (value.floor() >= 1) {
  //         timer.cancel();
  //       } else {
  //         value = value + 0.003;
  //       }
  //     });
  //   });
  // }



  @override
  void initState() {
    super.initState();
    // determinateIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff16151c),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/splash_animation.gif"),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SafeArea(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 60,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  "MOVE TO EARN, EASY WITH",
                  style: AppTextStyle.regularWhite16,
                ),
                Text(
                  "Menzy".toUpperCase(),
                  style: AppTextStyle.boldWhite60,
                ),
                Container(
                    padding: const EdgeInsets.all(5.0),
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        border:
                            Border.all(color: AppColors.lightPrimary, width: 4),
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 15,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          value: value,
                          semanticsLabel: "0.7",
                          semanticsValue: "0.7",
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white30),
                          backgroundColor: AppColors.primary,
                        ),
                      ),
                    )),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
