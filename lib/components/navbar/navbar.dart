import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';

enum NavbarStyle {
  standard,
  transparent,
  elevated,
  simple,
  custom,
}

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final NavbarStyle style;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? titleColor;
  final double? elevation;
  final Widget? flexibleSpace;
  final TextStyle? titleStyle;
  final bool centerTitle;
  final double? titleSpacing;
  final double height;
  final Widget? bottom;

  const Navbar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.style = NavbarStyle.standard,
    this.backgroundColor,
    this.iconColor,
    this.titleColor,
    this.elevation,
    this.flexibleSpace,
    this.titleStyle,
    this.centerTitle = true,
    this.titleSpacing,
    this.height = kToolbarHeight,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _getBackgroundColor();
    final double elevationValue = _getElevation();
    final Color textColor = titleColor ?? _getTextColor();
    final Color iconColorValue = iconColor ?? textColor;

    return AppBar(
      title: Text(
        title,
        style: titleStyle ??
            TextStyle(
              color: textColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
      ),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
      backgroundColor: bgColor,
      elevation: elevationValue,
      flexibleSpace: flexibleSpace,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      iconTheme: IconThemeData(color: iconColorValue),
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(56.h),
              child: bottom!,
            )
          : null,
    );
  }

  Color _getBackgroundColor() {
    switch (style) {
      case NavbarStyle.standard:
        return backgroundColor ?? AppColors.primary;
      case NavbarStyle.transparent:
        return backgroundColor ?? Colors.transparent;
      case NavbarStyle.elevated:
        return backgroundColor ?? Colors.white;
      case NavbarStyle.simple:
        return backgroundColor ?? Colors.white;
      case NavbarStyle.custom:
        return backgroundColor ?? AppColors.primary;
    }
  }

  double _getElevation() {
    if (elevation != null) return elevation!;

    switch (style) {
      case NavbarStyle.standard:
        return 4.0;
      case NavbarStyle.transparent:
        return 0.0;
      case NavbarStyle.elevated:
        return 8.0;
      case NavbarStyle.simple:
        return 0.5;
      case NavbarStyle.custom:
        return 0.0;
    }
  }

  Color _getTextColor() {
    switch (style) {
      case NavbarStyle.standard:
        return Colors.white;
      case NavbarStyle.transparent:
        return Colors.black;
      case NavbarStyle.elevated:
        return Colors.black;
      case NavbarStyle.simple:
        return Colors.black;
      case NavbarStyle.custom:
        return Colors.white;
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
