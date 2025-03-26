import 'dart:io';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_colors.dart';
import 'permission_handler.dart';

class FilePickerUtil {
  static final FilePickerUtil _instance = FilePickerUtil._internal();
  factory FilePickerUtil() => _instance;
  FilePickerUtil._internal();
  Future<File?> pickFile({
    List<String>? allowedExtensions,
    fp.FileType type = fp.FileType.any,
    bool allowCompression = true,
    bool allowMultiple = false,
    String? dialogTitle,
  }) async {
    bool hasPermission = await _checkStoragePermission();
    if (!hasPermission) return null;

    try {
      final result = await fp.FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? fp.FileType.custom : type,
        allowedExtensions: allowedExtensions,
        allowCompression: allowCompression,
        allowMultiple: allowMultiple,
        dialogTitle: dialogTitle,
        withData: false,
        withReadStream: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final path = result.files.first.path;
        if (path != null) {
          return File(path);
        }
      }
    } catch (e) {
      print('Error picking file: $e');
    }
    return null;
  }

  Future<List<File>> pickMultipleFiles({
    List<String>? allowedExtensions,
    fp.FileType type = fp.FileType.any,
    bool allowCompression = true,
    String? dialogTitle,
  }) async {
    bool hasPermission = await _checkStoragePermission();
    if (!hasPermission) return [];

    try {
      final result = await fp.FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? fp.FileType.custom : type,
        allowedExtensions: allowedExtensions,
        allowCompression: allowCompression,
        allowMultiple: true,
        dialogTitle: dialogTitle,
        withData: false,
        withReadStream: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final files = result.files
            .where((file) => file.path != null)
            .map((file) => File(file.path!))
            .toList();
        return files;
      }
    } catch (e) {
      print('Error picking files: $e');
    }
    return [];
  }

  Future<String?> saveFile({
    required List<int> bytes,
    required String fileName,
    String? dialogTitle,
    String? initialDirectory,
    List<String>? allowedExtensions,
  }) async {
    bool hasPermission = await _checkStoragePermission();
    if (!hasPermission) return null;

    try {
      final path = await fp.FilePicker.platform.saveFile(
        dialogTitle: dialogTitle ?? 'Save File',
        fileName: fileName,
        initialDirectory: initialDirectory,
        type: allowedExtensions != null ? fp.FileType.custom : fp.FileType.any,
        allowedExtensions: allowedExtensions,
      );

      if (path != null) {
        final file = File(path);
        await file.writeAsBytes(bytes);
        return path;
      }
    } catch (e) {
      print('Error saving file: $e');
    }
    return null;
  }

  Future<String?> pickDirectory({
    String? dialogTitle,
    String? initialDirectory,
  }) async {
    bool hasPermission = await _checkStoragePermission();
    if (!hasPermission) return null;

    try {
      final result = await fp.FilePicker.platform.getDirectoryPath(
        dialogTitle: dialogTitle,
        initialDirectory: initialDirectory,
      );
      return result;
    } catch (e) {
      print('Error picking directory: $e');
      return null;
    }
  }

  Future<File?> showCustomFilePicker({
    required BuildContext context,
    List<String>? allowedExtensions,
    fp.FileType type = fp.FileType.any,
    String? title,
    Color? primaryColor,
    Color? backgroundColor,
  }) async {
    bool hasPermission = await _checkStoragePermission();
    if (!hasPermission) return null;

    primaryColor ??= AppColors.primary;
    backgroundColor ??= Colors.white;

    final result = await showModalBottomSheet<File>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _CustomFilePickerSheet(
        allowedExtensions: allowedExtensions,
        type: type,
        title: title ?? 'Select File',
        primaryColor: primaryColor!,
        backgroundColor: backgroundColor!,
      ),
    );

    return result;
  }

  Future<bool> _checkStoragePermission() async {
    final permissionUtil = PermissionUtil();
    return await permissionUtil.request(
      permission: Permission.storage,
      title: 'Storage Access',
      description: 'We need storage access to select files from your device.',
      icon: Icons.folder_rounded,
      iconColor: Colors.amber,
    );
  }
}

class _CustomFilePickerSheet extends StatelessWidget {
  final List<String>? allowedExtensions;
  final fp.FileType type;
  final String title;
  final Color primaryColor;
  final Color backgroundColor;

  const _CustomFilePickerSheet({
    Key? key,
    this.allowedExtensions,
    required this.type,
    required this.title,
    required this.primaryColor,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
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
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOption(
                context: context,
                icon: Icons.description_rounded,
                label: 'Documents',
                onTap: () => _pickFile(context, fp.FileType.any),
                color: primaryColor,
              ),
              _buildOption(
                context: context,
                icon: Icons.image_rounded,
                label: 'Images',
                onTap: () => _pickFile(context, fp.FileType.image),
                color: primaryColor,
              ),
              _buildOption(
                context: context,
                icon: Icons.picture_as_pdf_rounded,
                label: 'PDFs',
                onTap: () => _pickFile(
                  context,
                  fp.FileType.custom,
                  allowedExtensions: ['pdf'],
                ),
                color: primaryColor,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOption(
                context: context,
                icon: Icons.videocam_rounded,
                label: 'Videos',
                onTap: () => _pickFile(context, fp.FileType.video),
                color: primaryColor,
              ),
              _buildOption(
                context: context,
                icon: Icons.audiotrack_rounded,
                label: 'Audio',
                onTap: () => _pickFile(context, fp.FileType.audio),
                color: primaryColor,
              ),
              _buildOption(
                context: context,
                icon: Icons.more_horiz_rounded,
                label: 'Other',
                onTap: () => _pickFile(
                  context,
                  allowedExtensions != null
                      ? fp.FileType.custom
                      : fp.FileType.any,
                  allowedExtensions: allowedExtensions,
                ),
                color: primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28.w),
            ),
            SizedBox(height: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile(
    BuildContext context,
    fp.FileType fileType, {
    List<String>? allowedExtensions,
  }) async {
    final result = await fp.FilePicker.platform.pickFiles(
      type: allowedExtensions != null ? fp.FileType.custom : fileType,
      allowedExtensions: allowedExtensions,
      allowCompression: true,
      withData: false,
      withReadStream: true,
    );

    if (result != null &&
        result.files.isNotEmpty &&
        result.files.first.path != null) {
      final file = File(result.files.first.path!);
      Navigator.of(context).pop(file);
    }
  }
}
