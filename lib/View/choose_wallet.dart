import 'package:appcheck/appcheck.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menzy/Controllers/wallet_controller.dart';
import 'package:menzy/Widget/app_button.dart';
import 'package:menzy/utils/App-Colors.dart';
import 'package:menzy/utils/App-TextStyle.dart';
import 'package:store_redirect/store_redirect.dart';

class ChooseWalletScreen extends StatefulWidget {
  const ChooseWalletScreen({Key? key}) : super(key: key);

  @override
  State<ChooseWalletScreen> createState() => _ChooseWalletScreenState();
}

class _ChooseWalletScreenState extends State<ChooseWalletScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          height: 35,
                        ),
                        Text(
                          "  Menzy Wallet",
                          style: AppTextStyle.regularWhite16,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    )
                  ],
                ),
                SizedBox(
                  height: 42,
                ),
                Text(
                  "Choose Your Wallet",
                  style: AppTextStyle.boldWhite30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "By connecting your wallet , you agree to MENZY's Terms of Service and Privacy Policy.",
                    style: AppTextStyle.regularWhite14,
                  ),
                ),

                SizedBox(
                  height: 70,
                ),
                GetBuilder<WalletController>(
                    init: WalletController(),
                    builder: (walletC) {
                      return AppButton(
                        tostart: true,
                        bgColor: AppColors.darkslategrey,
                        text: "Metamask",
                        height: 60,
                        radius: 10,
                        is3d: false,
                        onPressed: () async {
                          AppCheck.launchApp("io.metamask").then((_) {
                            debugPrint(
                              "${"io.metamask"} launched!",
                            );
                            walletC.loginUsingMetamask(context);
                          }).catchError((err) async {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "${walletC.metamaskPackage} not found!",
                              ),
                            ));

                            StoreRedirect.redirect(
                                androidAppId: "io.metamask",
                                iOSAppId: "1438144202");
                          });
                          // loginUsingMetamask(context);
                        },
                        textColor: Colors.white,
                        borderSideColor: AppColors.darkslategrey,
                        overlayColor: Colors.transparent,
                        textStyle: AppTextStyle.mediumWhite14,
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5),
                          child: Image.asset(
                            "assets/icons/metamask.png",
                            width: 30,
                          ),
                        ),
                      );
                    }),
                // SizedBox(
                //   height: 20,
                // ),
                // AppButton(
                //   tostart: true,
                //   bgColor: AppColors.darkslategrey,
                //   text: "Trust Wallet",
                //   height: 60,
                //   onPressed: () {},
                //   textColor: Colors.white,
                //   borderSideColor: AppColors.darkslategrey,
                //   overlayColor: Colors.transparent,
                //   textStyle: AppTextStyle.mediumWhite14,
                //   leading: Padding(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                //     child: Image.asset("assets/icons/TWT.png"),
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // AppButton(
                //   tostart: true,
                //   bgColor: AppColors.darkslategrey,
                //   text: "Enter ethereum address",
                //   height: 60,
                //   onPressed: () {},
                //   textColor: Colors.white,
                //   borderSideColor: AppColors.darkslategrey,
                //   overlayColor: Colors.transparent,
                //   textStyle: AppTextStyle.mediumWhite14,
                //   leading: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //     child: Icon(
                //       Icons.link,
                //       size: 45,
                //       color: Colors.grey.shade300,
                //     ),
                //   ),
                // ),
                Spacer(),
                Row(
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: AssetImage('assets/images/male_avtar.jpeg'),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Column(
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
                          'Complete 10000 steps\nto get rewards',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 70,
                )
                // AppButton(
                //   text: "Continue",
                //   height: 65,
                //   onPressed: () {},
                //   textColor: Colors.white,
                //   borderSideColor: Color(0xffFF6B9F),
                //   overlayColor: Colors.transparent,
                //   textStyle: AppTextStyle.mediumWhite14,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
