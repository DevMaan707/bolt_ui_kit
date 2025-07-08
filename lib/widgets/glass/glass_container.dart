import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';

enum GlassShape { rectangle, roundedRectangle, circle, custom }

enum GlassType {
  frosted, // Classic frosted glass
  crystal, // More transparent with subtle tint
  smoky, // Darker with more opacity
  vibrant, // Higher saturation
  minimal, // Very subtle effect
  custom // Full customization
}

class GlassContainer extends StatelessWidget {
  /// Child widget to be displayed inside the glass container
  final Widget? child;

  /// Width of the container
  final double? width;

  /// Height of the container
  final double? height;

  /// Padding inside the container
  final EdgeInsetsGeometry? padding;

  /// Margin around the container
  final EdgeInsetsGeometry? margin;

  /// Alignment of the child widget
  final AlignmentGeometry? alignment;

  /// Glass effect type (predefined styles)
  final GlassType type;

  /// Shape of the glass container
  final GlassShape shape;

  /// Border radius (for rounded shapes)
  final BorderRadius? borderRadius;

  /// Custom border radius value (shortcut for all corners)
  final double? radius;

  /// Background color (will be applied with opacity)
  final Color? backgroundColor;

  /// Background opacity (0.0 to 1.0)
  final double backgroundOpacity;

  /// Blur intensity (higher = more blur)
  final double blurIntensity;

  /// Border configuration
  final Border? border;

  /// Border color
  final Color? borderColor;

  /// Border width
  final double borderWidth;

  /// Border opacity
  final double borderOpacity;

  /// Shadow configuration
  final List<BoxShadow>? boxShadow;

  /// Whether to add default shadow
  final bool addShadow;

  /// Shadow color
  final Color? shadowColor;

  /// Shadow blur radius
  final double shadowBlurRadius;

  /// Shadow spread radius
  final double shadowSpreadRadius;

  /// Shadow offset
  final Offset shadowOffset;

  /// Gradient overlay (applied over background color)
  final Gradient? gradient;

  /// Gradient opacity
  final double gradientOpacity;

  /// Clip behavior
  final Clip clipBehavior;

  /// Transform matrix
  final Matrix4? transform;

  /// Transform alignment
  final AlignmentGeometry? transformAlignment;

  /// Tap callback
  final VoidCallback? onTap;

  /// Long press callback
  final VoidCallback? onLongPress;

  /// Double tap callback
  final VoidCallback? onDoubleTap;

