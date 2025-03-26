import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import '../components/toast/toast.dart';
import '../theme/app_colors.dart';
import '../widgets/buttons/buttons.dart';

class PermissionUtil {
  static final PermissionUtil _instance = PermissionUtil._internal();
  factory PermissionUtil() => _instance;
  PermissionUtil._internal();
  Future<bool> request({
    required Permission permission,
    String? title,
    String? description,
    String? iconPath,
    IconData? icon,
    Color? iconColor,
    bool useDialog = true,
    bool showRationaleDialog = true,
  }) async {
    final status = await permission.status;
    if (status.isGranted) return true;
    if (useDialog && showRationaleDialog && status.isDenied) {
      final result = await _showPermissionDialog(
        permission: permission,
        title: title ?? _getDefaultTitle(permission),
        description: description ?? _getDefaultDescription(permission),
        iconPath: iconPath,
        icon: icon ?? _getDefaultIcon(permission),
        iconColor: iconColor ?? _getDefaultColor(permission),
      );
      return result;
    } else {
      final result = await permission.request();
      return result.isGranted;
    }
  }

  Future<Map<Permission, bool>> requestMultiple({
    required List<Permission> permissions,
    bool showRationaleDialog = true,
  }) async {
    Map<Permission, PermissionStatus> statuses = {};
    for (var permission in permissions) {
      statuses[permission] = await permission.status;
    }
    List<Permission> permissionsToRequest = permissions
        .where((permission) =>
            statuses[permission]?.isDenied == true ||
            statuses[permission]?.isRestricted == true)
        .toList();

    if (permissionsToRequest.isEmpty) {
      return Map.fromIterable(permissions, key: (p) => p, value: (_) => true);
    }

    if (showRationaleDialog && permissionsToRequest.length > 0) {
      bool userAccepted = await _showMultiplePermissionsDialog(
        permissions: permissionsToRequest,
      );

      if (!userAccepted) {
        return Map.fromIterable(permissions,
            key: (p) => p, value: (p) => statuses[p]?.isGranted == true);
      }
    }
    Map<Permission, PermissionStatus> results =
        await permissionsToRequest.request();
    return Map.fromIterable(permissions,
        key: (p) => p,
        value: (p) =>
            results[p]?.isGranted == true || statuses[p]?.isGranted == true);
  }

  Future<bool> isGranted(Permission permission) async {
    return await permission.isGranted;
  }

  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  Future<void> showPermanentlyDeniedDialog({
    required String title,
    required String description,
    String? settingsButtonText,
    String? cancelButtonText,
  }) async {
    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.security,
                size: 50,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Button(
                    text: cancelButtonText ?? 'Cancel',
                    type: ButtonType.outlined,
                    onPressed: () => Get.back(),
                  ),
                  Button(
                    text: settingsButtonText ?? 'Open Settings',
                    type: ButtonType.primary,
                    onPressed: () {
                      Get.back();
                      openAppSettings();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<bool> _showPermissionDialog({
    required Permission permission,
    required String title,
    required String description,
    String? iconPath,
    required IconData icon,
    required Color iconColor,
  }) async {
    bool? result = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconPath != null)
                Image.asset(
                  iconPath,
                  height: 80,
                  width: 80,
                )
              else
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: iconColor,
                  ),
                ),
              const SizedBox(height: 24),
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                description,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Button(
                    text: 'Not Now',
                    type: ButtonType.outlined,
                    onPressed: () => Get.back(result: false),
                  ),
                  Button(
                    text: 'Allow',
                    type: ButtonType.primary,
                    onPressed: () => Get.back(result: true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    if (result == true) {
      final permissionStatus = await permission.request();
      return permissionStatus.isGranted;
    } else {
      return false;
    }
  }

  Future<bool> _showMultiplePermissionsDialog({
    required List<Permission> permissions,
  }) async {
    return await Get.dialog<bool>(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.security,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Required Permissions",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  ...permissions.map((permission) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(_getDefaultIcon(permission), size: 20),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(_getDefaultTitle(permission)),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Button(
                        text: 'Not Now',
                        type: ButtonType.outlined,
                        onPressed: () => Get.back(result: false),
                      ),
                      Button(
                        text: 'Allow All',
                        type: ButtonType.primary,
                        onPressed: () => Get.back(result: true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        ) ??
        false;
  }

  String _getDefaultTitle(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return 'Camera Access';
      case Permission.microphone:
        return 'Microphone Access';
      case Permission.storage:
        return 'Storage Access';
      case Permission.photos:
        return 'Photo Library Access';
      case Permission.location:
      case Permission.locationAlways:
      case Permission.locationWhenInUse:
        return 'Location Access';
      case Permission.contacts:
        return 'Contacts Access';
      case Permission.calendar:
        return 'Calendar Access';
      case Permission.bluetooth:
        return 'Bluetooth Access';
      default:
        return 'Permission Required';
    }
  }

  String _getDefaultDescription(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return 'We need camera access to take pictures and scan codes.';
      case Permission.microphone:
        return 'We need microphone access to record audio.';
      case Permission.storage:
        return 'We need storage access to save and load files.';
      case Permission.photos:
        return 'We need photo library access to select and save images.';
      case Permission.location:
      case Permission.locationAlways:
      case Permission.locationWhenInUse:
        return 'We need location access to show you nearby services.';
      case Permission.contacts:
        return 'We need contacts access to help you connect with friends.';
      case Permission.calendar:
        return 'We need calendar access to schedule events.';
      case Permission.bluetooth:
        return 'We need bluetooth access to connect to nearby devices.';
      default:
        return 'This permission is required for the app to function properly.';
    }
  }

  IconData _getDefaultIcon(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return Icons.camera_alt_rounded;
      case Permission.microphone:
        return Icons.mic_rounded;
      case Permission.storage:
        return Icons.folder_rounded;
      case Permission.photos:
        return Icons.photo_library_rounded;
      case Permission.location:
      case Permission.locationAlways:
      case Permission.locationWhenInUse:
        return Icons.location_on_rounded;
      case Permission.contacts:
        return Icons.contacts_rounded;
      case Permission.calendar:
        return Icons.event_rounded;
      case Permission.bluetooth:
        return Icons.bluetooth_rounded;
      default:
        return Icons.security_rounded;
    }
  }

  Color _getDefaultColor(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return Colors.blueAccent;
      case Permission.microphone:
        return Colors.orangeAccent;
      case Permission.storage:
        return Colors.tealAccent.shade700;
      case Permission.photos:
        return Colors.purpleAccent;
      case Permission.location:
      case Permission.locationAlways:
      case Permission.locationWhenInUse:
        return Colors.redAccent;
      case Permission.contacts:
        return Colors.greenAccent.shade700;
      case Permission.calendar:
        return Colors.amberAccent.shade700;
      case Permission.bluetooth:
        return Colors.indigoAccent;
      default:
        return AppColors.primary;
    }
  }
}
