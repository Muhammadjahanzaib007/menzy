import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menzy/Controllers/wallet_controller.dart';
import 'package:menzy/View/Home/home.dart';
import 'package:menzy/utils/App-Colors.dart';
import 'package:menzy/utils/App-TextStyle.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  var contt = Get.put(WalletController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    contt.connector.on(
        'connect',
        (session) => setState(
              () {
                contt.session = session;
              },
            ));
    contt.connector.on(
        'session_update',
        (payload) => setState(() {
              contt.session = payload;
              print(contt.session.accounts[0]);
              print(contt.session.chainId);
            }));
    contt.connector.on(
        'disconnect',
        (payload) => setState(() {
              contt.session = null;
            }));

    return GetBuilder<WalletController>(
      init: WalletController(),
      // specify type as Controller// intialize with the Controller
      builder: (cont) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1.0, right: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.offAll(() => HomeScreen());
                        },
                        icon: Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Wallet",
                        style: AppTextStyle.mediumWhite16,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 34),
                          height: 60,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/male_avtar.jpeg'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                cont.isBSC.value == true
                    ? Container(
                        height: Get.height - 100,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                border: Border.all(
                                    width: 3, color: AppColors.lightPrimary),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 150,
                              margin: EdgeInsets.symmetric(vertical: 20),
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  SizedBox(
                                      height: 65,
                                      width: 90,
                                      child: Icon(
                                        Icons.account_balance_wallet,
                                        size: 55,
                                        color: Colors.white,
                                      )),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Balance",
                                        style: AppTextStyle.mediumWhite16,
                                      ),
                                      Text(
                                        cont.balance != null
                                            ? (cont.balance /
                                                    1000000000000000000)
                                                .toString()
                                            : "loading...",
                                        style: AppTextStyle.boldWhite30,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "+10876 (34.2%)",
                                        style: TextStyle(
                                            color: AppColors.greenn,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Wallet Balance",
                                      style: AppTextStyle.mediumWhite16,
                                    ),
                                    Text(
                                      cont.balance != null
                                          ? (cont.balance / 1000000000000000000)
                                              .toString()
                                          : "loading...",
                                      style: AppTextStyle.boldWhite30,
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.darkslategrey),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            "assets/images/logo.png",
                                            width: 50,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              cont.menzyBalance != null
                                                  ? Text(
                                                      cont.menzyBalance
                                                          .toString(),
                                                      style: AppTextStyle
                                                          .boldWhite16,
                                                    )
                                                  : CircularProgressIndicator(),
                                              Text(
                                                "MNZs",
                                                style:
                                                    AppTextStyle.mediumGrey12,
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Column(
                                            children: [
                                              Image.asset(
                                                index % 2 == 0
                                                    ? "assets/images/greengraph.png"
                                                    : "assets/images/redgraph.png",
                                                width: 60,
                                              ),
                                              Text(
                                                "+ 96",
                                                style: index % 2 == 0
                                                    ? AppTextStyle.boldgreen16
                                                    : AppTextStyle.boldred16,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      )
                    : Container(
                        height: Get.height - 100,
                        child: Center(
                          child: Text(
                            "Please select BSC Chain to get results",
                            style: AppTextStyle.mediumWhite14,
                          ),
                        ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
