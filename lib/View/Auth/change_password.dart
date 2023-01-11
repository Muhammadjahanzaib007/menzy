
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menzy/View/Auth/login.dart';

import '../../Widget/app_button.dart';
import '../../Widget/app_text_field.dart';
import '../../utils/App-Colors.dart';
import '../../utils/App-TextStyle.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool showPass = true;

  bool showConfirmPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 125,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Welcome to Menzy',
                      style: AppTextStyle.boldPrimary22,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Password Recovery',
                      style: AppTextStyle.mediumWhite20,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Please, create new password.',
                    style: AppTextStyle.mediumLightGrey14,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Password',
                    style: AppTextStyle.mediumWhite14,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppTextField(
                    hint: 'Choose a strong password',
                    hintStyle: AppTextStyle.mediumLightGrey14,
                    textStyle: AppTextStyle.regularWhite14,
                    obsecure: showPass,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (showPass) {
                          setState(() {
                            showPass = false;
                          });
                        } else {
                          setState(() {
                            showPass = true;
                          });
                        }
                      },
                      child: Icon(
                        (!showPass) ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Confirm Password',
                    style: AppTextStyle.mediumWhite14,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppTextField(
                    hint: 'Re-enter new password',
                    hintStyle: AppTextStyle.mediumLightGrey14,
                    textStyle: AppTextStyle.regularWhite14,
                    obsecure: showConfirmPass,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (showConfirmPass) {
                          setState(() {
                            showConfirmPass = false;
                          });
                        } else {
                          setState(() {
                            showConfirmPass = true;
                          });
                        }
                      },
                      child: Icon(
                        (!showConfirmPass) ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: AppButton(
                  bgColor: AppColors.primary,
                  text: 'Confirm',
                  height: 60,
                  onPressed: () {
                    Get.offAll(() => Login());
                  },
                  textColor: Colors.white,
                  borderSideColor:AppColors.lightPrimary,
                  overlayColor: AppColors.whiteSplash,
                  textStyle: AppTextStyle.mediumWhite18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
