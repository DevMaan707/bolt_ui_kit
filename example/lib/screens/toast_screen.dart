import 'package:flutter/material.dart';
import 'package:flutter_kit/components/navbar/navbar.dart';
import 'package:flutter_kit/flutter_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToastScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: 'Toast Notifications',
        style: NavbarStyle.standard,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Toast Types'),
            SizedBox(height: 16.h),
            _toastButton(
              label: 'Success Toast',
              onPressed: () => _showToast(ToastType.success),
              color: Colors.green,
              icon: Icons.check_circle,
            ),
            SizedBox(height: 16.h),
            _toastButton(
              label: 'Error Toast',
              onPressed: () => _showToast(ToastType.error),
              color: Colors.red,
              icon: Icons.error,
            ),
            SizedBox(height: 16.h),
            _toastButton(
              label: 'Info Toast',
              onPressed: () => _showToast(ToastType.info),
              color: Colors.blue,
              icon: Icons.info,
            ),
            SizedBox(height: 16.h),
            _toastButton(
              label: 'Warning Toast',
              onPressed: () => _showToast(ToastType.warning),
              color: Colors.orange,
              icon: Icons.warning,
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Toast Options'),
            SizedBox(height: 16.h),
            _toastButton(
              label: 'With Custom Title',
              onPressed: () => Toast.show(
                message: 'This toast has a custom title',
                type: ToastType.info,
                title: 'Custom Title',
              ),
              color: Colors.purple,
              icon: Icons.title,
            ),
            SizedBox(height: 16.h),
            _toastButton(
              label: 'Long Duration',
              onPressed: () => Toast.show(
                message: 'This toast will stay for 5 seconds',
                type: ToastType.info,
                duration: Duration(seconds: 5),
              ),
              color: Colors.teal,
              icon: Icons.timer,
            ),
            SizedBox(height: 16.h),
            _toastButton(
              label: 'Not Dismissible',
              onPressed: () => Toast.show(
                message: 'This toast cannot be dismissed by tapping',
                type: ToastType.warning,
                dismissible: false,
              ),
              color: Colors.amber[700]!,
              icon: Icons.not_interested,
            ),
            SizedBox(height: 16.h),
            _toastButton(
              label: 'Top Position',
              onPressed: () => Toast.show(
                message: 'This toast appears at the top',
                type: ToastType.info,
                position: Alignment.topCenter,
              ),
              color: Colors.indigo,
              icon: Icons.arrow_upward,
            ),
            SizedBox(height: 16.h),
            _toastButton(
              label: 'With Callback',
              onPressed: () => Toast.show(
                message: 'Tap this toast to trigger a callback',
                type: ToastType.success,
                onTap: () {
                  // Show another toast when this one is tapped
                  Toast.show(
                    message: 'Toast was tapped!',
                    type: ToastType.info,
                  );
                },
              ),
              color: Colors.deepPurple,
              icon: Icons.touch_app,
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

  Widget _toastButton({
    required String label,
    required VoidCallback onPressed,
    required Color color,
    required IconData icon,
  }) {
    return Button(
      text: label,
      type: ButtonType.custom,
      icon: icon,
      backgroundColor: color,
      onPressed: onPressed,
      width: double.infinity,
    );
  }

  void _showToast(ToastType type) {
    String message;
    switch (type) {
      case ToastType.success:
        message = 'Operation completed successfully!';
        break;
      case ToastType.error:
        message = 'An error occurred. Please try again.';
        break;
      case ToastType.info:
        message = 'Here is some useful information for you.';
        break;
      case ToastType.warning:
        message = 'Warning: This action cannot be undone.';
        break;
    }

    Toast.show(
      message: message,
      type: type,
    );
  }
}
