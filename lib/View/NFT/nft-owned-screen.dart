import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menzy/Controllers/nft_marketplace_controller.dart';
import 'package:menzy/Models/nftdata.dart';
import 'package:menzy/Widget/Cards/demo_nft_card.dart';
import 'package:menzy/utils/App-Colors.dart';
import 'package:menzy/utils/App-TextStyle.dart';

class NftOwned extends StatefulWidget {
  NftOwned({Key? key}) : super(key: key);

  @override
  State<NftOwned> createState() => _NftOwnedState();
}

class _NftOwnedState extends State<NftOwned> {
  var cont = Get.put(NFTMarketController());

  Widget build(BuildContext context) {
    return GetBuilder<NFTMarketController>(
        init: NFTMarketController(),
        builder: (value) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                backgroundColor: AppColors.background,
                expandedHeight: 330,
                flexibleSpace: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  Color.fromARGB(255, 247, 195, 64),
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "nft_7675656",
                              style: AppTextStyle.boldWhite18,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              value.address ?? '',
                              style: AppTextStyle.mediumGrey12,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.Greyshade300,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8),
                      child: Align(
                        alignment: Alignment.center,
                        child: TextField(
                          decoration: new InputDecoration(
                            hintText: "Search items",
                            hintStyle: AppTextStyle.mediumWhite14,
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.Greyshade300,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        value.isLoading
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : value.ownnft.isNotEmpty
                                ? InkWell(
                                    onTap: () async {},
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        height: Get.height - 380,
                                        child: GridView.builder(
                                          itemCount: value.ownnft.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 3 / 3.2),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            NFTData? nft = value.ownnft[index];
                                            return DemoNFTCard(
                                              nftdata: value.nfts[index],
                                              onWalletTap: () {},
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: Get.height - 330,
                                    child: Center(
                                      child: Text(
                                        "No Record Found",
                                        style: AppTextStyle.mediumGrey12,
                                      ),
                                    ),
                                  )
                      ],
                    ),
                  )
                ]),
              ),
            ]),
          );
        });
  }
}
