import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:menzy/Widget/app_button.dart';
import 'package:menzy/Widget/app_text_field.dart';

import '../../Controllers/nft_marketplace_controller.dart';
import '../../Utils/App-Colors.dart';
import '../../Utils/App-TextStyle.dart';

class NFTDetailScreen extends StatefulWidget {
  final int index;
  const NFTDetailScreen({
    Key? key, required this.index,
  }) : super(key: key);

  @override
  State<NFTDetailScreen> createState() => _NFTDetailScreenState();
}

class _NFTDetailScreenState extends State<NFTDetailScreen> {
  TextEditingController pricecont = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text("NFT Detail"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GetBuilder<NFTMarketController>(
          init: NFTMarketController(),
          builder: (value) => value.deloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: AppColors.blueDark,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: AppColors.blueDark,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(value.ownnft[widget.index]?.imgPath ?? ""),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      (value.ownnft[widget.index]?.name ?? "N/A").toUpperCase(),
                      style: AppTextStyle.boldWhite30,
                    ),
                    Text(
                      ("${value.ownnft[widget.index]?.price}/- MNZ").toUpperCase(),
                      style: AppTextStyle.regularWhite16,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Color(0xffFFC107),
                          size: 15,
                        ),
                        Icon(
                          Icons.star,
                          color: Color(0xffFFC107),
                          size: 15,
                        ),
                        Icon(
                          Icons.star,
                          color: Color(0xffFFC107),
                          size: 15,
                        ),
                        Icon(
                          Icons.star,
                          color: Color(0xffFFC107),
                          size: 15,
                        ),
                        Icon(
                          Icons.star,
                          color: Color(0xffFFC107),
                          size: 15,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Description  ",
                      style: AppTextStyle.boldWhite18,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      (value.ownnft[widget.index].description ?? "N/A"),
                      style: AppTextStyle.regularWhite12,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Status  ",
                          style: AppTextStyle.boldWhite18,
                        ),
                        Row(
                          children: [
                            Text(
                              (value.ownnft[widget.index].status == 0 ? "Private" : "Public"),
                              style: AppTextStyle.regularWhite12,
                            ),
                            Switch(
                                value: value.ownnft[widget.index].status == 1 ? true : false,
                                onChanged: (val) {
                                  value.changestatus(
                                      context: context,
                                      id: value.ownnft[widget.index].id,
                                      status: val ? 1 : 0);
                                }),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AppButton(
                        text: "Change Price",
                        height: 55,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => Container(
                              decoration: BoxDecoration(
                                  color: AppColors.blueDark,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    Text(
                                      "Update Price",
                                      style: AppTextStyle.boldWhite18,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    AppTextField(
                                      hint: "",
                                      hintStyle: AppTextStyle.regularWhite12,
                                      textStyle: AppTextStyle.regularWhite14,
                                      controller: pricecont,
                                      keyboardType: TextInputType.number,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: AppButton(
                                          text: "Cancel",
                                          height: 50,
                                          onPressed: () {
                                            Get.back();
                                          },
                                          textColor: AppColors.primary,
                                          overlayColor: Colors.white,
                                          textStyle: AppTextStyle.boldPrimary14,
                                          bgColor: AppColors.white,
                                        )),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                            child: AppButton(
                                          text: "Update",
                                          height: 50,
                                          onPressed: () {
                                            if (pricecont.text.isEmpty) {
                                              Get.snackbar("Add Price",
                                                  "Please add price");
                                            } else {
                                              Get.back();
                                              value.updateprice(
                                                  context: context,
                                                  id: value.ownnft[widget.index].id,
                                                  price: double.parse(
                                                      pricecont.text));
                                              pricecont.clear();
                                            }
                                          },
                                          textColor: AppColors.white,
                                          overlayColor: Colors.white,
                                          textStyle: AppTextStyle.boldWhite14,
                                        ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        textColor: Colors.white,
                        overlayColor: Colors.white,
                        textStyle: AppTextStyle.boldWhite18)
                  ],
                ),
        ),
      ),
    );
  }
}
