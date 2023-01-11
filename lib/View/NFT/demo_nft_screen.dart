import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:menzy/Controllers/nft_marketplace_controller.dart';
import 'package:menzy/Models/nftdata.dart';
import 'package:menzy/View/NFT/nft-owned-screen.dart';
import 'package:menzy/Widget/Cards/demo_nft_card.dart';
import 'package:menzy/utils/App-Colors.dart';
import 'package:menzy/utils/App-TextStyle.dart';
import 'package:url_launcher/url_launcher.dart';

class DemoNFTScreen extends StatefulWidget {
  DemoNFTScreen({Key? key}) : super(key: key);

  @override
  State<DemoNFTScreen> createState() => _DemoNFTScreenState();
}

class _DemoNFTScreenState extends State<DemoNFTScreen> {
  var cont = Get.put(NFTMarketController());

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          backgroundColor: AppColors.background,
          expandedHeight: 340,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background:
            SafeArea(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => NftOwned());
                          },
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Menzy Trending Collection",
                              style: AppTextStyle.boldWhite22,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Text(
                          "NFTs (non-fungible tokens) are unique cryptographic tokens that exist on a blockchain and cannot be replicated. NFTs can represent real-world items like artwork and real estate.",
                          style: AppTextStyle.mediumGrey12,
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("8.9K", style: AppTextStyle.boldWhite16),
                              Text("4K", style: AppTextStyle.boldWhite16),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/bnb.png',
                                    width: 8,
                                  ),
                                  Text(
                                    ' 3.42444',
                                    style: AppTextStyle.boldWhite16,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/bnb.png',
                                    width: 8,
                                  ),
                                  Text(
                                    ' 161',
                                    style: AppTextStyle.boldWhite16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("items", style: AppTextStyle.mediumGrey12),
                              Text("owners", style: AppTextStyle.mediumGrey12),
                              Text("  floor price",
                                  style: AppTextStyle.mediumGrey12),
                              Text("total volume",
                                  style: AppTextStyle.mediumGrey12),
                            ],
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
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            GetBuilder<NFTMarketController>(
                init: NFTMarketController(),
                builder: (value) {
                  return value.isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : value.nfts.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              itemCount: value.nfts.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 3 / 3.2),
                              itemBuilder: (BuildContext context, int index) {
                                NFTData nft = value.nfts[index];
                                return DemoNFTCard(
                                  nftdata: value.nfts[index],
                                  onWalletTap: () async {
                                    var url =
                                        "https://menzy.vercel.app/${nft.id}";
                                    Clipboard.setData(ClipboardData(text: url));
                                    await Get.snackbar("Copied", "Url Copied",
                                        colorText: Colors.white);
                                    await launchUrl(
                                      Uri.parse(
                                          "https://metamask.app.link/dapp/menzy.vercel.app/${nft.id}"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                );
                              },
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              controller: ScrollController(),
                              itemCount: 20,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 3 / 3.2),
                              itemBuilder: (BuildContext context, int index) {
                                return DemoNFTCard(
                                  nftdata: NFTData(
                                    name: "test",
                                  ),
                                  onWalletTap: () async {
                                    var url = "https://menzy.vercel.app/${0}";
                                    Clipboard.setData(ClipboardData(text: url));
                                    await Get.snackbar("Copied", "Url Copied",
                                        colorText: Colors.white);
                                    await launchUrl(
                                      Uri.parse(
                                          "https://metamask.app.link/dapp/menzy.vercel.app/${0}"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                );
                              },
                            );
                })
          ]),
        ),
      ]),
    );
  }
}
