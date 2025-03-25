import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextThemes {
  AppTextThemes._();

  static const List<String> availableFonts = [
    'Roboto',
    'Lato',
    'Montserrat',
    'OpenSans',
    'Poppins',
    'Raleway',
    'Ubuntu',
    'PlayfairDisplay',
    'SourceSansPro',
    'Oswald',
    'Merriweather',
    'Nunito',
    'QuickSand',
    'Urbanist',
  ];

  // Generate TextTheme with a specific Google Font
  static TextTheme getTheme(String fontFamily) {
    TextTheme Function(TextTheme) textTheme;

    switch (fontFamily.toLowerCase()) {
      case 'roboto':
        textTheme = GoogleFonts.robotoTextTheme;
        break;
      case 'lato':
        textTheme = GoogleFonts.latoTextTheme;
        break;
      case 'montserrat':
        textTheme = GoogleFonts.montserratTextTheme;
        break;
      case 'opensans':
        textTheme = GoogleFonts.openSansTextTheme;
        break;
      case 'poppins':
        textTheme = GoogleFonts.poppinsTextTheme;
        break;
      case 'raleway':
        textTheme = GoogleFonts.ralewayTextTheme;
        break;
      case 'ubuntu':
        textTheme = GoogleFonts.ubuntuTextTheme;
        break;
      case 'playfairdisplay':
        textTheme = GoogleFonts.playfairDisplayTextTheme;
        break;
      case 'sourcesanspro':
        textTheme = GoogleFonts.sourceCodeProTextTheme;
        break;
      case 'oswald':
        textTheme = GoogleFonts.oswaldTextTheme;
        break;
      case 'merriweather':
        textTheme = GoogleFonts.merriweatherTextTheme;
        break;
      case 'nunito':
        textTheme = GoogleFonts.nunitoTextTheme;
        break;
      case 'quicksand':
        textTheme = GoogleFonts.quicksandTextTheme;
        break;
      case 'urbanist':
        textTheme = GoogleFonts.urbanistTextTheme;
        break;
      default:
        textTheme = GoogleFonts.robotoTextTheme;
    }

    return _applyResponsiveSizing(textTheme(ThemeData.light().textTheme));
  }

  // Apply ScreenUtil sizing to text theme
  static TextTheme _applyResponsiveSizing(TextTheme textTheme) {
    return textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(fontSize: 32.sp),
      displayMedium: textTheme.displayMedium?.copyWith(fontSize: 28.sp),
      displaySmall: textTheme.displaySmall?.copyWith(fontSize: 24.sp),
      headlineLarge: textTheme.headlineLarge?.copyWith(fontSize: 22.sp),
      headlineMedium: textTheme.headlineMedium?.copyWith(fontSize: 20.sp),
      headlineSmall: textTheme.headlineSmall?.copyWith(fontSize: 18.sp),
      titleLarge: textTheme.titleLarge?.copyWith(fontSize: 16.sp),
      titleMedium: textTheme.titleMedium?.copyWith(fontSize: 14.sp),
      titleSmall: textTheme.titleSmall?.copyWith(fontSize: 12.sp),
      bodyLarge: textTheme.bodyLarge?.copyWith(fontSize: 16.sp),
      bodyMedium: textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
      bodySmall: textTheme.bodySmall?.copyWith(fontSize: 12.sp),
      labelLarge: textTheme.labelLarge?.copyWith(fontSize: 16.sp),
      labelMedium: textTheme.labelMedium?.copyWith(fontSize: 14.sp),
      labelSmall: textTheme.labelSmall?.copyWith(fontSize: 12.sp),
    );
  }

  static TextStyle heading1({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 32.sp,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
      height: 1.2,
      letterSpacing: -0.5.sp,
    );
  }

  static TextStyle heading2({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 28.sp,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
      height: 1.2,
      letterSpacing: -0.5.sp,
    );
  }

  static TextStyle heading3({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 24.sp,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
      height: 1.3,
    );
  }

  static TextStyle heading4({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 20.sp,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
      height: 1.3,
    );
  }

  static TextStyle heading5({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 18.sp,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
      height: 1.4,
    );
  }

  static TextStyle heading6({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
      height: 1.4,
    );
  }

  static TextStyle bodyLarge({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      height: 1.5,
    );
  }

  static TextStyle bodyMedium({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      height: 1.5,
    );
  }

  static TextStyle bodySmall({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      height: 1.5,
    );
  }

  static TextStyle caption({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 11.sp,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.grey,
      height: 1.4,
    );
  }

  static TextStyle button({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
      height: 1.2,
      letterSpacing: 0.5.sp,
    );
  }
}
