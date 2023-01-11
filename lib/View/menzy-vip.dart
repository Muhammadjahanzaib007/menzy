import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:menzy/View/Auth/login.dart';
import 'package:menzy/Widget/app_button.dart';
import 'package:menzy/Widget/app_text_field.dart';
import 'package:menzy/utils/App-Colors.dart';
import 'package:menzy/utils/App-TextStyle.dart';

class MenzyVIPScreen extends StatefulWidget {
  MenzyVIPScreen({Key? key}) : super(key: key);

  @override
  State<MenzyVIPScreen> createState() => _MenzyVIPScreenState();
}

class _MenzyVIPScreenState extends State<MenzyVIPScreen> {
  bool viewSlider = true;
  TextEditingController linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              'MENZY VIP',
              textAlign: TextAlign.center,
              style: AppTextStyle.boldWhite40,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 380,
              child: Stack(
                children: [
                  Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: AppColors.primary,
                          border: Border.all(
                              color: AppColors.lightPrimary, width: 3),
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "WIN UPTO",
                            style: AppTextStyle.mediumWhite16,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "\$50 ",
                            style: AppTextStyle.boldWhite30,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Worth of Nike & Adidas Gift Cards",
                            style: AppTextStyle.boldWhite12,
                          ),
                          Image.asset(
                            'assets/images/bybit.png',
                          ),
                          Text(
                            "Make your first \$10 \$MNZ Trade\non Bybit TODAY!*",
                            style: AppTextStyle.boldWhite14,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "First 1000 players will recieve a guaranteed \$20 Gift card.",
                            style: AppTextStyle.mediumWhite10,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "First trade has to be a new account sign up",
                            style: AppTextStyle.regularWhite8,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 70,
                        child: Image.asset(
                          'assets/images/logo.png',

                          // height: 50,
                        ),
                      ),
                      Container(
                        height: 120,
                        width: 250,
                        child: Image.asset(
                          'assets/images/mvip.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0, left: 30),
              child: AppTextField(
                // controller: emailController..text = 'demo@gmail.com',
                hint: 'NAME',
                hintStyle: AppTextStyle.mediumLightGrey14,
                textStyle: AppTextStyle.boldWhite12,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0, left: 30),
              child: AppTextField(
                // controller: emailController..text = 'demo@gmail.com',
                hint: 'EMAIL',
                hintStyle: AppTextStyle.mediumLightGrey14,
                textStyle: AppTextStyle.boldWhite12,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            AppButton(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              text: 'Sign up & Trade!',
              height: 55,
              onPressed: () {
                Get.to(Login());
              },
              bgColor: AppColors.tradeColor,
              textColor: AppColors.white,
              overlayColor: AppColors.primarySplash,
              textStyle: AppTextStyle.boldWhite18,
              borderSideColor: AppColors.tradeColorLight,
            ),
            Text(
              'No, I Don’t Want Free Gift Card',
              textAlign: TextAlign.center,
              style: AppTextStyle.mediumGrey12,
            ),
          ],
        ),
      ),
    );
  }
}
