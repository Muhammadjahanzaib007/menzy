import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menzy/View/Auth/change_password.dart';

import '../../Widget/app_button.dart';
import '../../Widget/app_text_field.dart';
import '../../utils/App-Colors.dart';
import '../../utils/App-TextStyle.dart';

class PasswordRecovery extends StatelessWidget {
  const PasswordRecovery({Key? key}) : super(key: key);

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
                  const SizedBox(height: 30),
                  Text(
                    'Please, enter the code we sent you by email.',
                    style: AppTextStyle.mediumLightGrey14,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Code',
                    style: AppTextStyle.mediumWhite14,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppTextField(
                    hint: 'example@gmail.com',
                    hintStyle: AppTextStyle.mediumLightGrey14,
                    textStyle: AppTextStyle.regularWhite14,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: AppButton(
                  bgColor: AppColors.primary,
                  text: 'Confirm',
                  height: 60,
                  onPressed: () {
                    Get.to(() => ChangePassword());
                  },
                  textColor: Colors.white,
                  borderSideColor: AppColors.lightPrimary,
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
