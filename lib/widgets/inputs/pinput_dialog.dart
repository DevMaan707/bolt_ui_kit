import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/text_themes.dart';
import 'pinput.dart';

Future<String?> showPinInputDialog({
  required BuildContext context,
  String title = 'Enter PIN',
  String? subtitle,
  String confirmButtonText = 'Confirm',
  String cancelButtonText = 'Cancel',
  int length = 6,
  PinInputTheme theme = PinInputTheme.outlined,
  bool obscureText = false,
  String? initialValue,
  TextInputType keyboardType = TextInputType.number,
  List<TextInputFormatter>? inputFormatters,
  Function(String)? onChanged,
  Function(String)? validator,
  Color? backgroundColor,
  bool barrierDismissible = true,
}) async {
  String enteredPin = initialValue ?? '';
  String? errorText;

  final result = await showDialog<String>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: backgroundColor ??
                (Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextThemes.heading5(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      subtitle,
                      style: AppTextThemes.bodyMedium(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  SizedBox(height: 24.h),
                  BoltPinInput(
                    length: length,
                    theme: theme,
                    obscureText: obscureText,
                    initialValue: initialValue,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    errorText: errorText,
                    autofocus: true,
                    onChanged: (pin) {
                      enteredPin = pin;
                      if (onChanged != null) {
                        onChanged(pin);
                      }
                      if (errorText != null) {
                        setState(() {
                          errorText = null;
                        });
                      }
                    },
                    onCompleted: (pin) {
                      enteredPin = pin;
                      if (validator != null) {
                        final validationResult = validator(pin);
                        if (validationResult != null) {
                          setState(() {
                            errorText = validationResult;
                          });
                          return;
                        }
                      }
                      Navigator.of(context).pop(pin);
                    },
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(null);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.text,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(cancelButtonText),
                      ),
                      SizedBox(width: 8.w),
                      ElevatedButton(
                        onPressed: enteredPin.length == length
                            ? () {
                                if (validator != null) {
                                  final validationResult =
                                      validator(enteredPin);
                                  if (validationResult != null) {
                                    setState(() {
                                      errorText = validationResult;
                                    });
                                    return;
                                  }
                                }
                                Navigator.of(context).pop(enteredPin);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(confirmButtonText),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  return result;
}
