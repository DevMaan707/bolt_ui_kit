import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static late Color primary;
  static late Color accent;
  static late Color background;
  static late Color card;
  static late Color text;
  static late Color textLight;
  static late Color error;
  static late Color success;
  static late Color warning;
  static late Color info;

  static late Color lightBackground;
  static late Color lightSurface;
  static late Color lightBorder;

  // Dark theme specific colors
  static late Color darkBackground;
  static late Color darkSurface;
  static late Color darkBorder;

  // Initialize with custom colors
  static void initialize({
    required Color primary,
    required Color accent,
    Color? background,
    Color? card,
    Color? text,
    Color? textLight,
    Color? error,
    Color? success,
    Color? warning,
    Color? info,
  }) {
    AppColors.primary = primary;
    AppColors.accent = accent;
    AppColors.background = background ?? Colors.white;
    AppColors.card = card ?? Colors.white;
    AppColors.text = text ?? Colors.black87;
    AppColors.textLight = textLight ?? Colors.black54;
    AppColors.error = error ?? Colors.red.shade700;
    AppColors.success = success ?? Colors.green.shade700;
    AppColors.warning = warning ?? Colors.orange.shade700;
    AppColors.info = info ?? Colors.blue.shade700;

    // Set light theme colors
    AppColors.lightBackground = Colors.white;
    AppColors.lightSurface = Colors.grey.shade50;
    AppColors.lightBorder = Colors.grey.shade300;

    // Set dark theme colors
    AppColors.darkBackground = Colors.grey.shade900;
    AppColors.darkSurface = Colors.grey.shade800;
    AppColors.darkBorder = Colors.grey.shade700;
  }

  // Get color based on brightness
  static Color getByBrightness(
    Brightness brightness, {
    required Color light,
    required Color dark,
  }) {
    return brightness == Brightness.light ? light : dark;
  }

  // Generate different shades of the primary color
  static Map<int, Color> generatePrimaryShades() {
    final Map<int, Color> shades = {};
    final HSLColor hsl = HSLColor.fromColor(primary);

    // Generate lighter and darker shades
    for (int i = 1; i <= 9; i++) {
      double lightness = 0.95 - (i * 0.08);
      if (lightness < 0.1) lightness = 0.1;
      if (lightness > 0.95) lightness = 0.95;

      shades[i * 100] = HSLColor.fromAHSL(
        hsl.alpha,
        hsl.hue,
        hsl.saturation,
        lightness,
      ).toColor();
    }

    return shades;
  }
}
