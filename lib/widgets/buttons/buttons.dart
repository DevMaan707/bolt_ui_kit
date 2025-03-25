import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';

enum ButtonType { primary, secondary, outlined, text, custom }

enum ButtonSize { small, medium, large, custom }

class Button extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool iconRight;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final Widget? customChild;

  const Button({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.iconRight = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.isLoading = false,
    this.customChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If disabled, create a muted style
    final isDisabled = onPressed == null;
    final buttonStyle = _getButtonStyle(context);
    final buttonSize = _getButtonSize();
    final buttonPadding = padding ?? _getDefaultPadding();
    final buttonContent = _buildContent(context);

    return SizedBox(
      width: width,
      height: height ?? buttonSize,
      child:
          _buildButton(buttonStyle, buttonPadding, buttonContent, isDisabled),
    );
  }

  Widget _buildButton(
    ButtonStyle buttonStyle,
    EdgeInsetsGeometry buttonPadding,
    Widget buttonContent,
    bool isDisabled,
  ) {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.custom:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: Padding(
            padding: buttonPadding,
            child: buttonContent,
          ),
        );

      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: Padding(
            padding: buttonPadding,
            child: buttonContent,
          ),
        );

      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: Padding(
            padding: buttonPadding,
            child: buttonContent,
          ),
        );

      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonContent,
        );
    }
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20.h,
        width: 20.h,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor()),
        ),
      );
    }

    if (customChild != null) {
      return customChild!;
    }

    if (icon == null) {
      return Text(
        text,
        style: _getTextStyle(context),
        textAlign: TextAlign.center,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!iconRight) ...[
          Icon(
            icon,
            size: _getIconSize(),
            color: _getTextColor(context),
          ),
          SizedBox(width: 8.w),
        ],
        Text(
          text,
          style: _getTextStyle(context),
        ),
        if (iconRight) ...[
          SizedBox(width: 8.w),
          Icon(
            icon,
            size: _getIconSize(),
            color: _getTextColor(context),
          ),
        ],
      ],
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final borderRad = borderRadius ?? BorderRadius.circular(8.r);

    switch (type) {
      case ButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(borderRadius: borderRad),
          elevation: 1,
        );

      case ButtonType.secondary:
        final secondaryColor = AppColors.accent;
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? secondaryColor,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(borderRadius: borderRad),
          elevation: 1,
        );

      case ButtonType.outlined:
        final outlineColor = backgroundColor ?? AppColors.primary;
        return OutlinedButton.styleFrom(
          foregroundColor: textColor ?? outlineColor,
          shape: RoundedRectangleBorder(borderRadius: borderRad),
          side: BorderSide(color: outlineColor),
        );

      case ButtonType.text:
        return TextButton.styleFrom(
          foregroundColor: textColor ?? AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: borderRad),
        );

      case ButtonType.custom:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: borderRad),
          elevation: 1,
        );
    }
  }

  double _getButtonSize() {
    switch (size) {
      case ButtonSize.small:
        return 32.h;
      case ButtonSize.medium:
        return 42.h;
      case ButtonSize.large:
        return 52.h;
      case ButtonSize.custom:
        return height ?? 42.h;
    }
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    switch (size) {
      case ButtonSize.small:
        return EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h);
      case ButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
      case ButtonSize.large:
        return EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h);
      case ButtonSize.custom:
        return EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 14.sp;
      case ButtonSize.medium:
        return 18.sp;
      case ButtonSize.large:
        return 20.sp;
      case ButtonSize.custom:
        return 18.sp;
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    final defaultSize = size == ButtonSize.small
        ? 12.sp
        : (size == ButtonSize.large ? 16.sp : 14.sp);

    return TextStyle(
      fontSize: defaultSize,
      fontWeight: FontWeight.w600,
      color: _getTextColor(context),
    );
  }

  Color _getTextColor(BuildContext context) {
    if (textColor != null) return textColor!;

    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
        return Colors.white;
      case ButtonType.outlined:
      case ButtonType.text:
        return AppColors.primary;
      case ButtonType.custom:
        return textColor ?? Colors.white;
    }
  }

  Color _getProgressColor() {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.custom:
        return Colors.white;
      case ButtonType.outlined:
      case ButtonType.text:
        return AppColors.primary;
    }
  }
}
