import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:menzy/Controllers/auth-controller.dart';
import 'package:menzy/Controllers/steps-controller.dart';
import 'package:menzy/Services/deep_link_service.dart';
import 'package:menzy/View/Auth/forget_password.dart';
import 'package:menzy/View/Auth/referal_screen.dart';
import 'package:menzy/View/Auth/register.dart';
import 'package:menzy/View/metaverse/metaverse.dart';
import 'package:menzy/utils/App-Contants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widget/app_button.dart';
import '../../Widget/app_text_field.dart';
import '../../dbhelper/DataBaseHelper.dart';
import '../../dbhelper/datamodel/StepsData.dart';
import '../../utils/App-Colors.dart';
import '../../utils/App-TextStyle.dart';
import '../../utils/Utils.dart';
import '../splash_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text(
                  'Login',
                  style: AppTextStyle.boldWhite34,
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
                  controller: emailController..text = '',
                  hint: 'Enter your email address',
                  hintStyle: AppTextStyle.mediumLightGrey14,
                  textStyle: AppTextStyle.boldWhite12,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Password',
                    style: AppTextStyle.mediumWhite18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AppTextField(
                  controller: passwordController..text = '',
                  hint: 'Enter your password',
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
                      (!showPass)
                          ? CupertinoIcons.eye
                          : CupertinoIcons.eye_slash,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ForgetPassword());
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password? ',
                      style: AppTextStyle.mediumGrey12,
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButton(
                        text: 'SIGN IN',
                        textColor: Colors.white,
                        borderSideColor: AppColors.lightPrimary,
                        overlayColor: AppColors.whiteSplash,
                        textStyle: AppTextStyle.boldWhite18,
                        height: 60,
                        onPressed: () async {
                          if (emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            // await EasyLoading.show();
                            var res = await AuthController().signInUser(
                                context: context,
                                email: emailController.text,
                                password: passwordController.text);

                            if (res == true) {
                              final stepsController =
                                  Get.put(StepsController());

                              await stepsController.getSteps(context: context);
                              EasyLoading.dismiss();
                              Get.snackbar("Success", "Login Successfully",
                                  backgroundColor: AppColors.primarySplash,
                                  colorText: AppColors.white,
                                  icon: Icon(
                                    Icons.check,
                                    color: AppColors.white,
                                  ));
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              profileImage = '';
                              Get.offAll(() => MetaverseScreen());
                            }
                          } else {
                            Get.snackbar("Alert", "Please fill the fields",
                                backgroundColor: Colors.red,
                                colorText: AppColors.white);
                          }
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not have an account? ',
                            style: AppTextStyle.regularWhite12,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.offAll(() => Register());
                            },
                            child: Text(
                              'Register',
                              style: AppTextStyle.boldWhite12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var res = await Get.find<AuthController>()
                              .signInWithGoogle(context: context);
                          if (res == true) {
                            final stepsController = Get.put(StepsController());

                            await stepsController.getSteps(context: context);
                            EasyLoading.dismiss();
                            Get.snackbar("Success", "Login Successfully",
                                backgroundColor: AppColors.primarySplash,
                                colorText: AppColors.white,
                                icon: Icon(
                                  Icons.check,
                                  color: AppColors.white,
                                ));
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            profileImage = '';
                            Get.offAll(() => MetaverseScreen());
                          }
                        },
                        child: Container(
                          height: 58,
                          padding: EdgeInsets.all(1),
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/google_icon.png',
                                  width: 32,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Continue with Google',
                                  style: AppTextStyle.boldWhite12,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
