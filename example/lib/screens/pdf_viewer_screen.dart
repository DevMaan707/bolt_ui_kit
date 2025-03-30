import 'package:flutter/material.dart';
import 'package:bolt_ui_kit/components/navbar/navbar.dart';
import 'package:bolt_ui_kit/bolt_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PdfViewerScreen extends StatelessWidget {
  const PdfViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(
        title: 'PDF Viewer',
        style: NavbarStyle.standard,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PDF Viewer Examples',
              style: AppTextThemes.heading4(),
            ),
            SizedBox(height: 8.h),
            Text(
              'View PDF files with various configurations.',
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
        // Sample PDF from Assets
        AppCard(
          type: CardType.elevated,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'View Sample PDF',
                style: AppTextThemes.heading6(),
              ),
              SizedBox(height: 8.h),
              Text(
                'Open a sample PDF from assets.',
                style: AppTextThemes.bodyMedium(),
              ),
              SizedBox(height: 16.h),
              Button(
                text: 'Open Sample PDF',
                type: ButtonType.primary,
                icon: Icons.picture_as_pdf,
                onPressed: () {
                  BoltPDFViewer.openPdf(
                    context: context,
                    assetPath: 'assets/1.pdf',
                    source: PDFViewSource.asset,
                    title: 'Sample PDF',
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Network PDF
        AppCard(
          type: CardType.elevated,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'View PDF from URL',
                style: AppTextThemes.heading6(),
              ),
              SizedBox(height: 8.h),
              Text(
                'Open a PDF from a network URL.',
                style: AppTextThemes.bodyMedium(),
              ),
              SizedBox(height: 16.h),
              Button(
                text: 'Open URL PDF',
                type: ButtonType.primary,
                icon: Icons.cloud_download,
                onPressed: () {
                  BoltPDFViewer.openPdf(
                    context: context,
                    url:
                        'https://www.uou.ac.in/sites/default/files/slm/BHM-503T.pdf',
                    source: PDFViewSource.network,
                    title: 'Network PDF',
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // PDF Dialog
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
                'Open PDF in a dialog overlay.',
                style: AppTextThemes.bodyMedium(),
              ),
              SizedBox(height: 16.h),
              Button(
                text: 'Show PDF Dialog',
                type: ButtonType.primary,
                icon: Icons.open_in_new,
                onPressed: () {
                  BoltPDFViewer.showPdfDialog(
                    context: context,
                    assetPath: 'assets/sample.pdf',
                    source: PDFViewSource.asset,
                    title: 'PDF Dialog',
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
