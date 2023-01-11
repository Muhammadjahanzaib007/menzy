import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../Controllers/auth-controller.dart';
import '../../Widget/app_button.dart';
import '../../Widget/app_text_field.dart';
import '../../utils/App-Colors.dart';
import '../../utils/App-TextStyle.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 75,
                  ),
                ),
              ),
              Container(
                width: Get.width,
                height: Get.height * 0.55,
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reset Password',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.boldWhite34,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Enter your email address to receive otp to reset password',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.regularWhite12,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Email ID',
                        style: AppTextStyle.mediumWhite18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      controller: emailController,
                      hint: '',
                      hintStyle: AppTextStyle.mediumLightGrey14,
                      textStyle: AppTextStyle.boldWhite12,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: Get.height * 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppButton(
                            text: 'Send',
                            textColor: Colors.white,
                            borderSideColor:AppColors.lightPrimary,
                            overlayColor: AppColors.whiteSplash,
                            textStyle: AppTextStyle.boldWhite18,
                            height: 60,
                            onPressed: () async {

                              if(emailController.text==""){
                                Get.snackbar("Alert", "Enter an email first",colorText: Colors.white);
                              }else {
                                await EasyLoading.show();
                                var res = await AuthController().forgetPassword(
                                    context: context,
                                    email: emailController.text);
                                EasyLoading.dismiss();
                              }
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
