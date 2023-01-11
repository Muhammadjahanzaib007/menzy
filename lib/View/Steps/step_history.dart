import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menzy/Controllers/steps-controller.dart';
import 'package:menzy/dbhelper/DataBaseHelper.dart';

import '../../Controllers/auth-controller.dart';
import '../../Services/api-service.dart';
import '../../Widget/app_button.dart';
import '../../dbhelper/datamodel/StepsData.dart';
import '../../utils/App-Colors.dart';
import '../../utils/App-TextStyle.dart';
import '../Auth/login.dart';
import '../splash_screen.dart';

class StepHistory extends StatefulWidget {
  const StepHistory();

  @override
  State<StepHistory> createState() => _StepHistoryState();
}

class _StepHistoryState extends State<StepHistory> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final statusBar = MediaQuery.of(context).padding.top;
    final extraHeight = 300;
    final mainContainer = screenHeight - statusBar - extraHeight;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                  ),
                ),

                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Step History",
                    style: AppTextStyle.regularWhite16,
                  ),
                ),
                // const SizedBox(
                // width: 5,
                // ),

                Spacer(),
                PopupMenuButton(
                    padding: const EdgeInsets.only(right: 11, top: 5),
                    iconSize: 42,
                    icon: SizedBox(
                      height: 42,
                      width: 42,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: profileImage ?? '',
                          fit: BoxFit.fill,
                          width: 100,
                          placeholder: (context, url) => const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.primary),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            color: AppColors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      // backgroundImage:
                      //     AssetImage('assets/images/profile_image.png'),
                    ), // add this line
                    itemBuilder: (_) => <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  Get.find<AuthController>().user.value.name ?? "John Doe",
                                  style: AppTextStyle.mediumGrey14,
                                ),
                              ),
                              value: '1'),
                          PopupMenuItem<String>(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  "Log Out",
                                  style: AppTextStyle.mediumGrey14,
                                ),
                              ),
                              value: '2'),
                        ],
                    onSelected: (index) async {
                      switch (index) {
                        case '1':
                          // Get.to(() => CompleteProfile());
                          break;
                      }

                      switch (index) {
                        case '2':
                          await ApiService.removeUserData();

                          Get.offAll(() => const Login());
                          break;
                      }
                    }),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                'Step History',
                style: AppTextStyle.boldWhite18,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 12),
              child: SizedBox(
                height: mainContainer,
                child: GetBuilder<StepsController>(builder: (stepc) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: stepc.allStepsData.length,
                    itemBuilder: (((context, index) => stepc
                            .allStepsData.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              height: 60,
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: AppColors.blueDark,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          stepc.allStepsData[index].steps
                                              .toString(),
                                          style: AppTextStyle.mediumWhite20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'steps',
                                          style: AppTextStyle.regularWhite12,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'today',
                                          style: AppTextStyle.mediumWhite10,
                                        ),
                                        Image.asset(
                                          'assets/images/mobile.png',
                                          width: 30,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Text('No Data'))),
                  );
                }),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8),
            //   child: AppButton(
            //       text: "Show Previous Steps",
            //       height: 50,
            //       onPressed: () {
            //         Get.back();
            //       },
            //       textColor: AppColors.white,
            //       borderSideColor: AppColors.primary,
            //       overlayColor: AppColors.lightBlue,
            //       textStyle: AppTextStyle.boldWhite16),
            // )
          ],
        ),
      ),
    );
  }
}
