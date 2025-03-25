library flutter_kit;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';
import 'services/storage_service.dart';
import 'helpers/navigator.dart';

// Export modules for easy access
export 'api/api_service.dart';
export 'components/toast/toast.dart';
export 'theme/app_colors.dart';
export 'theme/app_theme.dart';
export 'theme/text_themes.dart';
export 'widgets/buttons/buttons.dart';
export 'widgets/cards/cards.dart';
export 'widgets/forms/forms.dart';
export 'widgets/inputs/inputs.dart';
export 'widgets/layouts/layout.dart';

class FlutterKit {
  static Future<void> initialize({
    required Color primaryColor,
    required Color accentColor,
    Size designSize = const Size(375, 812),
    String? fontFamily,
    GlobalKey<NavigatorState>? navigatorKey,
    bool enableLogging = true,
  }) async {
    await StorageService().init();

    AppColors.initialize(
      primary: primaryColor,
      accent: accentColor,
    );

    AppTheme.initialize(
      primary: primaryColor,
      accent: accentColor,
      fontFamily: fontFamily,
    );
    if (navigatorKey != null) {
      NavigationService.navigatorKey = navigatorKey;
    }
    _registerDependencies();
  }

  static Widget builder({
    required Widget Function() builder,
    Size designSize = const Size(375, 812),
  }) {
    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return builder();
      },
    );
  }

  static void _registerDependencies() {
    Get.put(StorageService());
  }
}
