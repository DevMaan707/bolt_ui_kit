import 'package:flutter/material.dart';
import 'package:flutter_kit/components/navbar/navbar.dart';
import 'package:flutter_kit/flutter_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LayoutsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: 'Layouts',
        style: NavbarStyle.standard,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Layout Types'),
            SizedBox(height: 16.h),
            _buildLayoutCard(
              title: 'Standard Layout',
              description: 'Basic layout without scroll or safe area',
              buttonText: 'View Example',
              onPressed: () => _showLayoutExample(
                context,
                AppLayoutType.standard,
                'Standard Layout',
              ),
            ),
            SizedBox(height: 16.h),
            _buildLayoutCard(
              title: 'Scroll Layout',
              description: 'Layout with scrolling capability',
              buttonText: 'View Example',
              onPressed: () => _showLayoutExample(
                context,
                AppLayoutType.scroll,
                'Scroll Layout',
              ),
            ),
            SizedBox(height: 16.h),
            _buildLayoutCard(
              title: 'Safe Area Layout',
              description:
                  'Layout with safe area for device notches and UI elements',
              buttonText: 'View Example',
              onPressed: () => _showLayoutExample(
                context,
                AppLayoutType.safeArea,
                'Safe Area Layout',
              ),
            ),
            SizedBox(height: 16.h),
            _buildLayoutCard(
              title: 'Constrained Layout',
              description: 'Layout with maximum width constraints',
              buttonText: 'View Example',
              onPressed: () => _showLayoutExample(
                context,
                AppLayoutType.constrained,
                'Constrained Layout',
              ),
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Layout Options'),
            SizedBox(height: 16.h),
            _buildLayoutCard(
              title: 'Centered Content',
              description: 'Layout with centered content',
              buttonText: 'View Example',
              onPressed: () => _showLayoutExample(
                context,
                AppLayoutType.standard,
                'Centered Content Layout',
                centerChild: true,
              ),
            ),
            SizedBox(height: 16.h),
            _buildLayoutCard(
              title: 'Custom Background',
              description: 'Layout with custom background color',
              buttonText: 'View Example',
              onPressed: () => _showLayoutExample(
                context,
                AppLayoutType.standard,
                'Custom Background Layout',
                backgroundColor: AppColors.primary.withOpacity(0.1),
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

  Widget _buildLayoutCard({
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return AppCard(
      type: CardType.elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextThemes.heading6(),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: AppTextThemes.bodyMedium(),
          ),
          SizedBox(height: 16.h),
          Button(
            text: buttonText,
            type: ButtonType.primary,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }

  void _showLayoutExample(
    BuildContext context,
    AppLayoutType layoutType,
    String title, {
    bool centerChild = false,
    Color? backgroundColor,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: Navbar(
            title: title,
            style: NavbarStyle.standard,
          ),
          body: AppLayout(
            type: layoutType,
            centerChild: centerChild,
            backgroundColor: backgroundColor,
            padding: EdgeInsets.all(16.w),
            child: _buildLayoutContent(layoutType),
          ),
        ),
      ),
    );
  }

  Widget _buildLayoutContent(AppLayoutType layoutType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This is a ${layoutType.toString().split('.').last} layout example',
          style: AppTextThemes.heading6(),
        ),
        SizedBox(height: 16.h),
        Text(
          'You can see how this layout behaves with different content and configurations.',
          style: AppTextThemes.bodyMedium(),
        ),
        SizedBox(height: 16.h),
        AppCard(
          type: CardType.elevated,
          child: Text(
            'Content inside a card within the layout',
            style: AppTextThemes.bodyMedium(),
          ),
        ),
        SizedBox(height: 16.h),
        if (layoutType == AppLayoutType.scroll) ...[
          for (int i = 1; i <= 20; i++) ...[
            AppCard(
              type: i % 2 == 0 ? CardType.standard : CardType.outlined,
              margin: EdgeInsets.only(bottom: 16.h),
              child: Text(
                'Scrollable content item #\$i',
                style: AppTextThemes.bodyMedium(),
              ),
            ),
          ],
        ],
        if (layoutType == AppLayoutType.constrained) ...[
          Text(
            'This layout has a maximum width constraint applied (usually used for web/tablet responsive layouts).',
            style: AppTextThemes.bodyMedium(),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'The content is constrained to a maximum width, which is especially useful for large screens.',
              style: AppTextThemes.bodyMedium(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}
