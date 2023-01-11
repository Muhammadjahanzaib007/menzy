import 'package:flutter/material.dart';
import 'package:menzy/utils/App-Colors.dart';
import 'package:menzy/utils/App-TextStyle.dart';

class TrendingNFTCard extends StatelessWidget {
  const TrendingNFTCard({
    Key? key,
    required this.nftImage,
    required this.nftName,
    required this.userImage,
    required this.userName,
    required this.bidAmount,
    required this.onWalletTap,
  }) : super(key: key);
  final String nftImage;
  final String nftName;
  final String userImage;
  final String userName;
  final double bidAmount;
  final Function() onWalletTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: 240,
      height: 275,
      padding: EdgeInsets.only(top: 6, bottom: 6, left: 5, right: 6),
      margin: EdgeInsets.only(right: 6, left: 6),
      decoration: BoxDecoration(
        color: AppColors.blueDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 165,
                decoration: BoxDecoration(
                  color: AppColors.blueDark,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(nftImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                child: Text(
                  nftName,
                  style: AppTextStyle.boldWhite14,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(image: AssetImage(userImage), fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.blue.shade700,
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 7,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          width: 90,
                          child: Text(
                            userName,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.boldWhite14,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Current Bid',
                          style: AppTextStyle.regularWhite10,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/eth_icon.png',
                              width: 10,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              bidAmount.toString(),
                              style: AppTextStyle.boldWhite14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 5,
            top: 130,
            child: GestureDetector(
              onTap: onWalletTap,
              child: Container(
                height: 70,
                width: 70,
                padding: EdgeInsets.all(23),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary,
                  // gradient: AppColors.primaryHorizontalGradient,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Image.asset(
                  'assets/images/wallet_icon.png',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
