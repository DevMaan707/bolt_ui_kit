import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

enum ToastType { success, error, info, warning }

class Toast {
  static void show({
    required String message,
    required ToastType type,
    String? title,
    Duration? duration,
    EdgeInsets? margin,
    double? width,
    bool? dismissible,
    VoidCallback? onTap,
    IconData? customIcon,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    Curve? animationCurve,
    Duration? animationDuration,
    Alignment? position,
  }) {
    final BuildContext? overlayContext = Get.overlayContext ?? Get.context;
    if (overlayContext == null) {
      print("Error: No overlay context found for toast");
      return;
    }
    if (Overlay.maybeOf(overlayContext) == null) {
      print("Error: No Overlay widget found for toast");
      return;
    }

    final Color backgroundColor = _getBackgroundColor(type);
    final IconData icon = customIcon ?? _getIcon(type);
    final title0 = title ?? _getDefaultTitle(type);
    final duration0 = duration ?? const Duration(seconds: 3);
    final margin0 =
        margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 24);
    final width0 = width ?? Get.width * 0.9;
    final dismissible0 = dismissible ?? true;

    final titleStyle0 = titleStyle ??
        GoogleFonts.urbanist(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.1,
        );

    final messageStyle0 = messageStyle ??
        GoogleFonts.urbanist(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          height: 1.3,
        );

    final animationCurve0 = animationCurve ?? Curves.easeOutCirc;
    final animationDuration0 =
        animationDuration ?? const Duration(milliseconds: 400);
    final position0 = position ?? Alignment.bottomCenter;

    OverlayEntry? toastOverlay;
    Widget toast = Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          if (dismissible0) {
            if (toastOverlay != null && toastOverlay.mounted) {
              toastOverlay.remove();
              if (onTap != null) onTap();
            }
          } else if (onTap != null) {
            onTap();
          }
        },
        child: Container(
          width: width0,
          margin: margin0,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: -2,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 3,
                  width: double.infinity,
                  color: _getAccentColor(type),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _getIconBackgroundColor(type),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          color: _getIconColor(type),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (title0 != null)
                              Text(
                                title0,
                                style: titleStyle0,
                              ),
                            SizedBox(height: title0 != null ? 4 : 0),
                            Text(
                              message,
                              style: messageStyle0,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (dismissible0)
                        GestureDetector(
                          onTap: () {
                            if (toastOverlay != null && toastOverlay.mounted) {
                              toastOverlay.remove();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final OverlayState? overlayState = Overlay.of(overlayContext);
      toastOverlay = OverlayEntry(builder: (context) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: animationDuration0,
          curve: animationCurve0,
          builder: (context, value, child) {
            final safeOpacity = value.clamp(0.0, 1.0);
            return Opacity(
              opacity: safeOpacity,
              child: SafeArea(
                child: Align(
                  alignment: position0,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - safeOpacity)),
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: toast,
        );
      });

      overlayState?.insert(toastOverlay);
      Future.delayed(duration0).then((_) {
        if (toastOverlay != null && toastOverlay.mounted) {
          try {
            final OverlayEntry fadeOutEntry = OverlayEntry(builder: (context) {
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 1.0, end: 0.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                onEnd: () {
                  if (toastOverlay != null && toastOverlay.mounted) {
                    toastOverlay.remove();
                  }
                },
                builder: (context, value, child) {
                  final safeOpacity = value.clamp(0.0, 1.0);
                  return Opacity(
                    opacity: safeOpacity,
                    child: SafeArea(
                      child: Align(
                        alignment: position0,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - safeOpacity)),
                          child: child,
                        ),
                      ),
                    ),
                  );
                },
                child: toast,
              );
            });

            if (toastOverlay.mounted) {
              toastOverlay.remove();
              overlayState?.insert(fadeOutEntry);
              Future.delayed(const Duration(milliseconds: 300)).then((_) {
                if (fadeOutEntry.mounted) {
                  fadeOutEntry.remove();
                }
              });
            }
          } catch (e) {
            if (toastOverlay.mounted) {
              toastOverlay.remove();
            }
            print("Error during toast removal: $e");
          }
        }
      });
    } catch (e) {
      print("Error showing toast: $e");
    }
  }

  static Color _getBackgroundColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return const Color(0xFF07753F);
      case ToastType.error:
        return const Color(0xFF942323);
      case ToastType.info:
        return const Color(0xFF0F5E9C);
      case ToastType.warning:
        return const Color(0xFF946B00);
    }
  }

  static Color _getAccentColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return const Color(0xFF4AE68C);
      case ToastType.error:
        return const Color(0xFFFF5252);
      case ToastType.info:
        return const Color(0xFF64B5F6);
      case ToastType.warning:
        return const Color(0xFFFFB74D);
    }
  }

  static Color _getIconBackgroundColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return const Color(0xFF4AE68C).withOpacity(0.2);
      case ToastType.error:
        return const Color(0xFFFF5252).withOpacity(0.2);
      case ToastType.info:
        return const Color(0xFF64B5F6).withOpacity(0.2);
      case ToastType.warning:
        return const Color(0xFFFFB74D).withOpacity(0.2);
    }
  }

  static Color _getIconColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return const Color(0xFF4AE68C);
      case ToastType.error:
        return const Color(0xFFFF5252);
      case ToastType.info:
        return const Color(0xFF64B5F6);
      case ToastType.warning:
        return const Color(0xFFFFB74D);
    }
  }

  static IconData _getIcon(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle_outline;
      case ToastType.error:
        return Icons.error_outline;
      case ToastType.info:
        return Icons.info_outline;
      case ToastType.warning:
        return Icons.warning_amber_rounded;
    }
  }

  static String? _getDefaultTitle(ToastType type) {
    switch (type) {
      case ToastType.success:
        return 'Success';
      case ToastType.error:
        return 'Error';
      case ToastType.info:
        return 'Information';
      case ToastType.warning:
        return 'Warning';
    }
  }
}
