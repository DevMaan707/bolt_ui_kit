import 'package:bolt_ui_kit/widgets/slides_viewer/slides_viewer.dart';
import 'package:flutter/material.dart';
import 'package:bolt_ui_kit/components/navbar/navbar.dart';
import 'package:bolt_ui_kit/bolt_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SlidesViewerScreen extends StatelessWidget {
  const SlidesViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(
        title: 'Slides Viewer',
        style: NavbarStyle.standard,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Slides Viewer Examples',
              style: AppTextThemes.heading4(),
            ),
            SizedBox(height: 8.h),
            Text(
              'View presentations in various formats.',
              style: AppTextThemes.bodyMedium(),
            ),
            SizedBox(height: 24.h),
            _buildViewerOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildViewerOptions(BuildContext context) {
    return Column(
      children: [
        // Google Slides
        AppCard(
          type: CardType.elevated,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Google Slides',
                style: AppTextThemes.heading6(),
              ),
              SizedBox(height: 8.h),
              Text(
                'View a Google Slides presentation.',
                style: AppTextThemes.bodyMedium(),
              ),
              SizedBox(height: 16.h),
              Button(
                text: 'Open Google Slides',
                type: ButtonType.primary,
                icon: Icons.slideshow,
                onPressed: () {
                  BoltSlidesViewer.openSlidesViewer(
                    context: context,
                    googleSlidesId: 'YOUR_GOOGLE_SLIDES_ID',
                    sourceType: SlidesSourceType.googleSlides,
                    title: 'Google Slides Example',
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // PowerPoint (PPTX)
        AppCard(
          type: CardType.elevated,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PowerPoint Presentation',
                style: AppTextThemes.heading6(),
              ),
              SizedBox(height: 8.h),
              Text(
                'View a PPTX presentation.',
                style: AppTextThemes.bodyMedium(),
              ),
              SizedBox(height: 16.h),
              Button(
                text: 'Open PowerPoint',
                type: ButtonType.primary,
                icon: Icons.present_to_all,
                onPressed: () {
                  BoltSlidesViewer.openSlidesViewer(
                    context: context,
                    url: 'https://example.com/presentation.pptx',
                    sourceType: SlidesSourceType.pptx,
                    title: 'PowerPoint Example',
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Slides Dialog
        AppCard(
          type: CardType.elevated,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'View as Dialog',
                style: AppTextThemes.heading6(),
              ),
              SizedBox(height: 8.h),
              Text(
                'Open presentation in a dialog overlay.',
                style: AppTextThemes.bodyMedium(),
              ),
              SizedBox(height: 16.h),
              Button(
                text: 'Show Slides Dialog',
                type: ButtonType.primary,
                icon: Icons.open_in_new,
                onPressed: () {
                  BoltSlidesViewer.showSlidesDialog(
                    context: context,
                    googleSlidesId: 'YOUR_GOOGLE_SLIDES_ID',
                    sourceType: SlidesSourceType.googleSlides,
                    title: 'Presentation Dialog',
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
