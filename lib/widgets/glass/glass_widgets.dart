import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'glass_container.dart';
import '../../theme/text_themes.dart';

/// Pre-built glass widgets for common use cases
class GlassWidgets {
  /// Glass loading indicator
  static Widget loading({
    String? message,
    GlassType type = GlassType.frosted,
    Color? color,
  }) {
    return GlassContainer.card(
      type: type,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: color ?? Colors.white,
            strokeWidth: 2.w,
          ),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(
              message,
              style: AppTextThemes.bodyMedium(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Glass notification banner
  static Widget notification({
    required String title,
    required String message,
    IconData? icon,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    GlassType type = GlassType.crystal,
  }) {
    return GlassContainer(
      type: type,
      margin: EdgeInsets.all(16.w),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 24.sp),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextThemes.bodyMedium(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    message,
                    style: AppTextThemes.bodySmall(color: Colors.white70),
                  ),
                ],
              ),
            ),
            if (onDismiss != null) ...[
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: onDismiss,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Glass search bar
  static Widget searchBar({
    String? hintText,
    TextEditingController? controller,
    Function(String)? onChanged,
    VoidCallback? onClear,
    GlassType type = GlassType.frosted,
  }) {
    return GlassContainer(
      type: type,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white70, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTextThemes.bodyMedium(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText ?? 'Search...',
                hintStyle: AppTextThemes.bodyMedium(color: Colors.white60),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (onClear != null) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: onClear,
              child: Icon(Icons.clear, color: Colors.white70, size: 18.sp),
            ),
          ],
        ],
      ),
    );
  }

  /// Glass tab bar
  static Widget tabBar({
    required List<String> tabs,
    required int selectedIndex,
    required Function(int) onTabSelected,
    GlassType type = GlassType.crystal,
  }) {
    return GlassContainer(
      type: type,
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  tab,
                  style: AppTextThemes.bodyMedium(
                    color: Colors.white,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Glass progress indicator
  static Widget progressIndicator({
    required double progress,
    String? label,
    GlassType type = GlassType.frosted,
    Color? progressColor,
  }) {
    return GlassContainer.card(
      type: type,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[
            Text(
              label,
              style: AppTextThemes.bodyMedium(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
          ],
          Stack(
            children: [
              Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: progressColor ?? Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '${(progress * 100).toInt()}%',
            style: AppTextThemes.bodySmall(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  /// Glass image overlay
  static Widget imageOverlay({
    required Widget child,
    String? title,
    String? subtitle,
    List<Widget>? actions,
    GlassType type = GlassType.smoky,
    AlignmentGeometry alignment = Alignment.bottomCenter,
  }) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Align(
            alignment: alignment,
            child: GlassContainer(
              type: type,
              margin: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(
                      title,
                      style: AppTextThemes.bodyLarge(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null) SizedBox(height: 4.h),
                  ],
                  if (subtitle != null) ...[
                    Text(
                      subtitle,
                      style: AppTextThemes.bodyMedium(color: Colors.white70),
                    ),
                  ],
                  if (actions != null && actions.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Glass floating action button
  static Widget floatingActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    GlassType type = GlassType.vibrant,
    Color? iconColor,
  }) {
    return GlassContainer(
      type: type,
      shape: GlassShape.circle,
      width: 56.w,
      height: 56.w,
      onTap: onPressed,
      child: Icon(
        icon,
        color: iconColor ?? Colors.white,
        size: 24.sp,
      ),
    );
  }

  /// Glass tooltip
  static Widget tooltip({
    required String message,
    required Widget child,
    GlassType type = GlassType.smoky,
  }) {
    return Tooltip(
      message: message,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: child,
      preferBelow: false,
      verticalOffset: 20,
      richMessage: WidgetSpan(
        child: GlassContainer(
          type: type,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Text(
            message,
            style: AppTextThemes.bodySmall(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
