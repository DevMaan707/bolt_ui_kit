import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../theme/text_themes.dart';

class DatePickerUtil {
  static Future<DateTime?> showCustomDatePicker({
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
    String? cancelText,
    String? confirmText,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    String? fieldHintText,
    String? fieldLabelText,
    Color? primaryColor,
    Color? textColor,
    Color? backgroundColor,
    Color? headerBackgroundColor,
    bool barrierDismissible = true,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= DateTime(1900);
    lastDate ??= DateTime(2100);
    primaryColor = AppColors.primary;
    backgroundColor ??= Colors.white;
    headerBackgroundColor ??= primaryColor;
    textColor ??= AppColors.text;

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      initialEntryMode: initialEntryMode,
      initialDatePickerMode: initialDatePickerMode,
      fieldHintText: fieldHintText,
      fieldLabelText: fieldLabelText,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor ?? AppColors.primary,
              onPrimary: Colors.white,
              onSurface: textColor ?? AppColors.text,
              surface: backgroundColor ?? Colors.white,
            ),
            dialogBackgroundColor: backgroundColor,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                textStyle: AppTextThemes.button(),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: backgroundColor,
              headerBackgroundColor: headerBackgroundColor,
              headerForegroundColor: Colors.white,
              surfaceTintColor: backgroundColor,
              dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return primaryColor;
                }
                return null;
              }),
              todayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return primaryColor;
                }
                return (primaryColor ?? AppColors.primary).withOpacity(0.2);
              }),
              dayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return textColor;
              }),
              todayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return primaryColor;
              }),
              yearBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return primaryColor;
                }
                return null;
              }),
              yearForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return textColor;
              }),
              headerHeadlineStyle: AppTextThemes.heading5(color: Colors.white),
              headerHelpStyle:
                  AppTextThemes.bodySmall(color: Colors.white.withOpacity(0.8)),
              yearStyle: AppTextThemes.bodyMedium(),
              dayStyle: AppTextThemes.bodyMedium(),
              weekdayStyle: AppTextThemes.caption(
                  color: (textColor ?? AppColors.text).withOpacity(0.7)),
            ),
          ),
          child: child!,
        );
      },
      barrierDismissible: barrierDismissible,
    );

    return picked;
  }

  static Future<DateTimeRange?> showCustomDateRangePicker({
    DateTimeRange? initialDateRange,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
    String? cancelText,
    String? confirmText,
    String? saveText,
    Color? primaryColor,
    Color? textColor,
    Color? backgroundColor,
    bool barrierDismissible = true,
  }) async {
    firstDate ??= DateTime(1900);
    lastDate ??= DateTime(2100);
    primaryColor ??= AppColors.primary;
    backgroundColor ??= Colors.white;
    textColor ??= AppColors.text;

    initialDateRange ??= DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 7)),
    );

    return await showDateRangePicker(
      context: Get.context!,
      initialDateRange: initialDateRange,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      saveText: saveText,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor ?? AppColors.primary,
              onPrimary: Colors.white,
              onSurface: textColor ?? AppColors.text,
              surface: backgroundColor ?? Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                textStyle: AppTextThemes.button(),
              ),
            ),
            dialogBackgroundColor: backgroundColor,
            datePickerTheme: DatePickerThemeData(
              backgroundColor: backgroundColor,
              headerBackgroundColor: primaryColor,
              headerForegroundColor: Colors.white,
              surfaceTintColor: backgroundColor,
              dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return primaryColor;
                }
                return null;
              }),
              dayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return textColor;
              }),
              todayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return primaryColor;
                }
                return (primaryColor ?? AppColors.primary).withOpacity(0.2);
              }),
              todayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return primaryColor;
              }),
            ),
          ),
          child: child!,
        );
      },
      barrierDismissible: barrierDismissible,
    );
  }

  static String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String formatDateRange(
    DateTimeRange range, {
    String format = 'MMM dd, yyyy',
  }) {
    final startStr = DateFormat(format).format(range.start);
    final endStr = DateFormat(format).format(range.end);
    return '$startStr - $endStr';
  }
}
