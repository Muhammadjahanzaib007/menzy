
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:menzy/Controllers/add-points-controller.dart';
import 'package:menzy/Controllers/auth-controller.dart';
import 'package:menzy/Services/deep_link_service.dart';
import 'package:menzy/View/Auth/login.dart';
import 'package:menzy/View/Auth/otp_verification.dart';
import 'package:menzy/View/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controllers/steps-controller.dart';
import '../../Widget/app_button.dart';
import '../../Widget/app_text_field.dart';
import '../../utils/App-Colors.dart';
import '../../utils/App-TextStyle.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}


class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController name1Controller = TextEditingController();
  TextEditingController name2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool showPass = true;
  bool showConfirmPass = true;
  @override
  void initState() {
    super.initState();

  }



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
                height: 620,
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
                      'Register',
                      style: AppTextStyle.boldWhite34,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'UserName',
                        style: AppTextStyle.mediumWhite16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      borderRadius: 14,
                      controller: nameController,
                      hint: '',
                      hintStyle: AppTextStyle.mediumLightGrey14,
                      textStyle: AppTextStyle.boldWhite12,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Email ID',
                        style: AppTextStyle.mediumWhite16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      borderRadius: 14,
                      controller: emailController,
                      hint: '',
                      hintStyle: AppTextStyle.mediumLightGrey14,
                      textStyle: AppTextStyle.boldWhite12,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Password',
                        style: AppTextStyle.mediumWhite16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      borderRadius: 14,
                      controller: passwordController,
                      hint: '',
                      hintStyle: AppTextStyle.mediumLightGrey14,
                      textStyle: AppTextStyle.boldWhite12,
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
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Re-Enter',
                        style: AppTextStyle.mediumWhite16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      borderRadius: 14,
                      controller: confirmPasswordController,
                      hint: '',
                      hintStyle: AppTextStyle.mediumLightGrey14,
                      textStyle: AppTextStyle.boldWhite12,
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
                          (!showConfirmPass)
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    Container(
                      height: 165,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppButton(
                            text: 'CREATE ACCOUNT',
                            textColor: Colors.white,
                            borderSideColor: AppColors.lightPrimary,
                            overlayColor: AppColors.whiteSplash,
                            textStyle: AppTextStyle.boldWhite18,
                            height: 60,
                            onPressed: () async {
                              if (passwordController.text !=
                                  confirmPasswordController.text) {
                                Get.snackbar("Alert", "Password does not match",
                                    backgroundColor: Colors.red,
                                    colorText: AppColors.black);
                              } else if (!GetUtils.isEmail(
                                  emailController.text)) {
                                Get.snackbar(
                                    "Alert", "Please enter valid email",
                                    backgroundColor: Colors.red,
                                    colorText: AppColors.black);
                              } else if (nameController.text.isNotEmpty &&
                                  emailController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                await EasyLoading.show();
                                var res = await AuthController().signUpUser(
                                  context: context,
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,

                                );

                                if (res != null) {
                                  final stepsController =
                                      Get.put(StepsController());
                                  await stepsController.storeCurrentSteps(
                                      context: context);
                                  await AddPointsController().addPoints(
                                      context: context,
                                      email: res['email'],
                                      points: 0);
                                  EasyLoading.dismiss();
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();



                                  Get.to(() => OtpVerification(
                                        email: emailController.text,
                                      ));
                                }
                              } else {
                                Get.snackbar("Alert", "Please fill the fields",
                                    backgroundColor: Colors.red,
                                    colorText: AppColors.black);
                              }

                            },
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: AppTextStyle.regularWhite12,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.offAll(() => Login());
                                },
                                child: Text(
                                  'Login',
                                  style: AppTextStyle.boldWhite12,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
