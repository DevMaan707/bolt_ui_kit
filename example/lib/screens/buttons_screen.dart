import 'package:flutter/material.dart';
import 'package:bolt_ui_kit/components/navbar/navbar.dart';
import 'package:bolt_ui_kit/bolt_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonsScreen extends StatelessWidget {
  const ButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(
        title: 'Buttons',
        style: NavbarStyle.standard,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Button Types'),
            SizedBox(height: 16.h),
            Button(
              text: 'Primary Button',
              type: ButtonType.primary,
              onPressed: () => _showButtonPressed(context, 'Primary'),
              size: ButtonSize.large,
            ),
            SizedBox(height: 16.h),
            Button(
              text: 'Secondary Button',
              type: ButtonType.secondary,
              onPressed: () => _showButtonPressed(context, 'Secondary'),
              size: ButtonSize.medium,
            ),
            SizedBox(height: 16.h),
            Button(
              text: 'Outlined Button',
              type: ButtonType.outlined,
              onPressed: () => _showButtonPressed(context, 'Outlined'),
              size: ButtonSize.medium,
            ),
            SizedBox(height: 16.h),
            Button(
              text: 'Text Button',
              type: ButtonType.text,
              onPressed: () => _showButtonPressed(context, 'Text'),
              size: ButtonSize.medium,
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Button with Icons'),
            SizedBox(height: 16.h),
            Button(
              text: 'Left Icon',
              type: ButtonType.primary,
              icon: Icons.favorite,
              onPressed: () => _showButtonPressed(context, 'Left Icon'),
            ),
            SizedBox(height: 16.h),
            Button(
              text: 'Right Icon',
              type: ButtonType.primary,
              icon: Icons.arrow_forward,
              iconRight: true,
              onPressed: () => _showButtonPressed(context, 'Right Icon'),
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Button Sizes'),
            SizedBox(height: 16.h),
            Button(
              text: 'Small Button',
              type: ButtonType.primary,
              size: ButtonSize.small,
              onPressed: () => _showButtonPressed(context, 'Small'),
            ),
            SizedBox(height: 16.h),
            Button(
              text: 'Medium Button',
              type: ButtonType.primary,
              size: ButtonSize.medium,
              onPressed: () => _showButtonPressed(context, 'Medium'),
            ),
            SizedBox(height: 16.h),
            Button(
              text: 'Large Button',
              type: ButtonType.primary,
              size: ButtonSize.large,
              onPressed: () => _showButtonPressed(context, 'Large'),
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Button States'),
            SizedBox(height: 16.h),
            const Button(
              text: 'Disabled Button',
              type: ButtonType.primary,
              onPressed: null,
            ),
            SizedBox(height: 16.h),
            Button(
              text: 'Loading Button',
              type: ButtonType.primary,
              isLoading: true,
              onPressed: () {},
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Custom Button'),
            SizedBox(height: 16.h),
            Button(
              text: 'Custom Button',
              type: ButtonType.custom,
              backgroundColor: Colors.deepOrange,
              textColor: Colors.white,
              borderRadius: BorderRadius.circular(25.r),
              onPressed: () => _showButtonPressed(context, 'Custom'),
            ),
            SizedBox(height: 16.h),
            Button(
              text: 'Full Width Button',
              type: ButtonType.primary,
              width: double.infinity,
              onPressed: () => _showButtonPressed(context, 'Full Width'),
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

  void _showButtonPressed(BuildContext context, String type) {
    Toast.show(
      message: '$type button was pressed',
      type: ToastType.info,
    );
  }
}
