import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:menzy/View/NFT/Statistic_tab_bar.dart';
import 'package:menzy/Widget/Cards/hot_collection_card.dart';
import 'package:menzy/Widget/Cards/trending_nft_card.dart';
import 'package:menzy/Widget/app_text_field.dart';
import 'package:menzy/utils/App-Colors.dart';
import 'package:menzy/utils/App-TextStyle.dart';

class NFTMarketScreen extends StatelessWidget {
  NFTMarketScreen({Key? key}) : super(key: key);

  TextEditingController searchC = TextEditingController();
  List<String> nftImages = [
    'assets/images/nft_image_1.jpeg',
    'assets/images/nft_image_2.jpeg',
    'assets/images/nft_image_3.jpeg',
    'assets/images/nft_image_1.jpeg',
    'assets/images/nft_image_2.jpeg',
  ];
  List<String> catImages = [
    'assets/images/nft_image_3.jpeg',
    'assets/images/nft_image6.png',
    'assets/images/nft_image_2.jpeg',
  ];
  List<String> nftNames = [
    'Menzy Dumbels',
    'Menzy Sneakers',
    'Menzy Coins',
  ];
  List<String> userImages = [
    'assets/images/female_profile.png',
    'assets/images/male_profile.png',
    'assets/images/female_profile.png',
  ];
  List<String> userNames = [
    'Sophia',
    'Richard',
    'Anna Delvi',
  ];
  List<String> catNames = [
    'Menzy Dumbels',
    'Menzy Sneakers',
    'Menzy Coins',
  ];
  List<double> bidCounts = [
    3.421,
    2.110,
    4.987,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Container(
              margin: EdgeInsets.only(top: 32),
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.to(() => StatisticTabBar()),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 40,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/eth_icon.png',
                        width: 13,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Balance',
                            style: AppTextStyle.regularWhite8,
                          ),
                          Text(
                            '3.421',
                            style: AppTextStyle.boldWhite22,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Search Bar
            Container(
              height: 50,
              width: Get.width,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(color: AppColors.blueDark, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(15),
                    child: Image.asset(
                      'assets/images/search_icon.png',
                      color: AppColors.hintColor,
                    ),
                  ),
                  Expanded(
                    child: AppTextField(
                      controller: searchC,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 18),
                      borderRadius: 6,
                      showBorder: false,
                      bgColor: Colors.transparent,
                      hint: 'Search',
                      hintStyle: AppTextStyle.mediumLightGrey14,
                      textStyle: AppTextStyle.boldWhite12,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            // Trending NFT's
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    'Trending NFT\'s',
                    style: AppTextStyle.boldWhite22,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    FontAwesomeIcons.fireFlameCurved,
                    color: Colors.yellow.shade700,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 275,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemExtent: 250,
                itemBuilder: (context, index) {
                  return TrendingNFTCard(
                    nftImage: nftImages[index],
                    nftName: nftNames[index],
                    userImage: userImages[index],
                    userName: userNames[index],
                    bidAmount: bidCounts[index],
                    onWalletTap: () {},
                  );
                },
              ),
            ),
            SizedBox(
              height: 25,
            ),
            // Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Category',
                style: AppTextStyle.boldWhite18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    height: 150,
                    width: 120,
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.only(right: 6, left: 6),
                    padding: EdgeInsets.only(left: 6, bottom: 0, top: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(
                          catImages[index],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text(
                      catNames[index],
                      style: AppTextStyle.boldWhite10,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 25,
            ),
            // Hot Collections
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Hot Collections',
                style: AppTextStyle.boldWhite18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return HotCollectionCard(
                      mainImage: catImages[index], userName: userNames[index], userImage: userImages[index]);
                },
              ),
            ),

            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
