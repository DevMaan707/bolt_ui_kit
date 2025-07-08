import 'dart:io';

import 'package:bolt_ui_kit/components/navbar/navbar.dart';
import 'package:bolt_ui_kit/widgets/charts/chart.dart';
import 'package:bolt_ui_kit/widgets/slides_viewer/slides_viewer.dart';
import 'package:flutter/material.dart';
import 'package:bolt_ui_kit/bolt_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BoltKit.initialize(
    primaryColor: const Color(0xFF6200EE),
    accentColor: const Color(0xFF03DAC5),
    fontFamily: 'Poppins',
  );

  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BoltKit.builder(
      builder: () => GetMaterialApp(
        title: 'Flutter Kit Demo',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}

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
        'title': 'PIN Input',
        'description': 'Verification code inputs',
        'icon': Icons.pin,
        'screen': const PinInputScreen(),
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
        'screen': const PickersScreen(),
      },
      {
        'title': 'Charts',
        'description': 'Data visualization components',
        'icon': Icons.pie_chart,
        'screen': const ChartsScreen(),
      },
      {
        'title': 'PDF Viewer',
        'description': 'View PDF documents',
        'icon': Icons.picture_as_pdf,
        'screen': const PdfViewerScreen(),
      },
      {
        'title': 'Slides Viewer',
        'description': 'View presentations',
        'icon': Icons.slideshow,
        'screen': const SlidesViewerScreen(),
      },
      {
        'title': 'Layouts',
        'description': 'Layout components and patterns',
        'icon': Icons.dashboard,
        'screen': const LayoutsScreen(),
      },
      {
        'title': 'Toast Notifications',
        'description': 'In-app notification messages',
        'icon': Icons.notifications,
        'screen': const ToastScreen(),
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
        'screen': const ThemeScreen(),
      },
      {
        'title': 'Glass Morphism',
        'description': 'Glass effect containers and overlays',
        'icon': Icons.blur_on,
        'screen': const GlassMorphismScreen(),
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

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(
        title: 'Charts',
        style: NavbarStyle.standard,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Pie Chart Example'),
            SizedBox(height: 16.h),
            AppCard(
              child: SizedBox(
                height: 400.h,
                child: AppChart(
                  type: AppChartType.pie,
                  title: 'Revenue By Product',
                  data: _getSampleData(),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Bar Chart Example'),
            SizedBox(height: 16.h),
            AppCard(
              child: SizedBox(
                height: 400.h,
                child: AppChart(
                  type: AppChartType.bar,
                  title: 'Monthly Sales',
                  data: _getMonthlySalesData(),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Donut Chart Example'),
            SizedBox(height: 16.h),
            AppCard(
              child: SizedBox(
                height: 400.h,
                child: AppChart(
                  type: AppChartType.donut,
                  title: 'Traffic Sources',
                  data: _getTrafficSourcesData(),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Line Chart Example'),
            SizedBox(height: 16.h),
            AppCard(
              child: SizedBox(
                height: 400.h,
                child: AppChart(
                  type: AppChartType.line,
                  title: 'User Growth',
                  data: _getUserGrowthData(),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            _buildChartNote(),
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

  List<AppChartData> _getSampleData() {
    return [
      AppChartData(label: 'Product A', value: 35),
      AppChartData(label: 'Product B', value: 25),
      AppChartData(label: 'Product C', value: 20),
      AppChartData(label: 'Product D', value: 15),
      AppChartData(label: 'Product E', value: 5),
    ];
  }

  List<AppChartData> _getMonthlySalesData() {
    return [
      AppChartData(label: 'Jan', value: 12),
      AppChartData(label: 'Feb', value: 17),
      AppChartData(label: 'Mar', value: 22),
      AppChartData(label: 'Apr', value: 19),
      AppChartData(label: 'May', value: 25),
      AppChartData(label: 'Jun', value: 32),
    ];
  }

  List<AppChartData> _getTrafficSourcesData() {
    return [
      AppChartData(label: 'Direct', value: 30),
      AppChartData(label: 'Organic', value: 25),
      AppChartData(label: 'Social', value: 20),
      AppChartData(label: 'Referral', value: 15),
      AppChartData(label: 'Email', value: 10),
    ];
  }

  List<AppChartData> _getUserGrowthData() {
    return [
      AppChartData(label: 'Jan', value: 1000),
      AppChartData(label: 'Feb', value: 1500),
      AppChartData(label: 'Mar', value: 2300),
      AppChartData(label: 'Apr', value: 3100),
      AppChartData(label: 'May', value: 4200),
      AppChartData(label: 'Jun', value: 5800),
    ];
  }

  Widget _buildChartNote() {
    return AppCard(
      type: CardType.outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Note About Charts',
            style: AppTextThemes.heading6(),
          ),
          SizedBox(height: 8.h),
          Text(
            'The charts shown here are placeholder implementations. In a real application, you would integrate a charting library like fl_chart, charts_flutter, or syncfusion_flutter_charts for interactive data visualization.',
            style: AppTextThemes.bodyMedium(),
          ),
        ],
      ),
    );
  }
}

class FormsScreen extends StatefulWidget {
  const FormsScreen({super.key});

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

class LayoutsScreen extends StatelessWidget {
  const LayoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(
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
                'Scrollable content item #$i',
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

class PickersScreen extends StatefulWidget {
  const PickersScreen({super.key});

  @override
  _PickersScreenState createState() => _PickersScreenState();
}

class _PickersScreenState extends State<PickersScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTimeRange? _selectedDateRange;
  List<DateTime>? _selectedMultipleDates;
  Duration? _selectedDuration;
  File? _selectedImage;
  File? _selectedFile;
  String? _scannedQRCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(
        title: 'Pickers',
        style: NavbarStyle.standard,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Date & Time Pickers'),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildPickerCard(
                    title: 'Date Picker',
                    value: _selectedDate != null
                        ? DatePickerUtil.formatDate(_selectedDate!)
                        : 'Select Date',
                    icon: Icons.calendar_today,
                    onTap: _pickDate,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildPickerCard(
                    title: 'Time Picker',
                    value: _selectedTime != null
                        ? TimePickerUtil.formatTimeOfDay(_selectedTime!)
                        : 'Select Time',
                    icon: Icons.access_time,
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildPickerCard(
                    title: 'Date Range',
                    value: _selectedDateRange != null
                        ? DatePickerUtil.formatDateRange(_selectedDateRange!)
                        : 'Select Range',
                    icon: Icons.date_range,
                    onTap: _pickDateRange,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildPickerCard(
                    title: 'Duration',
                    value: _selectedDuration != null
                        ? TimePickerUtil.formatDuration(_selectedDuration!)
                        : 'Select Duration',
                    icon: Icons.timer,
                    onTap: _pickDuration,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildPickerCard(
              title: 'Multiple Dates',
              value: _selectedMultipleDates != null
                  ? '${_selectedMultipleDates!.length} dates selected'
                  : 'Select Multiple Dates',
              icon: Icons.calendar_month,
              onTap: _pickMultipleDates,
            ),
            SizedBox(height: 32.h),
            _sectionTitle('File Pickers'),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildPickerCard(
                    title: 'Image Picker',
                    value: _selectedImage != null
                        ? 'Image selected'
                        : 'Select Image',
                    icon: Icons.image,
                    onTap: _pickImage,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildPickerCard(
                    title: 'File Picker',
                    value:
                        _selectedFile != null ? 'File selected' : 'Select File',
                    icon: Icons.file_open,
                    onTap: _pickFile,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Scan & Capture'),
            SizedBox(height: 16.h),
            _buildPickerCard(
              title: 'QR Scanner',
              value: _scannedQRCode ?? 'Scan QR Code',
              icon: Icons.qr_code_scanner,
              onTap: _scanQRCode,
            ),
            SizedBox(height: 32.h),
            if (_selectedImage != null) ...[
              _sectionTitle('Selected Image'),
              SizedBox(height: 16.h),
              Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Button(
                text: 'Clear Image',
                type: ButtonType.outlined,
                icon: Icons.delete,
                onPressed: () {
                  setState(() {
                    _selectedImage = null;
                  });
                },
              ),
              SizedBox(height: 32.h),
            ],
            AppCard(
              type: CardType.outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Pickers',
                    style: AppTextThemes.heading6(),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'The pickers use the app\'s theme colors and typography for a consistent look and feel. In real usage, you can customize colors, text styles, and other properties as needed.',
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

  Widget _buildPickerCard({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return AppCard(
      type: CardType.elevated,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                title,
                style: AppTextThemes.bodyMedium(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: AppTextThemes.bodyMedium(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? result = await DatePickerUtil.showCustomDatePicker(
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select Date',
      confirmText: 'Choose',
      cancelText: 'Cancel',
    );

    if (result != null) {
      setState(() {
        _selectedDate = result;
      });
      Toast.show(
        message: 'Date selected: ${DatePickerUtil.formatDate(result)}',
        type: ToastType.success,
      );
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? result = await TimePickerUtil.showCustomTimePicker(
      initialTime: _selectedTime ?? TimeOfDay.now(),
      helpText: 'Select Time',
      confirmText: 'Choose',
      cancelText: 'Cancel',
    );

    if (result != null) {
      setState(() {
        _selectedTime = result;
      });
      Toast.show(
        message: 'Time selected: ${TimePickerUtil.formatTimeOfDay(result)}',
        type: ToastType.success,
      );
    }
  }

  Future<void> _pickDateRange() async {
    final DateTimeRange? result =
        await DatePickerUtil.showCustomDateRangePicker(
      initialDateRange: _selectedDateRange,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select Date Range',
      confirmText: 'Choose',
      cancelText: 'Cancel',
    );

    if (result != null) {
      setState(() {
        _selectedDateRange = result;
      });
      Toast.show(
        message:
            'Date range selected: ${DatePickerUtil.formatDateRange(result)}',
        type: ToastType.success,
      );
    }
  }

  Future<void> _pickMultipleDates() async {
    final result = await CalendarPickerUtil.showCalendarPicker(
      mode: CalendarPickerMode.multi,
      initialSelectedDates: _selectedMultipleDates,
      title: 'Select Multiple Dates',
      confirmButtonText: 'Choose',
      cancelButtonText: 'Cancel',
      primaryColor: AppColors.primary,
      selectedColor: AppColors.primary,
    );

    if (result?.selectedDates != null) {
      setState(() {
        _selectedMultipleDates = result!.selectedDates;
      });
      Toast.show(
        message: '${result!.selectedDates!.length} dates selected',
        type: ToastType.success,
      );
    }
  }

  Future<void> _pickDuration() async {
    final Duration? result = await TimePickerUtil.showDurationPicker(
      initialDuration: _selectedDuration ?? const Duration(minutes: 30),
      maxDuration: const Duration(hours: 10),
      primaryColor: AppColors.primary,
      backgroundColor: Theme.of(context).cardColor,
      textColor: Theme.of(context).textTheme.bodyLarge?.color,
    );

    if (result != null) {
      setState(() {
        _selectedDuration = result;
      });
      Toast.show(
        message: 'Duration selected: ${TimePickerUtil.formatDuration(result)}',
        type: ToastType.success,
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final File? result = await ImagePickerUtil().showCustomImagePicker(
        enableCrop: true,
        primaryColor: AppColors.primary,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: 'Select Image',
        cropSettings: CropSettings.square(
          primaryColor: AppColors.primary,
        ),
      );

      if (result != null) {
        setState(() {
          _selectedImage = result;
        });
        Toast.show(
          message: 'Image selected successfully',
          type: ToastType.success,
        );
      }
    } catch (e) {
      Toast.show(
        message: 'Failed to pick image: $e',
        type: ToastType.error,
      );
    }
  }

  Future<void> _pickFile() async {
    try {
      final File? result = await FilePickerUtil().showCustomFilePicker(
        context: context,
        title: 'Select File',
        primaryColor: AppColors.primary,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      );

      if (result != null) {
        setState(() {
          _selectedFile = result;
        });
        Toast.show(
          message: 'File selected: ${result.path.split('/').last}',
          type: ToastType.success,
        );
      }
    } catch (e) {
      Toast.show(
        message: 'Failed to pick file: $e',
        type: ToastType.error,
      );
    }
  }

  Future<void> _scanQRCode() async {
    try {
      final String? result = await QRScannerUtil().scanQR(
        title: 'Scan QR Code',
        scanInstructions: 'Position the QR code within the frame to scan',
        primaryColor: AppColors.primary,
        theme: ScannerTheme(
          primaryColor: AppColors.primary,
          scanAreaWidth: 250,
          scanAreaHeight: 250,
        ),
      );

      if (result != null) {
        setState(() {
          _scannedQRCode = result;
        });
        Toast.show(
          message: 'QR code scanned: $result',
          type: ToastType.success,
        );
      }
    } catch (e) {
      Toast.show(
        message: 'Failed to scan QR code: $e',
        type: ToastType.error,
      );
    }
  }
}

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

class ToastScreen extends StatelessWidget {
  const ToastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(
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
                duration: const Duration(seconds: 5),
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

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  _ApiScreenState createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  final ApiService _apiService =
      ApiService('https://jsonplaceholder.typicode.com');
  bool _isLoading = false;
  List<dynamic> _posts = [];
  Map<String, dynamic>? _selectedPost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(
        title: 'API Integration',
        style: NavbarStyle.standard,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              color: AppColors.primary.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'API Demo',
                    style: AppTextThemes.heading5(),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'This demo uses JSONPlaceholder API to showcase API integration.',
                    style: AppTextThemes.bodyMedium(),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: Button(
                          text: 'GET Posts',
                          type: ButtonType.primary,
                          icon: Icons.download,
                          isLoading: _isLoading,
                          onPressed: _fetchPosts,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Button(
                          text: 'Create Post',
                          type: ButtonType.outlined,
                          icon: Icons.add,
                          onPressed: _createPost,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_posts.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  'Posts (${_posts.length})',
                  style: AppTextThemes.heading6(),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _posts.length.clamp(0, 10),
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return ListTile(
                    title: Text(
                      post['title'] ?? 'No title',
                      style:
                          AppTextThemes.bodyMedium(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      post['body'] ?? 'No content',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _viewPostDetails(post),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
                  );
                },
              ),
            ],
            if (_selectedPost != null) ...[
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: AppCard(
                  type: CardType.elevated,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Post',
                        style: AppTextThemes.heading6(),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _selectedPost!['title'] ?? 'No title',
                        style: AppTextThemes.bodyLarge(
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _selectedPost!['body'] ?? 'No content',
                        style: AppTextThemes.bodyMedium(),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: Button(
                              text: 'Update',
                              type: ButtonType.outlined,
                              icon: Icons.edit,
                              onPressed: () =>
                                  _updatePost(_selectedPost!['id']),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Button(
                              text: 'Delete',
                              type: ButtonType.outlined,
                              backgroundColor: Colors.red.withOpacity(0.1),
                              textColor: Colors.red,
                              icon: Icons.delete,
                              onPressed: () =>
                                  _deletePost(_selectedPost!['id']),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchPosts() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _apiService.get(
        endpoint: '/posts',
      );

      setState(() {
        _posts = response as List<dynamic>;
        _isLoading = false;
      });

      Toast.show(
        message: 'Successfully loaded ${_posts.length} posts',
        type: ToastType.success,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      Toast.show(
        message: 'Failed to load posts',
        type: ToastType.error,
      );
    }
  }

  Future<void> _createPost() async {
    try {
      final response = await _apiService.post(
        endpoint: '/posts',
        body: {
          'title': 'New Post',
          'body': 'This is a new post created from the Flutter Kit Demo app.',
          'userId': 1,
        },
      );

      Toast.show(
        message: 'Post created with ID: ${response['id']}',
        type: ToastType.success,
      );
      setState(() {
        _posts.insert(0, response);
      });
    } catch (e) {
      Toast.show(
        message: 'Failed to create post',
        type: ToastType.error,
      );
    }
  }

  Future<void> _updatePost(int id) async {
    try {
      final response = await _apiService.put(
        endpoint: '/posts/$id',
        body: {
          'id': id,
          'title': 'Updated Post',
          'body':
              'This post has been updated using the Flutter Kit API service.',
          'userId': 1,
        },
      );

      Toast.show(
        message: 'Post updated successfully',
        type: ToastType.success,
      );
      setState(() {
        _selectedPost = response;
      });
    } catch (e) {
      Toast.show(
        message: 'Failed to update post',
        type: ToastType.error,
      );
    }
  }

  Future<void> _deletePost(int id) async {
    try {
      await _apiService.delete(
        endpoint: '/posts/$id',
      );

      Toast.show(
        message: 'Post deleted successfully',
        type: ToastType.success,
      );
      setState(() {
        _posts.removeWhere((post) => post['id'] == id);
        _selectedPost = null;
      });
    } catch (e) {
      Toast.show(
        message: 'Failed to delete post',
        type: ToastType.error,
      );
    }
  }

  void _viewPostDetails(Map<String, dynamic> post) {
    setState(() {
      _selectedPost = post;
    });
  }
}

class GlassMorphismScreen extends StatefulWidget {
  const GlassMorphismScreen({super.key});

  @override
  State<GlassMorphismScreen> createState() => _GlassMorphismScreenState();
}

class _GlassMorphismScreenState extends State<GlassMorphismScreen> {
  GlassType _selectedType = GlassType.frosted;
  GlassShape _selectedShape = GlassShape.roundedRectangle;
  double _blurIntensity = 10.0;
  double _backgroundOpacity = 0.2;
  double _borderOpacity = 0.2;
  bool _addShadow = true;
  Color _selectedColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          _buildBackgroundGradient(),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Custom glass app bar
                _buildGlassAppBar(context),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCustomizationControls(),
                        SizedBox(height: 24.h),
                        _buildLivePreview(),
                        SizedBox(height: 32.h),
                        _buildTypeExamples(),
                        SizedBox(height: 32.h),
                        _buildShapeExamples(),
                        SizedBox(height: 32.h),
                        _buildInteractiveExamples(),
                        SizedBox(height: 32.h),
                        _buildAdvancedExamples(),
                        SizedBox(height: 32.h),
                        _buildRealWorldExamples(),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.8),
            AppColors.accent.withOpacity(0.7),
            Colors.purple.withOpacity(0.6),
            Colors.pink.withOpacity(0.5),
            Colors.orange.withOpacity(0.4),
          ],
          stops: const [0.0, 0.2, 0.4, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildGlassAppBar(BuildContext context) {
    return GlassContainer.appBar(
      type: GlassType.crystal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Text(
                'Glass Morphism',
                style: AppTextThemes.heading6(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: Icon(Icons.info_outline, color: Colors.white),
              onPressed: () => _showInfoDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizationControls() {
    return GlassContainer.card(
      type: GlassType.frosted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customize Glass Effect',
            style: AppTextThemes.heading6(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),

          // Glass Type Selection
          Text(
            'Glass Type',
            style: AppTextThemes.bodyMedium(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: GlassType.values.map((type) {
              return GestureDetector(
                onTap: () => setState(() => _selectedType = type),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: _selectedType == type
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: _selectedType == type
                          ? Colors.white.withOpacity(0.6)
                          : Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    type.name,
                    style: AppTextThemes.bodySmall(
                      color: Colors.white,
                      fontWeight: _selectedType == type
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 20.h),

          // Blur Intensity Slider
          Text(
            'Blur Intensity: ${_blurIntensity.toStringAsFixed(1)}',
            style: AppTextThemes.bodyMedium(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Slider(
            value: _blurIntensity,
            min: 0.0,
            max: 30.0,
            divisions: 30,
            activeColor: Colors.white,
            inactiveColor: Colors.white.withOpacity(0.3),
            onChanged: (value) => setState(() => _blurIntensity = value),
          ),

          // Background Opacity Slider
          Text(
            'Background Opacity: ${(_backgroundOpacity * 100).toInt()}%',
            style: AppTextThemes.bodyMedium(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Slider(
            value: _backgroundOpacity,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            activeColor: Colors.white,
            inactiveColor: Colors.white.withOpacity(0.3),
            onChanged: (value) => setState(() => _backgroundOpacity = value),
          ),

          // Border Opacity Slider
          Text(
            'Border Opacity: ${(_borderOpacity * 100).toInt()}%',
            style: AppTextThemes.bodyMedium(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Slider(
            value: _borderOpacity,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            activeColor: Colors.white,
            inactiveColor: Colors.white.withOpacity(0.3),
            onChanged: (value) => setState(() => _borderOpacity = value),
          ),

          // Shadow Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Shadow',
                style: AppTextThemes.bodyMedium(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Switch(
                value: _addShadow,
                onChanged: (value) => setState(() => _addShadow = value),
                activeColor: Colors.white,
                activeTrackColor: Colors.white.withOpacity(0.5),
                inactiveThumbColor: Colors.white.withOpacity(0.7),
                inactiveTrackColor: Colors.white.withOpacity(0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLivePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live Preview',
          style: AppTextThemes.heading5(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Center(
          child: GlassContainer(
            type: _selectedType,
            shape: _selectedShape,
            blurIntensity: _blurIntensity,
            backgroundOpacity: _backgroundOpacity,
            borderOpacity: _borderOpacity,
            addShadow: _addShadow,
            backgroundColor: _selectedColor,
            width: 200.w,
            height: 150.h,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Glass Effect',
                    style: AppTextThemes.bodyLarge(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _selectedType.name,
                    style: AppTextThemes.bodySmall(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Glass Types',
          style: AppTextThemes.heading5(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.2,
          ),
          itemCount: GlassType.values.length,
          itemBuilder: (context, index) {
            final type = GlassType.values[index];
            return GlassContainer(
              type: type,
              onTap: () {
                setState(() => _selectedType = type);
                Toast.show(
                  message: '${type.name} glass selected',
                  type: ToastType.info,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getTypeIcon(type),
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    type.name,
                    style: AppTextThemes.bodyMedium(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildShapeExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Glass Shapes',
          style: AppTextThemes.heading5(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: GlassContainer(
                type: GlassType.crystal,
                shape: GlassShape.rectangle,
                height: 80.h,
                onTap: () =>
                    setState(() => _selectedShape = GlassShape.rectangle),
                child: Center(
                  child: Text(
                    'Rectangle',
                    style: AppTextThemes.bodyMedium(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GlassContainer(
                type: GlassType.crystal,
                shape: GlassShape.roundedRectangle,
                height: 80.h,
                radius: 20.r,
                onTap: () => setState(
                    () => _selectedShape = GlassShape.roundedRectangle),
                child: Center(
                  child: Text(
                    'Rounded',
                    style: AppTextThemes.bodyMedium(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            GlassContainer(
              type: GlassType.crystal,
              shape: GlassShape.circle,
              width: 80.w,
              height: 80.h,
              onTap: () => setState(() => _selectedShape = GlassShape.circle),
              child: Center(
                child: Text(
                  'Circle',
                  style: AppTextThemes.bodySmall(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractiveExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interactive Elements',
          style: AppTextThemes.heading5(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),

        // Glass Buttons
        Row(
          children: [
            Expanded(
              child: GlassContainer.button(
                type: GlassType.crystal,
                onTap: () => Toast.show(
                  message: 'Crystal button tapped!',
                  type: ToastType.success,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite, color: Colors.white, size: 16.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Like',
                      style: AppTextThemes.button(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GlassContainer.button(
                type: GlassType.vibrant,
                onTap: () => Toast.show(
                  message: 'Vibrant button tapped!',
                  type: ToastType.info,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.share, color: Colors.white, size: 16.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Share',
                      style: AppTextThemes.button(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Glass Card with content
        GlassContainer.card(
          type: GlassType.frosted,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: AppTextThemes.bodyLarge(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Software Developer',
                          style: AppTextThemes.bodySmall(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GlassContainer.button(
                    type: GlassType.minimal,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    onTap: () => Toast.show(
                      message: 'Follow button tapped!',
                      type: ToastType.success,
                    ),
                    child: Text(
                      'Follow',
                      style: AppTextThemes.bodySmall(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                'Building beautiful glass morphism effects with Flutter. The future of UI design is here! ✨',
                style: AppTextThemes.bodyMedium(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Advanced Examples',
          style: AppTextThemes.heading5(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),

        // Nested Glass Containers
        GlassContainer(
          type: GlassType.smoky,
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nested Glass Effects',
                style: AppTextThemes.bodyLarge(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              GlassContainer(
                type: GlassType.crystal,
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inner Glass Container',
                      style: AppTextThemes.bodyMedium(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Multiple layers create depth and visual interest.',
                      style: AppTextThemes.bodySmall(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Glass with Gradient Overlay
        GlassContainer(
          type: GlassType.custom,
          backgroundColor: Colors.transparent,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.withOpacity(0.3),
              Colors.blue.withOpacity(0.2),
              Colors.cyan.withOpacity(0.1),
            ],
          ),
          gradientOpacity: 0.8,
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.color_lens, color: Colors.white, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Gradient Glass',
                    style: AppTextThemes.bodyLarge(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Glass containers can have gradient overlays for more dynamic effects.',
                style: AppTextThemes.bodyMedium(color: Colors.white),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Custom Shaped Glass
        Row(
          children: [
            Expanded(
              child: GlassContainer(
                type: GlassType.crystal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
                padding: EdgeInsets.all(16.w),
                child: Text(
                  'Custom\nBorder Radius',
                  style: AppTextThemes.bodyMedium(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GlassContainer(
                type: GlassType.vibrant,
                transform: Matrix4.rotationZ(0.1),
                padding: EdgeInsets.all(16.w),
                child: Text(
                  'Rotated\nGlass',
                  style: AppTextThemes.bodyMedium(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRealWorldExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Real-World Applications',
          style: AppTextThemes.heading5(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),

        // Music Player Card
        GlassContainer.card(
          type: GlassType.frosted,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Glass Morphism Beat',
                          style: AppTextThemes.bodyMedium(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'UI Design Studio',
                          style: AppTextThemes.bodySmall(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGlassIconButton(Icons.skip_previous, () {}),
                  _buildGlassIconButton(Icons.play_arrow, () {}),
                  _buildGlassIconButton(Icons.skip_next, () {}),
                  _buildGlassIconButton(Icons.favorite_border, () {}),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Weather Card
        GlassContainer.card(
          type: GlassType.crystal,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'San Francisco',
                        style: AppTextThemes.bodyLarge(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Partly Cloudy',
                        style: AppTextThemes.bodySmall(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '72°',
                        style: AppTextThemes.heading4(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.wb_cloudy,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildWeatherStat('Humidity', '65%'),
                  _buildWeatherStat('Wind', '12 mph'),
                  _buildWeatherStat('UV Index', '3'),
                  _buildWeatherStat('Visibility', '10 mi'),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Navigation Card
        GlassContainer.card(
          type: GlassType.vibrant,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Glass Navigation',
                style: AppTextThemes.bodyLarge(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, 'Home', true),
                  _buildNavItem(Icons.search, 'Search', false),
                  _buildNavItem(Icons.favorite, 'Likes', false),
                  _buildNavItem(Icons.person, 'Profile', false),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlassIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildWeatherStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextThemes.bodyMedium(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextThemes.caption(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color:
                isActive ? Colors.white.withOpacity(0.3) : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextThemes.caption(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  IconData _getTypeIcon(GlassType type) {
    switch (type) {
      case GlassType.frosted:
        return Icons.blur_on;
      case GlassType.crystal:
        return Icons.diamond_outlined;
      case GlassType.smoky:
        return Icons.cloud;
      case GlassType.vibrant:
        return Icons.color_lens;
      case GlassType.minimal:
        return Icons.minimize;
      case GlassType.custom:
        return Icons.tune;
    }
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => Center(
        child: GlassContainer.dialog(
          width: 300.w,
          type: GlassType.frosted,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 32.sp,
              ),
              SizedBox(height: 16.h),
              Text(
                'Glass Morphism',
                style: AppTextThemes.heading5(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Glass morphism is a design trend that creates frosted glass effects with backdrop blur, transparency, and subtle borders.',
                style: AppTextThemes.bodyMedium(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GlassContainer.button(
                    type: GlassType.minimal,
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Got it',
                      style: AppTextThemes.button(color: Colors.white),
                    ),
                  ),
                  GlassContainer.button(
                    type: GlassType.crystal,
                    onTap: () {
                      Navigator.pop(context);
                      _showCodeExample(context);
                    },
                    child: Text(
                      'Show Code',
                      style: AppTextThemes.button(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCodeExample(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => Center(
        child: GlassContainer.dialog(
          width: 350.w,
          height: 500.h,
          type: GlassType.smoky,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Code Example',
                    style: AppTextThemes.heading6(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      '''GlassContainer(
                    type: GlassType.frosted,
                    shape: GlassShape.roundedRectangle,
                    blurIntensity: 15.0,
                    backgroundOpacity: 0.2,
                    borderOpacity: 0.3,
                    addShadow: true,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Glass Morphism',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Beautiful frosted glass effect',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Convenience constructors:
                  GlassContainer.card(
                    child: YourWidget(),
                  ),

                  GlassContainer.button(
                    onTap: () => print('Tapped!'),
                    child: Text('Glass Button'),
                  ),

                  GlassContainer.dialog(
                    child: YourDialogContent(),
                  ),''',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: 'monospace',
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Center(
                child: GlassContainer.button(
                  type: GlassType.crystal,
                  onTap: () {
                    // In a real app, you might copy to clipboard
                    Toast.show(
                      message: 'Code copied to clipboard!',
                      type: ToastType.success,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copy, color: Colors.white, size: 16.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Copy Code',
                        style: AppTextThemes.button(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension to capitalize first letter
extension StringExtension on String {
  String? get capitalize {
    if (isEmpty) return null;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
