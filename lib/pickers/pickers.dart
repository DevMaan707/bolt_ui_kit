export 'permission_handler.dart';
export 'date_picker.dart';
export 'time_picker.dart';
export 'file_picker.dart';
export 'image_picker.dart';
export 'qr_scanner.dart';
export 'calendar_picker.dart';

// Some convenient helper methods
import 'dart:io';
import 'package:flutter/material.dart';
import 'permission_handler.dart';
import 'date_picker.dart';
import 'time_picker.dart';
import 'file_picker.dart';
import 'image_picker.dart';
import 'qr_scanner.dart';
import 'calendar_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPickers {
  // Permission helpers
  static Future<bool> requestPermission(Permission permission) async {
    return await PermissionUtil().request(permission: permission);
  }

  static Future<Map<Permission, bool>> requestMultiplePermissions(
      List<Permission> permissions) async {
    return await PermissionUtil().requestMultiple(permissions: permissions);
  }

  // Date picker helpers
  static Future<DateTime?> pickDate() async {
    return await DatePickerUtil.showCustomDatePicker();
  }

  static Future<DateTimeRange?> pickDateRange() async {
    return await DatePickerUtil.showCustomDateRangePicker();
  }

  // Time picker helpers
  static Future<TimeOfDay?> pickTime() async {
    return await TimePickerUtil.showCustomTimePicker();
  }

  static Future<Duration?> pickDuration() async {
    return await TimePickerUtil.showDurationPicker();
  }

  // File picker helpers
  static Future<File?> pickFile() async {
    return await FilePickerUtil().pickFile();
  }

  static Future<List<File>> pickMultipleFiles() async {
    return await FilePickerUtil().pickMultipleFiles();
  }

  static Future<String?> pickDirectory() async {
    return await FilePickerUtil().pickDirectory();
  }

  // Image picker helpers
  static Future<File?> pickImage({bool fromCamera = false}) async {
    if (fromCamera) {
      return await ImagePickerUtil().pickImageFromCamera();
    } else {
      return await ImagePickerUtil().pickImageFromGallery();
    }
  }

  static Future<File?> pickImageWithDialog() async {
    return await ImagePickerUtil().showCustomImagePicker();
  }

  static Future<List<File>> pickMultipleImages() async {
    return await ImagePickerUtil().pickMultipleImages();
  }

  // Video picker helpers
  static Future<File?> pickVideo({bool fromCamera = false}) async {
    if (fromCamera) {
      return await ImagePickerUtil().pickVideoFromCamera();
    } else {
      return await ImagePickerUtil().pickVideoFromGallery();
    }
  }

  // QR scanner helper
  static Future<String?> scanQR() async {
    return await QRScannerUtil().scanQR();
  }

  // Calendar picker helper
  static Future<DateTime?> pickCalendarDate() async {
    final result = await CalendarPickerUtil.showCalendarPicker(
        mode: CalendarPickerMode.single);
    return result?.selectedDate;
  }

  static Future<List<DateTime>?> pickMultipleDates() async {
    final result = await CalendarPickerUtil.showCalendarPicker(
        mode: CalendarPickerMode.multi);
    return result?.selectedDates;
  }

  static Future<DateTimeRange?> pickCalendarRange() async {
    final result = await CalendarPickerUtil.showCalendarPicker(
        mode: CalendarPickerMode.range);
    return result?.selectedRange;
  }
}
