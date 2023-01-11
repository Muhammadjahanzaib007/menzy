import 'package:flutter/material.dart';

class LogoButton extends StatelessWidget {
  final Color bgColor;
  final Color overlayColor;
  final String text;
  final Function onPressed;
  final double? width;
  final EdgeInsets? margin;
  final Color textColor;
  final double elevation;
  final Color borderSideColor;
  final TextStyle textStyle;
  final Widget? leading;
  final double height;
  final double? radius;

  LogoButton(
      {required this.bgColor,
        required this.text,
        required this.height,
        required this.onPressed,
        this.width,
        this.margin,
        required this.textColor,
        required this.borderSideColor,
        required this.overlayColor,
        this.elevation = 0,
        this.leading,
        this.radius,
        required this.textStyle,});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constr) {
      return Container(
          margin: margin,
          width: width,
          height: height,
          child: ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(elevation),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(bgColor),
                overlayColor: MaterialStateProperty.all<Color>(overlayColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius ?? 14),
                    side: BorderSide(color: borderSideColor),
                  ),
                ),
              ),
              onPressed: () {
                onPressed();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                ],
              )));
    });
  }
}
