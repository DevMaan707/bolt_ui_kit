import 'package:flutter/material.dart';
import 'package:flutter_kit/components/navbar/navbar.dart';
import 'package:flutter_kit/flutter_kit.dart';
import 'package:flutter_kit_demo/screens/themes_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'buttons_screen.dart';
import 'cards_screen.dart';
import 'forms_screen.dart';
import 'charts_screen.dart';
import 'layouts_screen.dart';
import 'pickers_screen.dart';
import 'toast_screen.dart';
import 'api_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(
        title: 'Flutter Kit Demo',
        style: NavbarStyle.standard,
        centerTitle: true,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            SizedBox(height: 24.h),
            _buildFeatureGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to Flutter Kit',
          style: AppTextThemes.heading2(
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'A comprehensive UI component library for rapid app development.',
          style: AppTextThemes.bodyLarge(),
        ),
      ],
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final features = [
      {
        'title': 'Buttons',
        'description': 'Versatile button components',
        'icon': Icons.touch_app,
        'screen': const ButtonsScreen(),
      },
      {
        'title': 'Cards',
        'description': 'Different card styles',
        'icon': Icons.credit_card,
        'screen': const CardsScreen(),
      },
      {
        'title': 'Form Inputs',
        'description': 'Form controls and validation',
        'icon': Icons.edit,
        'screen': const FormsScreen(),
      },
      {
        'title': 'Pickers',
        'description': 'Date, time and file selectors',
        'icon': Icons.calendar_today,
        'screen': PickersScreen(),
      },
      {
        'title': 'Charts',
        'description': 'Data visualization components',
        'icon': Icons.pie_chart,
        'screen': const ChartsScreen(),
      },
      {
        'title': 'Layouts',
        'description': 'Layout components and patterns',
        'icon': Icons.dashboard,
        'screen': LayoutsScreen(),
      },
      {
        'title': 'Toast Notifications',
        'description': 'In-app notification messages',
        'icon': Icons.notifications,
        'screen': ToastScreen(),
      },
      {
        'title': 'API Integration',
        'description': 'Working with REST APIs',
        'icon': Icons.cloud,
        'screen': const ApiScreen(),
      },
      {
        'title': 'Theming',
        'description': 'Colors, typography, and styles',
        'icon': Icons.color_lens,
        'screen': ThemeScreen(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.1,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildFeatureCard(
          context,
          title: feature['title'] as String,
          description: feature['description'] as String,
          icon: feature['icon'] as IconData,
          screen: feature['screen'] as Widget,
        );
      },
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Widget screen,
  }) {
    return AppCard(
      type: CardType.elevated,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 36.sp,
            color: AppColors.primary,
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: AppTextThemes.heading6(),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            description,
            style: AppTextThemes.bodySmall(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
