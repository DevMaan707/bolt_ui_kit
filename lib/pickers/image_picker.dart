import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_colors.dart';
import 'permission_handler.dart';

class ImagePickerUtil {
  // Singleton instance
  static final ImagePickerUtil _instance = ImagePickerUtil._internal();
  factory ImagePickerUtil() => _instance;
  ImagePickerUtil._internal();

  final ImagePicker _picker = ImagePicker();

  // Pick image from camera
  Future<File?> pickImageFromCamera({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool enableCrop = false,
    CropSettings? cropSettings,
  }) async {
    bool hasPermission = await _checkCameraPermission();
    if (!hasPermission) return null;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (image != null) {
        File imageFile = File(image.path);

        if (enableCrop) {
          imageFile = await cropImage(imageFile, cropSettings: cropSettings) ??
              imageFile;
        }

        return imageFile;
      }
    } catch (e) {
      print('Error picking camera image: $e');
    }
    return null;
  }

  // Pick image from gallery
  Future<File?> pickImageFromGallery({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool enableCrop = false,
    CropSettings? cropSettings,
  }) async {
    bool hasPermission = await _checkGalleryPermission();
    if (!hasPermission) return null;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (image != null) {
        File imageFile = File(image.path);

        if (enableCrop) {
          imageFile = await cropImage(imageFile, cropSettings: cropSettings) ??
              imageFile;
        }

        return imageFile;
      }
    } catch (e) {
      print('Error picking gallery image: $e');
    }
    return null;
  }

  // Pick multiple images from gallery
  Future<List<File>> pickMultipleImages({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    bool hasPermission = await _checkGalleryPermission();
    if (!hasPermission) return [];

    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      return images.map((image) => File(image.path)).toList();
    } catch (e) {
      print('Error picking multiple images: $e');
      return [];
    }
    return [];
  }

  Future<File?> pickVideoFromCamera({
    double? maxDuration,
    int? quality = 1,
  }) async {
    bool hasPermission = await _checkCameraPermission();
    if (!hasPermission) return null;

    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration:
            maxDuration != null ? Duration(seconds: maxDuration.toInt()) : null,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (video != null) {
        return File(video.path);
      }
    } catch (e) {
      print('Error picking camera video: $e');
    }
    return null;
  }

  Future<File?> pickVideoFromGallery({
    double? maxDuration,
  }) async {
    bool hasPermission = await _checkGalleryPermission();
    if (!hasPermission) return null;

    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration:
            maxDuration != null ? Duration(seconds: maxDuration.toInt()) : null,
      );

      if (video != null) {
        return File(video.path);
      }
    } catch (e) {
      print('Error picking gallery video: $e');
    }
    return null;
  }

  Future<File?> cropImage(
    File imageFile, {
    CropSettings? cropSettings,
  }) async {
    final settings = cropSettings ?? CropSettings();

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: settings.aspectRatio,
        compressQuality: settings.compressQuality,
        compressFormat: settings.compressFormat,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: settings.toolbarTitle,
            toolbarColor: settings.toolbarColor,
            toolbarWidgetColor: settings.toolbarWidgetColor,
            backgroundColor: settings.backgroundColor,
            activeControlsWidgetColor: settings.primaryColor,
            initAspectRatio: settings.initAspectRatio,
            lockAspectRatio: settings.lockAspectRatio,
            hideBottomControls: settings.hideBottomControls,
          ),
          IOSUiSettings(
            title: settings.toolbarTitle,
            cancelButtonTitle: 'Cancel',
            doneButtonTitle: 'Done',
            rotateButtonsHidden: true,
            rotateClockwiseButtonHidden: true,
            aspectRatioLockEnabled: settings.lockAspectRatio,
            resetAspectRatioEnabled: !settings.lockAspectRatio,
          ),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
    } catch (e) {
      print('Error cropping image: $e');
    }
    return null;
  }

  Future<File?> showCustomImagePicker({
    bool allowCamera = true,
    bool allowGallery = true,
    bool enableCrop = false,
    CropSettings? cropSettings,
    Color? primaryColor,
    Color? backgroundColor,
    String? title,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    primaryColor ??= AppColors.primary;
    backgroundColor ??= Colors.white;

    final result = await Get.bottomSheet<File>(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title ?? 'Select Image',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (allowCamera)
                  _buildPickerOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    color: primaryColor,
                    onTap: () async {
                      Get.back();
                      final file = await pickImageFromCamera(
                        maxWidth: maxWidth,
                        maxHeight: maxHeight,
                        imageQuality: imageQuality,
                        enableCrop: enableCrop,
                        cropSettings: cropSettings,
                      );
                      if (file != null) {
                        Get.back(result: file);
                      }
                    },
                  ),
                if (allowGallery)
                  _buildPickerOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    color: primaryColor,
                    onTap: () async {
                      Get.back();
                      final file = await pickImageFromGallery(
                        maxWidth: maxWidth,
                        maxHeight: maxHeight,
                        imageQuality: imageQuality,
                        enableCrop: enableCrop,
                        cropSettings: cropSettings,
                      );
                      if (file != null) {
                        Get.back(result: file);
                      }
                    },
                  ),
              ],
            ),
            SizedBox(height: 16.w),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );

    return result;
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkCameraPermission() async {
    final permissionUtil = PermissionUtil();
    return await permissionUtil.request(
      permission: Permission.camera,
      icon: Icons.camera_alt_rounded,
      iconColor: Colors.blue,
    );
  }

  Future<bool> _checkGalleryPermission() async {
    final permissionUtil = PermissionUtil();
    return await permissionUtil.request(
      permission: Permission.photos,
      icon: Icons.photo_library_rounded,
      iconColor: Colors.purple,
    );
  }
}

