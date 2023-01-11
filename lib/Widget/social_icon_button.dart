import 'package:flutter/material.dart';
import 'package:menzy/utils/App-Colors.dart';

class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    Key? key,
    this.height,
    this.width,
    this.onTap,
    required this.image,
  }) : super(key: key);
  final double? height;
  final double? width;
  final String image;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 32,
        width: width ?? 32,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Image.asset(image),
      ),
    );
  }
}