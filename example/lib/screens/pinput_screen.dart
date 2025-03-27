import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bolt_ui_kit/components/navbar/navbar.dart';
import 'package:bolt_ui_kit/bolt_kit.dart';
import 'package:bolt_ui_kit/widgets/inputs/pinput.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PinInputScreen extends StatefulWidget {
  const PinInputScreen({super.key});

  @override
  State<PinInputScreen> createState() => _PinInputScreenState();
}

class _PinInputScreenState extends State<PinInputScreen> {
  String _inputPin = '';
  String? _errorText;
  PinInputTheme _currentTheme = PinInputTheme.outlined;
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(
        title: 'PIN Input',
        style: NavbarStyle.standard,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 32.h),
            _buildMainDemo(),
            SizedBox(height: 32.h),
            _buildOptions(),
            SizedBox(height: 32.h),
            _buildThemeExamples(),
            SizedBox(height: 32.h),
            _buildFormatExamples(),
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
          'PIN Input Component',
          style: AppTextThemes.heading4(),
        ),
        SizedBox(height: 8.h),
        Text(
          'A customizable PIN input for verification codes, passwords, and more.',
          style: AppTextThemes.bodyMedium(),
        ),
      ],
    );
  }

  Future<void> _showPinDialog() async {
    final result = await showPinInputDialog(
      context: context,
      title: 'Verification Code',
      subtitle: 'Enter the 6-digit code sent to your phone',
      length: 4,
      theme: _currentTheme,
      obscureText: _obscureText,
      validator: (pin) {
        if (pin != '123456') {
          return 'Invalid verification code';
        }
        return null;
      },
    );

    if (result != null) {
      Toast.show(
        message: 'Verified successfully!',
        type: ToastType.success,
      );
    } else {
      Toast.show(
        message: 'Verification cancelled',
        type: ToastType.info,
      );
    }
  }

  Widget _buildMainDemo() {
    return AppCard(
      type: CardType.elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Enter PIN Code',
            style: AppTextThemes.heading5(),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          BoltPinInput(
            length: 4,
            theme: _currentTheme,
            obscureText: _obscureText,
            errorText: _errorText,
            onChanged: (pin) {
              setState(() {
                _inputPin = pin;
                if (_errorText != null) {
                  _errorText = null;
                }
              });
            },
            onCompleted: (pin) {
              Toast.show(
                message: 'PIN entered: $pin',
                type: ToastType.success,
              );
              // Here you could validate the PIN
              if (pin == '123456') {
                setState(() {
                  _errorText = null;
                });
              } else {
                setState(() {
                  _errorText = 'Invalid PIN code';
                });
              }
            },
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                text: 'Verify PIN',
                type: ButtonType.primary,
                onPressed: _inputPin.length == 6
                    ? () {
                        if (_inputPin == '123456') {
                          Toast.show(
                            message: 'PIN verified successfully!',
                            type: ToastType.success,
                          );
                          setState(() {
                            _errorText = null;
                          });
                        } else {
                          setState(() {
                            _errorText = 'Invalid PIN code';
                          });
                          Toast.show(
                            message: 'Invalid PIN code',
                            type: ToastType.error,
                          );
                        }
                      }
                    : null,
              ),
              SizedBox(width: 12.w),
              Button(
                text: 'Show Dialog',
                type: ButtonType.outlined,
                icon: Icons.open_in_new,
                onPressed: _showPinDialog,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Hint: The correct PIN is 123456',
            style: AppTextThemes.caption(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    return AppCard(
      type: CardType.outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Options',
            style: AppTextThemes.heading6(),
          ),
          SizedBox(height: 16.h),

          // PIN Theme Selector
          Row(
            children: [
              Expanded(
                child: Text('PIN Theme:', style: AppTextThemes.bodyMedium()),
              ),
              DropdownButton<PinInputTheme>(
                value: _currentTheme,
                onChanged: (PinInputTheme? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _currentTheme = newValue;
                    });
                  }
                },
                items: PinInputTheme.values
                    .map<DropdownMenuItem<PinInputTheme>>(
                        (PinInputTheme value) {
                  return DropdownMenuItem<PinInputTheme>(
                    value: value,
                    child: Text(value.toString().split('.').last),
                  );
                }).toList(),
              ),
            ],
          ),

          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Text('Obscure Text:', style: AppTextThemes.bodyMedium()),
              ),
              Switch(
                value: _obscureText,
                onChanged: (value) {
                  setState(() {
                    _obscureText = value;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme Examples',
          style: AppTextThemes.heading5(),
        ),
        SizedBox(height: 16.h),

        // Outlined Theme
        _buildThemeExample(
          'Outlined',
          BoltPinInput(
            length: 4,
            theme: PinInputTheme.outlined,
            onCompleted: (_) {},
          ),
        ),

        SizedBox(height: 20.h),

        // Filled Theme
        _buildThemeExample(
          'Filled',
          BoltPinInput(
            length: 4,
            theme: PinInputTheme.filled,
            onCompleted: (_) {},
          ),
        ),

        SizedBox(height: 20.h),

        // Underlined Theme
        _buildThemeExample(
          'Underlined',
          BoltPinInput(
            length: 4,
            theme: PinInputTheme.underlined,
            onCompleted: (_) {},
          ),
        ),

        SizedBox(height: 20.h),

        // Rounded Theme
        _buildThemeExample(
          'Rounded',
          BoltPinInput(
            length: 4,
            theme: PinInputTheme.rounded,
            width: 45.w,
            height: 45.w,
            onCompleted: (_) {},
          ),
        ),

        SizedBox(height: 20.h),

        // Custom Theme
        _buildThemeExample(
          'Custom',
          BoltPinInput(
            length: 4,
            theme: PinInputTheme.custom,
            activeColor: Colors.deepPurple,
            fontSize: 20.sp,
            pinDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.3),
                  Colors.blue.withOpacity(0.3)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.deepPurple, width: 1.w),
            ),
            onCompleted: (_) {},
          ),
        ),
      ],
    );
  }

  Widget _buildFormatExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Format Examples',
          style: AppTextThemes.heading5(),
        ),
        SizedBox(height: 16.h),

        // Numbers only (default)
        _buildFormatExample(
          'Numbers Only',
          BoltPinInput(
            length: 4,
            theme: PinInputTheme.filled,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onCompleted: (_) {},
          ),
        ),

        SizedBox(height: 20.h),

        // Alphabetic (uppercase)
        _buildFormatExample(
          'Letters Only (Uppercase)',
          BoltPinInput(
            length: 4,
            theme: PinInputTheme.filled,
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
              UpperCaseTextFormatter(),
            ],
            onCompleted: (_) {},
          ),
        ),

        SizedBox(height: 20.h),

        // Alphanumeric
        _buildFormatExample(
          'Alphanumeric',
          BoltPinInput(
            length: 4,
            theme: PinInputTheme.outlined,
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
            ],
            onCompleted: (_) {},
          ),
        ),

        SizedBox(height: 20.h),

        // Dialog Example Button
        AppCard(
          type: CardType.outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PIN Input Dialog',
                style: AppTextThemes.bodyLarge(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                'Show a customizable PIN input dialog for verification flows.',
                style: AppTextThemes.bodyMedium(),
              ),
              SizedBox(height: 16.h),
              Center(
                child: Button(
                  text: 'Open PIN Dialog',
                  type: ButtonType.primary,
                  icon: Icons.pin,
                  onPressed: _showPinDialog,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeExample(String title, Widget pinInput) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextThemes.bodyMedium(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        Center(child: pinInput),
      ],
    );
  }

  Widget _buildFormatExample(String title, Widget pinInput) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextThemes.bodyMedium(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        Center(child: pinInput),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
