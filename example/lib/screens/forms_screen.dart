import 'package:flutter/material.dart';
import 'package:flutter_kit/components/navbar/navbar.dart';
import 'package:flutter_kit/flutter_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormsScreen extends StatefulWidget {
  @override
  _FormsScreenState createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _agreeToTerms = false;
  String? _selectedGender;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: 'Form Inputs',
        style: NavbarStyle.standard,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Input Types'),
            SizedBox(height: 16.h),
            AppForm(
              formKey: _formKey,
              spacing: 20.h,
              onSubmit: _handleSubmit,
              submitLabel: 'Submit Form',
              children: [
                AppInput(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  prefixIcon: Icons.person,
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                AppInput(
                  label: 'Email Address',
                  hint: 'Enter your email address',
                  prefixIcon: Icons.email,
                  type: InputType.email,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                AppInput(
                  label: 'Password',
                  hint: 'Enter a strong password',
                  prefixIcon: Icons.lock,
                  type: InputType.password,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                AppInput(
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  prefixIcon: Icons.phone,
                  type: InputType.phone,
                  controller: _phoneController,
                ),
                _buildGenderSelector(),
                AppInput(
                  label: 'Bio',
                  hint: 'Tell us about yourself',
                  type: InputType.multiline,
                  maxLines: 3,
                ),
                _buildCheckbox(),
              ],
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Individual Inputs'),
            SizedBox(height: 16.h),
            Text(
              'Search Input',
              style: AppTextThemes.bodyMedium(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            AppInput(
              hint: 'Search...',
              prefixIcon: Icons.search,
              type: InputType.search,
              suffixIcon: Icons.clear,
              suffixIconOnPressed: () {
                // Clear search functionality would go here
              },
            ),
            SizedBox(height: 16.h),
            Text(
              'Disabled Input',
              style: AppTextThemes.bodyMedium(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            AppInput(
              label: 'Disabled Input',
              hint: 'This input is disabled',
              enabled: false,
              initialValue: 'You cannot edit this field',
            ),
            SizedBox(height: 16.h),
            Text(
              'Error State',
              style: AppTextThemes.bodyMedium(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            AppInput(
              label: 'Error Example',
              hint: 'This input has an error',
              initialValue: 'Invalid input',
              errorText: 'This field has an error',
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

  Widget _buildCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (value) {
            setState(() {
              _agreeToTerms = value ?? false;
            });
          },
          activeColor: AppColors.primary,
        ),
        Expanded(
          child: Text(
            'I agree to the Terms of Service and Privacy Policy',
            style: AppTextThemes.bodySmall(),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: AppTextThemes.bodyMedium(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text('Male'),
                value: 'male',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('Female'),
                value: 'female',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // All validations passed
      Toast.show(
        message: 'Form submitted successfully!',
        type: ToastType.success,
      );
    }
  }
}