  const GlassContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.alignment,
    this.type = GlassType.frosted,
    this.shape = GlassShape.roundedRectangle,
    this.borderRadius,
    this.radius,
    this.backgroundColor,
    this.backgroundOpacity = 0.2,
    this.blurIntensity = 10.0,
    this.border,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderOpacity = 0.2,
    this.boxShadow,
    this.addShadow = true,
    this.shadowColor,
    this.shadowBlurRadius = 20.0,
    this.shadowSpreadRadius = 0.0,
    this.shadowOffset = const Offset(0, 8),
    this.gradient,
    this.gradientOpacity = 0.1,
    this.clipBehavior = Clip.antiAlias,
    this.transform,
    this.transformAlignment,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
  });

  // Convenience constructors as static methods
  static GlassContainer card({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    GlassType type = GlassType.frosted,
  }) {
    return GlassContainer(
      key: key,
      padding: padding ?? EdgeInsets.all(16.w),
      margin: margin,
      onTap: onTap,
      type: type,
      shape: GlassShape.roundedRectangle,
      radius: 16.r,
      child: child,
    );
  }

  static GlassContainer button({
    Key? key,
    required Widget child,
    required VoidCallback onTap,
    EdgeInsetsGeometry? padding,
    GlassType type = GlassType.crystal,
  }) {
    return GlassContainer(
      key: key,
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      onTap: onTap,
      type: type,
      shape: GlassShape.roundedRectangle,
      radius: 8.r,
      addShadow: false,
      child: child,
    );
  }

  static GlassContainer dialog({
    Key? key,
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    GlassType type = GlassType.frosted,
  }) {
    return GlassContainer(
      key: key,
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(24.w),
      type: type,
      shape: GlassShape.roundedRectangle,
      radius: 20.r,
      shadowBlurRadius: 40.0,
      shadowSpreadRadius: 0.0,
      shadowOffset: const Offset(0, 20),
      child: child,
    );
  }

  static GlassContainer overlay({
    Key? key,
    required Widget child,
    GlassType type = GlassType.smoky,
    VoidCallback? onTap,
  }) {
    return GlassContainer(
      key: key,
      width: double.infinity,
      height: double.infinity,
      type: type,
      shape: GlassShape.rectangle,
      addShadow: false,
      onTap: onTap,
      child: child,
    );
  }

  static GlassContainer appBar({
    Key? key,
    required Widget child,
    double? height,
    GlassType type = GlassType.crystal,
  }) {
    return GlassContainer(
      key: key,
      width: double.infinity,
      height: height ?? 80.h,
      type: type,
      shape: GlassShape.rectangle,
      borderWidth: 0,
      addShadow: false,
      child: child,
    );
  }

  static GlassContainer bottomSheet({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    GlassType type = GlassType.frosted,
  }) {
    return GlassContainer(
      key: key,
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(24.w),
      type: type,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.r),
        topRight: Radius.circular(24.r),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get glass properties based on type
    final glassProperties = _getGlassProperties(isDark);

    // Build border radius
    final effectiveBorderRadius = _buildBorderRadius();

    // Build decoration
    final decoration = _buildDecoration(glassProperties, effectiveBorderRadius);

    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      decoration: decoration,
      child: ClipRRect(
        borderRadius: effectiveBorderRadius ?? BorderRadius.zero,
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: glassProperties.blur,
            sigmaY: glassProperties.blur,
          ),
          child: Container(
            padding: padding,
            alignment: alignment,
            decoration: BoxDecoration(
              color: glassProperties.overlayColor,
              gradient: gradient != null
                  ? _applyGradientOpacity(gradient!, gradientOpacity)
                  : null,
              borderRadius: effectiveBorderRadius,
            ),
            child: child,
          ),
        ),
      ),
    );

    // Add gesture detection if needed
    if (onTap != null || onLongPress != null || onDoubleTap != null) {
      container = GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
        child: container,
      );
    }

    return container;
  }

  BorderRadius? _buildBorderRadius() {
    switch (shape) {
      case GlassShape.rectangle:
        return null;
      case GlassShape.roundedRectangle:
        if (borderRadius != null) return borderRadius;
        return BorderRadius.circular(radius ?? 12.r);
      case GlassShape.circle:
        final size = width ?? height ?? 100.w;
        return BorderRadius.circular(size / 2);
      case GlassShape.custom:
        return borderRadius;
    }
  }

  BoxDecoration _buildDecoration(
      GlassProperties props, BorderRadius? borderRadius) {
    return BoxDecoration(
      color: props.backgroundColor,
      borderRadius: borderRadius,
      border: border ?? _buildDefaultBorder(props),
      boxShadow: boxShadow ?? (addShadow ? _buildDefaultShadow() : null),
    );
  }

  Border? _buildDefaultBorder(GlassProperties props) {
    if (borderWidth <= 0) return null;

    final effectiveBorderColor = borderColor ?? props.borderColor;
    return Border.all(
      color: effectiveBorderColor.withOpacity(borderOpacity),
      width: borderWidth,
    );
  }

  List<BoxShadow> _buildDefaultShadow() {
    final effectiveShadowColor = shadowColor ?? Colors.black;
    return [
      BoxShadow(
        color: effectiveShadowColor.withOpacity(0.1),
        blurRadius: shadowBlurRadius,
        spreadRadius: shadowSpreadRadius,
        offset: shadowOffset,
      ),
    ];
  }

  Gradient _applyGradientOpacity(Gradient gradient, double opacity) {
    if (gradient is LinearGradient) {
      return LinearGradient(
        begin: gradient.begin,
        end: gradient.end,
        colors:
            gradient.colors.map((color) => color.withOpacity(opacity)).toList(),
        stops: gradient.stops,
        transform: gradient.transform,
        tileMode: gradient.tileMode,
      );
    } else if (gradient is RadialGradient) {
      return RadialGradient(
        center: gradient.center,
        radius: gradient.radius,
        colors:
            gradient.colors.map((color) => color.withOpacity(opacity)).toList(),
        stops: gradient.stops,
        transform: gradient.transform,
        tileMode: gradient.tileMode,
        focal: gradient.focal,
        focalRadius: gradient.focalRadius,
      );
    } else if (gradient is SweepGradient) {
      return SweepGradient(
        center: gradient.center,
        startAngle: gradient.startAngle,
        endAngle: gradient.endAngle,
        colors:
            gradient.colors.map((color) => color.withOpacity(opacity)).toList(),
        stops: gradient.stops,
        transform: gradient.transform,
        tileMode: gradient.tileMode,
      );
    }
    return gradient;
  }

  GlassProperties _getGlassProperties(bool isDark) {
    switch (type) {
      case GlassType.frosted:
        return GlassProperties(
          backgroundColor: backgroundColor ??
              (isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.25)),
          overlayColor: backgroundColor?.withOpacity(backgroundOpacity) ??
              (isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.15)),
          borderColor: borderColor ?? (isDark ? Colors.white : Colors.white),
          blur: blurIntensity,
        );

      case GlassType.crystal:
        return GlassProperties(
          backgroundColor: backgroundColor ??
              (isDark
                  ? Colors.white.withOpacity(0.02)
                  : Colors.white.withOpacity(0.3)),
          overlayColor: backgroundColor?.withOpacity(backgroundOpacity * 0.5) ??
              (isDark
                  ? Colors.white.withOpacity(0.02)
                  : Colors.white.withOpacity(0.1)),
          borderColor:
              borderColor ?? (isDark ? Colors.white : AppColors.primary),
          blur: blurIntensity * 0.8,
        );

      case GlassType.smoky:
        return GlassProperties(
          backgroundColor: backgroundColor ??
              (isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2)),
          overlayColor: backgroundColor?.withOpacity(backgroundOpacity) ??
              (isDark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.15)),
          borderColor:
              borderColor ?? (isDark ? Colors.grey : Colors.grey.shade400),
          blur: blurIntensity * 1.2,
        );

      case GlassType.vibrant:
        return GlassProperties(
          backgroundColor: backgroundColor ??
              AppColors.primary.withOpacity(isDark ? 0.1 : 0.2),
          overlayColor: backgroundColor?.withOpacity(backgroundOpacity) ??
              AppColors.primary.withOpacity(isDark ? 0.05 : 0.1),
          borderColor: borderColor ?? AppColors.primary,
          blur: blurIntensity,
        );

      case GlassType.minimal:
        return GlassProperties(
          backgroundColor: backgroundColor ??
              (isDark
                  ? Colors.white.withOpacity(0.02)
                  : Colors.white.withOpacity(0.1)),
          overlayColor: backgroundColor?.withOpacity(backgroundOpacity * 0.5) ??
              (isDark
                  ? Colors.white.withOpacity(0.01)
                  : Colors.white.withOpacity(0.05)),
          borderColor:
              borderColor ?? (isDark ? Colors.white24 : Colors.black12),
          blur: blurIntensity * 0.5,
        );

      case GlassType.custom:
        return GlassProperties(
          backgroundColor: backgroundColor ?? Colors.transparent,
          overlayColor: backgroundColor?.withOpacity(backgroundOpacity) ??
              Colors.transparent,
          borderColor: borderColor ?? Colors.transparent,
          blur: blurIntensity,
        );
    }
  }
}

// Helper class to hold glass properties
class GlassProperties {
  final Color backgroundColor;
  final Color overlayColor;
  final Color borderColor;
  final double blur;

  const GlassProperties({
    required this.backgroundColor,
    required this.overlayColor,
    required this.borderColor,
    required this.blur,
  });
}
