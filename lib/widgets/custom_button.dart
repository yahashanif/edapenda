import 'package:dapenda/themes/themes.dart';
import 'package:flutter/material.dart';

import '../app/constant.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? buttonColor;
  final Color textColor;
  final Color borderColor;
  final double paddingVertical;
  final double width;
  final Function()? onPressed;
  final double fontTextSize;
  final double marginBottom;
  final double marginTop;
  final double marginLeft;
  final double marginRight;
  final FontWeight fontWeight;
  final bool isLoading;
  final String? iconUrl;
  final double sizeIcon;

  const CustomButton(
      {Key? key,
      required this.text,
      this.buttonColor = green,
      this.textColor = Colors.white,
      this.borderColor = green,
      this.width = double.maxFinite,
      required this.onPressed,
      this.fontTextSize = 15,
      this.marginBottom = 0,
      this.paddingVertical = 8,
      this.isLoading = false,
      this.marginTop = 0,
      this.marginLeft = 0,
      this.marginRight = 0,
      this.fontWeight = FontWeight.w500,
      this.iconUrl,
      this.sizeIcon = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.only(
          bottom: marginBottom,
          top: marginTop,
          right: marginRight,
          left: marginLeft),
      child: Center(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
                horizontal: getActualX(
                  context: context,
                  x: 12,
                ),
                vertical: getActualY(
                  context: context,
                  y: paddingVertical,
                )),
            backgroundColor:
                onPressed != null ? buttonColor : Colors.grey.shade300,
            disabledBackgroundColor: Colors.grey.shade300,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: onPressed != null
                  ? BorderSide(
                      color: borderColor,
                    )
                  : BorderSide.none,
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: isLoading
                ? Center(
                    child: SizedBox(
                    height: getActualY(y: 20, context: context),
                    width: getActualX(x: 20, context: context),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: tahomaR.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              getActualY(y: fontTextSize, context: context),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
