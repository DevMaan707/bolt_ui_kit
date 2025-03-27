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
    final isDisabled = onPressed == null;
    final buttonStyle = _getButtonStyle(context);
    final buttonSize = _getButtonSize();
    final buttonContent = _buildContent(context);

    return SizedBox(
      width: width,
      height: height ?? buttonSize,
      child: _buildButton(buttonStyle, buttonContent, isDisabled),
    );
  }

  Widget _buildButton(
    ButtonStyle buttonStyle,
    Widget buttonContent,
    bool isDisabled,
  ) {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.custom:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonContent,
        );

      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonContent,
        );

      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonContent,
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
      return Center(
        child: SizedBox(
          height: 20.h,
          width: 20.h,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor()),
          ),
        ),
      );
    }

    if (customChild != null) {
      return customChild!;
    }

    final btnPadding = padding ?? _getDefaultPadding();

    if (icon == null) {
      return Padding(
        padding: btnPadding,
        child: Text(
          text,
          style: _getTextStyle(context),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      );
    }

    return Padding(
      padding: btnPadding,
      child: Row(
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
          Flexible(
            child: Text(
              text,
              style: _getTextStyle(context),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
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
      ),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final borderRad = borderRadius ?? BorderRadius.circular(8.r);

    // Base styles with appropriate padding
    ButtonStyle baseStyle = ButtonStyle(
      padding: WidgetStateProperty.all(
          EdgeInsets.zero), // Remove default button padding
      minimumSize: WidgetStateProperty.all(Size(0, _getButtonSize())),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    switch (type) {
      case ButtonType.primary:
        return baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return (backgroundColor ?? AppColors.primary).withOpacity(0.6);
            }
            return backgroundColor ?? AppColors.primary;
          }),
          foregroundColor: WidgetStateProperty.all(textColor ?? Colors.white),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: borderRad,
          )),
          elevation: WidgetStateProperty.all(1),
        );

      case ButtonType.secondary:
        final secondaryColor = AppColors.accent;
        return baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return (backgroundColor ?? secondaryColor).withOpacity(0.6);
            }
            return backgroundColor ?? secondaryColor;
          }),
          foregroundColor: WidgetStateProperty.all(textColor ?? Colors.white),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: borderRad,
          )),
          elevation: WidgetStateProperty.all(1),
        );

      case ButtonType.outlined:
        final outlineColor = backgroundColor ?? AppColors.primary;
        return baseStyle.copyWith(
          foregroundColor: WidgetStateProperty.all(textColor ?? outlineColor),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: borderRad,
          )),
          side: WidgetStateProperty.all(BorderSide(color: outlineColor)),
        );

      case ButtonType.text:
        return baseStyle.copyWith(
          foregroundColor:
              WidgetStateProperty.all(textColor ?? AppColors.primary),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: borderRad,
          )),
        );

      case ButtonType.custom:
        return baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(backgroundColor),
          foregroundColor: WidgetStateProperty.all(textColor),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: borderRad,
          )),
          elevation: WidgetStateProperty.all(1),
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
        return 16.sp;
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
        ? 13.sp
        : (size == ButtonSize.large ? 16.sp : 14.sp);

    return TextStyle(
      fontSize: defaultSize,
      fontWeight: FontWeight.w600,
      color: _getTextColor(context),
      height: 1.2, // Improve vertical alignment
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
