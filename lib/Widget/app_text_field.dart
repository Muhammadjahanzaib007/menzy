import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField(
      {Key? key,
      required this.hint,
      required this.hintStyle,
      required this.textStyle,
      this.controller,
      this.contentPadding,
      this.onChange,
      this.onSaved,
      this.validator,
      this.keyboardType,
      this.obsecure,
      this.suffixIcon,
      this.borderRadius,
      this.showBorder,
      this.bgColor,
      this.leadingIcon})
      : super(key: key);

  final String hint;
  final EdgeInsets? contentPadding;
  final TextStyle hintStyle;
  final TextStyle textStyle;
  final bool? showBorder;
  final Color? bgColor;
  final TextEditingController? controller;
  final Function(String?)? onChange;
  final Function(String?)? onSaved;
  final String Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? obsecure;
  final double? borderRadius;
  final Widget? suffixIcon;
  final Widget? leadingIcon;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.bgColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
      ),
      child: TextFormField(
        keyboardType: widget.keyboardType ?? TextInputType.text,
        controller: widget.controller,
        onSaved: widget.onSaved ?? (input) {},
        onChanged: widget.onChange ?? (input) {},
        validator: widget.validator ?? (input) {
          return null;
        },
        style: widget.textStyle,
        obscureText: widget.obsecure ?? false,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        cursorHeight: 16,
        decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: widget.hintStyle,
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red)),
            // prefixIcon: widget.prefixIconData != null
            //     ? Icon(widget.prefixIconData, color: Get.theme.focusColor).marginOnly(right: 0)
            //     : Container(),
            // prefixIconConstraints: widget.prefixIconData != null
            //     ? BoxConstraints.expand(width: 38, height: 38)
            //     : BoxConstraints.expand(width: 16, height: 0),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            border: OutlineInputBorder(
                borderSide: (widget.showBorder == false)
                    ? BorderSide.none
                    : BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.all(
                    Radius.circular(widget.borderRadius ?? 16))),
            focusedBorder: OutlineInputBorder(
                borderSide: (widget.showBorder == false)
                    ? BorderSide.none
                    : BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.all(
                    Radius.circular(widget.borderRadius ?? 16))),
            enabledBorder: OutlineInputBorder(
                borderSide: (widget.showBorder == false)
                    ? BorderSide.none
                    : BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.all(
                    Radius.circular(widget.borderRadius ?? 16))),
            prefix: widget.leadingIcon
            // suffixIcon: widget.suffixIcon ??
            //     Container(
            //       width: 0,
            //     ),
            ),
      ),
    );
  }
}
