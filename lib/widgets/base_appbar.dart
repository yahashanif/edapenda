import 'package:flutter/material.dart';

import '../app/constant.dart';
import '../themes/themes.dart';

class BaseAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actionWidget;
  final PreferredSizeWidget? bottom;

  final bool centerTitle;
  final Color backgroundColor;
  final double elevation;
  final double toolheight;
  final Color textColor;

  const BaseAppbar(
      {super.key,
      required this.title,
      this.actionWidget,
      this.bottom,
      this.centerTitle = true,
      this.elevation = 1,
      this.toolheight = 1.0,
      this.textColor = Colors.black,
      this.backgroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // forceMaterialTransparency: true,
      surfaceTintColor: backgroundColor,
      scrolledUnderElevation: elevation,
      iconTheme: const IconThemeData(
        color: Colors.white, // Warna default button back
      ),

      shadowColor: Colors.grey.shade300,
      centerTitle: centerTitle,

      title: Text(
        title,
        style: tahomaR.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: getActualY(y: 20, context: context),
          color: Colors.white,
        ),
      ),
      actions: actionWidget,
      elevation: elevation,
      foregroundColor: textColor,
      toolbarHeight: getActualY(context: context, y: 100),
      backgroundColor: backgroundColor,
      bottom: bottom,
    );
  }

  @override
  // ignore: todo
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(
      bottom == null ? kToolbarHeight : toolheight * kToolbarHeight);
}
