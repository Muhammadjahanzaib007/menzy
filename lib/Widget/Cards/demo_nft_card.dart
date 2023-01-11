import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:menzy/Models/nftdata.dart';
import 'package:menzy/utils/App-TextStyle.dart';

class DemoNFTCard extends StatelessWidget {
  const DemoNFTCard({
    Key? key,
    required this.nftdata,
    required this.onWalletTap,
  }) : super(key: key);
  final NFTData nftdata;
  final Function() onWalletTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: 240,
      height: 275,
      // padding: EdgeInsets.only(top: 6, bottom: 6, left: 5, right: 6),
      margin: EdgeInsets.only(right: 6, left: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: Color(0xff393A3E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: CachedNetworkImage(
                  height: 100,
                  width: 200,
                  imageUrl: nftdata.imgPath ?? "",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                child: Text(
                  (nftdata.name ?? "N/A").toUpperCase(),
                  style: AppTextStyle.boldWhite12,
                ),
              ),
              Card(
                color: Color(0xff393A3E),
                elevation: 0.1,
                child: GestureDetector(
                  onTap: onWalletTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            width: 90,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                "Buy Now",
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.mediumLightGrey10,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Price  ',
                                style: AppTextStyle.regularWhite10,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Text(
                                  nftdata.price.toString(),
                                  style: AppTextStyle.boldWhite14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Positioned(
          //   right: 5,
          //   top: 164,
          //   child: GestureDetector(
          //     onTap: onWalletTap,
          //     child: Container(
          //       height: 40,
          //       width: 80,
          //       padding: EdgeInsets.all(5),
          //       decoration: BoxDecoration(
          //         color: AppColors.lightPrimary,
          //         // gradient: AppColors.primaryHorizontalGradient,
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       child: Center(
          //           child: Text(
          //         "Buy now",
          //         style: AppTextStyle.mediumWhite10,
          //       )),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
