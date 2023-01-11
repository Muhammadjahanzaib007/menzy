import 'package:flutter/material.dart';
import 'package:menzy/Utils/App-Colors.dart';
import 'package:menzy/Utils/App-TextStyle.dart';

class HotCollectionCard extends StatelessWidget {
  HotCollectionCard({
    Key? key,
    required this.mainImage,
    required this.userName,
    required this.userImage,
  }) : super(key: key);

  final String mainImage;
  final String userName;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: 200,
      height: 190,
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
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.blueDark,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(mainImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 24),
                child: Text(
                  userName,
                  style: AppTextStyle.boldWhite14,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'by ',
                    style: AppTextStyle.regularWhite10,
                  ),
                  Text(
                    'Lores Doud',
                    style: AppTextStyle.regularWhite10,
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 80,
            left: 75,
            child: Stack(
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
          ),
        ],
      ),
    );
  }
}
