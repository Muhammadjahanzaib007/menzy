import 'package:flutter/material.dart';
import 'package:menzy/utils/App-Colors.dart';

class AppButton extends StatelessWidget {
  final Color? bgColor;
  final LinearGradient? gradient;
  final Color overlayColor;
  final String text;
  final Function onPressed;
  final double? width;
  final EdgeInsets? margin;
  final Color textColor;
  final double elevation;
  final Color? borderSideColor;
  final TextStyle textStyle;
  final Widget? leading;
  final Widget? trailing;
  final double height;
  final double? radius;
  final bool? tostart;
  final bool? is3d;

  AppButton(
      {this.bgColor,
      this.gradient,
      required this.text,
      required this.height,
      required this.onPressed,
      this.width,
      this.margin,
      required this.textColor,
       this.borderSideColor,
      required this.overlayColor,
      this.elevation = 0,
      this.leading,
      this.radius,
      required this.textStyle,
      this.tostart,
      this.trailing,
      this.is3d});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constr) {
        return Container(
          margin: margin,
          width: width,
          height: height,
          decoration: is3d == null
              ? BoxDecoration(
                  // gradient: gradient ?? AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                    ),
                    BoxShadow(
                      color: bgColor ?? AppColors.primary,
                      spreadRadius: -2.0,
                      blurRadius: 6.0,
                      offset: Offset(1.5, 1.5),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(radius ?? 100),
                  border: Border.all(color:borderSideColor?? AppColors.lightPrimary, width: 3),
                )
              : BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(radius ?? 100),
                ),
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(elevation),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              overlayColor: MaterialStateProperty.all<Color>(overlayColor),

              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius ?? 100),
                  side:BorderSide.none
                ),
              ),
            ),
            onPressed: () {
              onPressed();
            },
            child: Row(
              mainAxisAlignment: tostart != null && tostart!
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: leading,
                ),
                SizedBox(
                  // width: constr.maxWidth * 0.52,
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: trailing,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
