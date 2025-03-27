import 'package:flutter/material.dart';
import 'package:flutter_kit/components/navbar/navbar.dart';
import 'package:flutter_kit/flutter_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const Navbar(
        title: 'Theming',
        style: NavbarStyle.standard,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Theme: ${isDarkMode ? 'Dark' : 'Light'} Mode',
              style: AppTextThemes.heading5(),
            ),
            SizedBox(height: 16.h),

            // Colors Section
            _buildSection(
              title: 'Colors',
              child: _buildColorsShowcase(),
            ),

            // Typography Section
            _buildSection(
              title: 'Typography',
              child: _buildTypographyShowcase(),
            ),

            // Theme Switching Button
            _buildSection(
              title: 'Theme Switching',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You can toggle between light and dark themes.',
                    style: AppTextThemes.bodyMedium(),
                  ),
                  SizedBox(height: 16.h),
                  Button(
                    text: isDarkMode
                        ? 'Switch to Light Theme'
                        : 'Switch to Dark Theme',
                    type: ButtonType.primary,
                    icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    onPressed: () {
                      // In a real app, this would use a theme provider to switch themes
                      Toast.show(
                        message: 'In a real app, this would toggle the theme.',
                        type: ToastType.info,
                      );
                    },
                  ),
                ],
              ),
            ),

            // Font Families
            _buildSection(
              title: 'Font Families',
              child: _buildFontFamiliesShowcase(),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextThemes.heading5(),
        ),
        SizedBox(height: 16.h),
        AppCard(
          child: child,
        ),
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildColorsShowcase() {
    final colors = [
      {'name': 'Primary', 'color': AppColors.primary},
      {'name': 'Accent', 'color': AppColors.accent},
      {'name': 'Success', 'color': AppColors.success},
      {'name': 'Error', 'color': AppColors.error},
      {'name': 'Warning', 'color': AppColors.warning},
      {'name': 'Info', 'color': AppColors.info},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'These are the main colors used throughout the app:',
          style: AppTextThemes.bodyMedium(),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          children: colors.map((colorData) {
            return Column(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: colorData['color'] as Color,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  colorData['name'] as String,
                  style: AppTextThemes.bodySmall(),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTypographyShowcase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Heading 1',
          style: AppTextThemes.heading1(),
        ),
        SizedBox(height: 8.h),
        Text(
          'Heading 2',
          style: AppTextThemes.heading2(),
        ),
        SizedBox(height: 8.h),
        Text(
          'Heading 3',
          style: AppTextThemes.heading3(),
        ),
        SizedBox(height: 8.h),
        Text(
          'Heading 4',
          style: AppTextThemes.heading4(),
        ),
        SizedBox(height: 8.h),
        Text(
          'Heading 5',
          style: AppTextThemes.heading5(),
        ),
        SizedBox(height: 8.h),
        Text(
          'Heading 6',
          style: AppTextThemes.heading6(),
        ),
        SizedBox(height: 16.h),
        Text(
          'Body Large: This is an example of body large text which is typically used for main content.',
          style: AppTextThemes.bodyLarge(),
        ),
        SizedBox(height: 8.h),
        Text(
          'Body Medium: This is an example of body medium text which is typically used for regular content.',
          style: AppTextThemes.bodyMedium(),
        ),
        SizedBox(height: 8.h),
        Text(
          'Body Small: This is an example of body small text which is typically used for secondary content.',
          style: AppTextThemes.bodySmall(),
        ),
        SizedBox(height: 8.h),
        Text(
          'Caption: This is an example of caption text used for supplementary information.',
          style: AppTextThemes.caption(),
        ),
        SizedBox(height: 8.h),
        Text(
          'BUTTON TEXT',
          style: AppTextThemes.button(),
        ),
      ],
    );
  }

  Widget _buildFontFamiliesShowcase() {
    final fontFamilies = AppTextThemes.availableFonts.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Google Font options:',
          style: AppTextThemes.bodyMedium(),
        ),
        SizedBox(height: 16.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: fontFamilies.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final fontFamily = fontFamilies[index];
            return AppCard(
              type: CardType.outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fontFamily,
                    style:
                        AppTextThemes.bodyMedium(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'The quick brown fox jumps over the lazy dog.',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
