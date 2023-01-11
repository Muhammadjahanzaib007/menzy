import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:menzy/Models/nftdata.dart';
import 'package:menzy/utils/App-TextStyle.dart';

class OWNNFTCard extends StatelessWidget {
  const OWNNFTCard({
    Key? key,
    required this.nftdata,
  }) : super(key: key);
  final NFTData nftdata;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: 240,
      height: 275,
      padding: EdgeInsets.only(top: 6, bottom: 6, left: 5, right: 6),
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
                  // height: 100,
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
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         "Description : ",
              //         style: AppTextStyle.boldWhite18,
              //       ),
              //       Expanded(
              //         child: Container(
              //           width: 90,
              //           child: Text(
              //             nftdata.description ?? "N/A",
              //             overflow: TextOverflow.ellipsis,
              //             style: AppTextStyle.boldWhite14,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
// Image.network(nftdata.metadata!['image'].toString().replaceFirst("ipfs://", "https://ipfs.io/ipfs/"),height: 50,width: 50,),