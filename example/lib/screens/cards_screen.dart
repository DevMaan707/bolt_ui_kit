import 'package:flutter/material.dart';
import 'package:bolt_ui_kit/components/navbar/navbar.dart';
import 'package:bolt_ui_kit/bolt_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(
        title: 'Cards',
        style: NavbarStyle.standard,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Standard Card'),
            SizedBox(height: 16.h),
            AppCard(
              type: CardType.standard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Standard Card',
                    style: AppTextThemes.heading6(),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'This is a standard card with default styling.',
                    style: AppTextThemes.bodyMedium(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Elevated Card'),
            SizedBox(height: 16.h),
            AppCard(
              type: CardType.elevated,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Elevated Card',
                    style: AppTextThemes.heading6(),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'This card has a higher elevation for more prominence.',
                    style: AppTextThemes.bodyMedium(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Outlined Card'),
            SizedBox(height: 16.h),
            AppCard(
              type: CardType.outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Outlined Card',
                    style: AppTextThemes.heading6(),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'This card has an outline border instead of elevation.',
                    style: AppTextThemes.bodyMedium(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Minimal Card'),
            SizedBox(height: 16.h),
            AppCard(
              type: CardType.minimal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minimal Card',
                    style: AppTextThemes.heading6(),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'This card has minimal styling with just padding.',
                    style: AppTextThemes.bodyMedium(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Interactive Card'),
            SizedBox(height: 16.h),
            AppCard(
              type: CardType.elevated,
              onTap: () {
                Toast.show(
                  message: 'Card was tapped',
                  type: ToastType.info,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interactive Card',
                    style: AppTextThemes.heading6(),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Tap this card to trigger an action.',
                    style: AppTextThemes.bodyMedium(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Custom Card'),
            SizedBox(height: 16.h),
            AppCard(
              type: CardType.standard,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24.r),
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.star,
                          color: AppColors.primary,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        'Custom Styled Card',
                        style: AppTextThemes.heading6(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'This card has custom styling with background color, border radius, and padding.',
                    style: AppTextThemes.bodyMedium(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTextThemes.heading5(),
    );
  }
}