class CropSettings {
  final CropAspectRatio? aspectRatio;
  final CropStyle cropStyle;
  final int compressQuality;
  final ImageCompressFormat compressFormat;
  final String toolbarTitle;
  final Color toolbarColor;
  final Color toolbarWidgetColor;
  final Color backgroundColor;
  final Color primaryColor;
  final CropAspectRatioPreset initAspectRatio;
  final bool lockAspectRatio;
  final bool hideBottomControls;

  CropSettings({
    this.aspectRatio,
    this.cropStyle = CropStyle.rectangle,
    this.compressQuality = 90,
    this.compressFormat = ImageCompressFormat.jpg,
    this.toolbarTitle = 'Crop Image',
    this.toolbarColor = const Color(0xFF2196F3),
    this.toolbarWidgetColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.primaryColor = const Color(0xFF2196F3),
    this.initAspectRatio = CropAspectRatioPreset.original,
    this.lockAspectRatio = false,
    this.hideBottomControls = false,
  });
  factory CropSettings.square({
    int compressQuality = 90,
    Color primaryColor = const Color(0xFF2196F3),
    Color backgroundColor = Colors.black,
  }) {
    return CropSettings(
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      cropStyle: CropStyle.rectangle,
      compressQuality: compressQuality,
      initAspectRatio: CropAspectRatioPreset.square,
      lockAspectRatio: true,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
    );
  }
  factory CropSettings.profilePicture({
    int compressQuality = 85,
    Color primaryColor = const Color(0xFF2196F3),
    Color backgroundColor = Colors.black,
  }) {
    return CropSettings(
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      cropStyle: CropStyle.circle,
      compressQuality: compressQuality,
      initAspectRatio: CropAspectRatioPreset.square,
      lockAspectRatio: true,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      toolbarTitle: 'Crop Profile Picture',
    );
  }
  factory CropSettings.coverPhoto({
    int compressQuality = 85,
    Color primaryColor = const Color(0xFF2196F3),
    Color backgroundColor = Colors.black,
  }) {
    return CropSettings(
      aspectRatio: CropAspectRatio(ratioX: 16.0, ratioY: 9.0),
      cropStyle: CropStyle.rectangle,
      compressQuality: compressQuality,
      initAspectRatio: CropAspectRatioPreset.ratio16x9,
      lockAspectRatio: true,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      toolbarTitle: 'Crop Cover Photo',
    );
  }
}
