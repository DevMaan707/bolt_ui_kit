import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../theme/text_themes.dart';

class TimePickerUtil {
  static Future<TimeOfDay?> showCustomTimePicker({
    TimeOfDay? initialTime,
    String? helpText,
    String? cancelText,
    String? confirmText,
    TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
    Color? primaryColor,
    Color? textColor,
    Color? backgroundColor,
    bool use24HourFormat = false,
    bool barrierDismissible = true,
  }) async {
    initialTime ??= TimeOfDay.now();
    primaryColor ??= AppColors.primary;
    backgroundColor ??= Colors.white;
    textColor ??= AppColors.text;

    return await showTimePicker(
      context: Get.context!,
      initialTime: initialTime,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      initialEntryMode: initialEntryMode,
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
                foregroundColor: primaryColor ?? AppColors.primary,
                textStyle: AppTextThemes.button(),
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: backgroundColor ?? Colors.white,
              hourMinuteTextColor: primaryColor ?? AppColors.primary,
              hourMinuteColor:
                  (primaryColor ?? AppColors.primary).withOpacity(0.1),
              dayPeriodTextColor: primaryColor ?? AppColors.primary,
              dayPeriodColor:
                  (primaryColor ?? AppColors.primary).withOpacity(0.1),
              dialHandColor: primaryColor ?? AppColors.primary,
              dialBackgroundColor:
                  (primaryColor ?? AppColors.primary).withOpacity(0.1),
              dialTextColor: textColor ?? AppColors.text,
              entryModeIconColor: primaryColor ?? AppColors.primary,
              helpTextStyle:
                  AppTextThemes.bodyMedium(color: textColor ?? AppColors.text),
              dayPeriodTextStyle: AppTextThemes.button(
                  color: primaryColor ?? AppColors.primary),
              hourMinuteTextStyle: AppTextThemes.heading4(
                  color: primaryColor ?? AppColors.primary),
              dialTextStyle:
                  AppTextThemes.bodyMedium(color: textColor ?? AppColors.text),
            ),
            dialogBackgroundColor: backgroundColor ?? Colors.white,
            textTheme: TextTheme(
              labelSmall: AppTextThemes.caption(
                  color: (textColor ?? AppColors.text).withOpacity(0.7)),
            ),
          ),
          child: child!,
        );
      },
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<Duration?> showDurationPicker({
    Duration? initialDuration,
    Duration? maxDuration,
    bool showHours = true,
    bool showMinutes = true,
    bool showSeconds = true,
    Color? primaryColor,
    Color? backgroundColor,
    Color? textColor,
  }) async {
    initialDuration ??= const Duration(minutes: 30);
    maxDuration ??= const Duration(hours: 24);
    primaryColor ??= AppColors.primary;
    backgroundColor ??= Colors.white;
    textColor ??= AppColors.text;

    int hours = initialDuration.inHours;
    int minutes = (initialDuration.inMinutes % 60);
    int seconds = (initialDuration.inSeconds % 60);

    Duration? result = await Get.dialog<Duration>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Duration',
                style: AppTextThemes.heading5(color: textColor),
              ),
              const SizedBox(height: 24),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (showHours) ...[
                        _buildDurationPicker(
                          context: context,
                          value: hours,
                          label: 'Hours',
                          maxValue: maxDuration?.inHours ?? 0,
                          onChanged: (value) {
                            setState(() => hours = value);
                          },
                          primaryColor: primaryColor ?? AppColors.primary,
                          textColor: textColor ?? AppColors.text,
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (showMinutes) ...[
                        _buildDurationPicker(
                          context: context,
                          value: minutes,
                          label: 'Min',
                          maxValue: 59,
                          onChanged: (value) {
                            setState(() => minutes = value);
                          },
                          primaryColor: primaryColor ?? AppColors.primary,
                          textColor: textColor ?? AppColors.text,
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (showSeconds) ...[
                        _buildDurationPicker(
                          context: context,
                          value: seconds,
                          label: 'Sec',
                          maxValue: 59,
                          onChanged: (value) {
                            setState(() => seconds = value);
                          },
                          primaryColor: primaryColor ?? AppColors.primary,
                          textColor: textColor ?? AppColors.text,
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextThemes.button(color: Colors.grey[700]),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final duration = Duration(
                        hours: hours,
                        minutes: minutes,
                        seconds: seconds,
                      );
                      Get.back(result: duration);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Confirm',
                      style: AppTextThemes.button(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return result;
  }

  static Widget _buildDurationPicker({
    required BuildContext context,
    required int value,
    required String label,
    required int maxValue,
    required Function(int) onChanged,
    required Color primaryColor,
    required Color textColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_drop_up, color: primaryColor),
                onPressed: () {
                  if (value < maxValue) {
                    onChanged(value + 1);
                  }
                },
              ),
              Text(
                value.toString().padLeft(2, '0'),
                style: AppTextThemes.heading5(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                onPressed: () {
                  if (value > 0) {
                    onChanged(value - 1);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextThemes.caption(
            color: textColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  static String formatTimeOfDay(
    TimeOfDay time, {
    bool alwaysUse24HourFormat = false,
  }) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = alwaysUse24HourFormat ? 'HH:mm' : 'h:mm a';
    return DateFormat(format).format(dt);
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '$twoDigitMinutes:$twoDigitSeconds';
    }
  }
}
