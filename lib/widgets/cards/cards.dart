import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';

enum CardType { standard, elevated, outlined, minimal }

class AppCard extends StatelessWidget {
  final Widget child;
  final CardType type;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final VoidCallback? onTap;
  final bool hasShadow;

  const AppCard({
    Key? key,
    required this.child,
    this.type = CardType.standard,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.margin,
    this.elevation,
    this.onTap,
    this.hasShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final background = backgroundColor ?? _getDefaultBackgroundColor(context);
    final border = _getBorder(context);
    final radius = borderRadius ?? BorderRadius.circular(12.r);
    final defaultPadding = padding ?? EdgeInsets.all(16.w);
    final defaultElevation = elevation ?? _getDefaultElevation();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: background,
          borderRadius: radius,
          border: border,
          boxShadow:
              hasShadow && type != CardType.outlined && type != CardType.minimal
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: defaultElevation * 2,
                        spreadRadius: defaultElevation / 2,
                        offset: Offset(0, defaultElevation / 2),
                      ),
                    ]
                  : null,
        ),
        child: Padding(
          padding: defaultPadding,
          child: child,
        ),
      ),
    );
  }

  Color _getDefaultBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type) {
      case CardType.standard:
      case CardType.elevated:
        return isDark ? AppColors.darkSurface : Colors.white;
      case CardType.outlined:
      case CardType.minimal:
        return Colors.transparent;
    }
  }

  Border? _getBorder(BuildContext context) {
    switch (type) {
      case CardType.outlined:
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final defaultBorderColor = borderColor ??
            (isDark ? AppColors.darkBorder : AppColors.lightBorder);
        final defaultBorderWidth = borderWidth ?? 1.0;
        return Border.all(color: defaultBorderColor, width: defaultBorderWidth);
      case CardType.standard:
      case CardType.elevated:
      case CardType.minimal:
        return null;
    }
  }

  double _getDefaultElevation() {
    switch (type) {
      case CardType.standard:
        return 1.0;
      case CardType.elevated:
        return 4.0;
      case CardType.outlined:
      case CardType.minimal:
        return 0.0;
    }
  }
}
