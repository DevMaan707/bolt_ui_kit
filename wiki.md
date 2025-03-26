# Wiki Documentation for GitHub and pub.dev

## Flutter Kit

Flutter Kit is a comprehensive UI toolkit and utility library designed to accelerate Flutter application development. It provides a collection of ready-to-use components, services, and utilities that follow best practices in mobile app development.

### Table of Contents

1. [Installation](#installation)
2. [Getting Started](#getting-started)
3. [Core Components](#core-components)
   - [UI Components](#ui-components)
   - [Services](#services)
   - [Utilities](#utilities)
4. [Theming](#theming)
5. [Pickers & Permission Utilities](#pickers--permission-utilities)
6. [API Integration](#api-integration)
7. [Examples](#examples)
8. [Contributing](#contributing)

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_kit: ^3.0.0
```

Then run:

```bash
flutter pub get
```

## Getting Started

Initialize the Flutter Kit in your `main.dart` file:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_kit/flutter_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterKit.initialize(
    primaryColor: Colors.blue,
    accentColor: Colors.orangeAccent,
    designSize: const Size(375, 812),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterKit.builder(
      builder: () => MaterialApp(
        title: 'My App',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        home: HomePage(),
      ),
    );
  }
}
```

## Core Components

### UI Components

#### Buttons

Flutter Kit provides various button styles to match your design needs:

```dart
Button(
  text: 'Primary Button',
  type: ButtonType.primary,
  onPressed: () => print('Button pressed'),
)

Button(
  text: 'Outlined Button',
  type: ButtonType.outlined,
  icon: Icons.save,
  onPressed: () => print('Button pressed'),
)
```

Available button types:
- `primary`: Filled button with primary color
- `secondary`: Filled button with accent color
- `outlined`: Button with outline and transparent background
- `text`: Text-only button without background
- `custom`: Fully customizable button

#### Inputs

Input fields with built-in validation and customization:

```dart
AppInput(
  label: 'Email',
  hint: 'Enter your email',
  type: InputType.email,
  prefixIcon: Icons.email,
  onChanged: (value) => print(value),
  validator: (value) => value!.isEmpty ? 'Email is required' : null,
)

AppInput(
  label: 'Password',
  type: InputType.password,
  prefixIcon: Icons.lock,
)
```

Available input types:
- `text`: Standard text input
- `password`: Password input with toggle visibility
- `email`: Email input with email keyboard
- `number`: Numeric input
- `phone`: Phone number input
- `multiline`: Multi-line text input
- `search`: Search input with search icon

#### Cards

Cards for content organization:

```dart
AppCard(
  type: CardType.elevated,
  child: Column(
    children: [
      Text('Card Title', style: AppTextThemes.heading4()),
      SizedBox(height: 8),
      Text('Card content goes here'),
    ],
  ),
)
```

Available card types:
- `standard`: Basic card with light elevation
- `elevated`: Card with more pronounced elevation
- `outlined`: Card with border instead of elevation
- `minimal`: Card without elevation or border

#### Toast Notifications

Show informative toast messages:

```dart
Toast.show(
  message: 'Profile updated successfully!',
  type: ToastType.success,
)

Toast.show(
  message: 'Failed to connect to server',
  type: ToastType.error,
  title: 'Connection Error',
)
```

Available toast types:
- `success`: Green toast for successful operations
- `error`: Red toast for errors
- `info`: Blue toast for informational messages
- `warning`: Orange toast for warnings
## Pickers & Selectors

Flutter Kit provides a comprehensive suite of pickers and selectors that are fully customizable and follow your app's theme.

### Date Picker

The DatePickerUtil provides a beautiful, theme-consistent date picker:

```dart
DateTime? selectedDate = await DatePickerUtil.showCustomDatePicker(
  initialDate: DateTime.now(),
  firstDate: DateTime(2000),
  lastDate: DateTime(2100),
  helpText: 'Select Your Birth Date',
  confirmText: 'Confirm',
  cancelText: 'Cancel',
  // Will use theme colors by default
  // primaryColor: Colors.purple, // Optional override
  // textColor: Colors.black87,   // Optional override
);

if (selectedDate != null) {
  // Format the date for display
  String formattedDate = DatePickerUtil.formatDate(
    selectedDate,
    format: 'MMM dd, yyyy', // Optional format
  );
  print('Selected date: $formattedDate');
}
```

### Date Range Picker

For selecting a range of dates:

```dart
DateTimeRange? dateRange = await DatePickerUtil.showCustomDateRangePicker(
  initialDateRange: DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(Duration(days: 7)),
  ),
  helpText: 'Select Date Range',
);

if (dateRange != null) {
  // Format the range for display
  String formattedRange = DatePickerUtil.formatDateRange(
    dateRange,
    format: 'MMM dd', // Optional format
  );
  print('Selected range: $formattedRange');
}
```

### Time Picker

Theme-consistent time picker:

```dart
TimeOfDay? selectedTime = await TimePickerUtil.showCustomTimePicker(
  initialTime: TimeOfDay.now(),
  helpText: 'Select Appointment Time',
  use24HourFormat: false,
);

if (selectedTime != null) {
  String formattedTime = TimePickerUtil.formatTimeOfDay(
    selectedTime,
    alwaysUse24HourFormat: false,
  );
  print('Selected time: $formattedTime');
}
```

### Duration Picker

For selecting a duration (hours, minutes, seconds):

```dart
Duration? duration = await TimePickerUtil.showDurationPicker(
  initialDuration: Duration(minutes: 30),
  maxDuration: Duration(hours: 10),
  showHours: true,
  showMinutes: true,
  showSeconds: true,
);

if (duration != null) {
  String formattedDuration = TimePickerUtil.formatDuration(duration);
  print('Selected duration: $formattedDuration');
}
```

### Calendar Picker

For a more flexible calendar UI:

```dart
// Single date selection
final result = await CalendarPickerUtil.showCalendarPicker(
  mode: CalendarPickerMode.single,
  title: 'Select Date',
);
if (result?.selectedDate != null) {
  print('Selected: ${result!.selectedDate}');
}

// Multiple dates selection
final result = await CalendarPickerUtil.showCalendarPicker(
  mode: CalendarPickerMode.multi,
);
if (result?.selectedDates != null) {
  print('Selected ${result!.selectedDates!.length} dates');
}

// Date range selection
final result = await CalendarPickerUtil.showCalendarPicker(
  mode: CalendarPickerMode.range,
);
if (result?.selectedRange != null) {
  print('Selected range: ${result!.selectedRange}');
}
```

### Image Picker

Pick images with optional cropping:

```dart
// Custom UI with options for camera or gallery
File? image = await ImagePickerUtil().showCustomImagePicker(
  enableCrop: true,
  cropSettings: CropSettings.profilePicture(
    primaryColor: AppColors.primary,
  ),
);

// Direct camera access
File? cameraImage = await ImagePickerUtil().pickImageFromCamera(
  maxWidth: 800,
  maxHeight: 800,
  enableCrop: true,
);

// Direct gallery access
File? galleryImage = await ImagePickerUtil().pickImageFromGallery();

// Multiple images
List<File> images = await ImagePickerUtil().pickMultipleImages();
```

### File Picker

For selecting files:

```dart
// Custom file picker UI
File? file = await FilePickerUtil().showCustomFilePicker(
  context: context,
  title: 'Select Document',
);

// Direct file pick with extension filtering
File? pdfFile = await FilePickerUtil().pickFile(
  allowedExtensions: ['pdf', 'doc', 'docx'],
);

// Multiple files
List<File> files = await FilePickerUtil().pickMultipleFiles();

// Pick a directory
String? dirPath = await FilePickerUtil().pickDirectory();
```

### QR Scanner

Scan QR codes with a beautiful UI:

```dart
String? qrData = await QRScannerUtil().scanQR(
  title: 'Scan QR Code',
  scanInstructions: 'Position the QR code in the frame',
  showFlashlight: true,
  vibrate: true,
  theme: ScannerTheme(
    primaryColor: AppColors.primary,
    scanAreaWidth: 250,
    scanAreaHeight: 250,
  ),
);

if (qrData != null) {
  print('Scanned data: $qrData');
}
```

## Charts

FlutterKit provides beautiful chart components for data visualization.

### Pie Chart

```dart
AppChart(
  type: AppChartType.pie,
  title: 'Revenue by Category',
  data: [
    AppChartData(label: 'Category A', value: 35),
    AppChartData(label: 'Category B', value: 25),
    AppChartData(label: 'Category C', value: 20),
    AppChartData(label: 'Category D', value: 15),
    AppChartData(label: 'Other', value: 5),
  ],
  // Optional customizations
  colorPalette: [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple],
  showLabels: true,
  showLegend: true,
  animated: true,
)
```

### Donut Chart

```dart
AppChart(
  type: AppChartType.donut,
  title: 'Traffic Sources',
  data: [
    AppChartData(label: 'Direct', value: 30),
    AppChartData(label: 'Search', value: 25),
    AppChartData(label: 'Social', value: 20),
    AppChartData(label: 'Referral', value: 15),
    AppChartData(label: 'Other', value: 10),
  ],
)
```

### Bar Chart

```dart
AppChart(
  type: AppChartType.bar,
  title: 'Monthly Sales',
  data: [
    AppChartData(label: 'Jan', value: 12),
    AppChartData(label: 'Feb', value: 17),
    AppChartData(label: 'Mar', value: 22),
    AppChartData(label: 'Apr', value: 19),
    AppChartData(label: 'May', value: 25),
    AppChartData(label: 'Jun', value: 32),
  ],
)
```

### Line Chart

```dart
AppChart(
  type: AppChartType.line,
  title: 'User Growth',
  data: [
    AppChartData(label: 'Jan', value: 1000),
    AppChartData(label: 'Feb', value: 1500),
    AppChartData(label: 'Mar', value: 2300),
    AppChartData(label: 'Apr', value: 3100),
    AppChartData(label: 'May', value: 4200),
    AppChartData(label: 'Jun', value: 5800),
  ],
  showValues: true,
)
```
#### Navigation Bar

Customizable navigation bars:

```dart
Navbar(
  title: 'Profile',
  style: NavbarStyle.standard,
  actions: [
    IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {},
    ),
  ],
)
```

Available navbar styles:
- `standard`: Colored background with white text
- `transparent`: No background
- `elevated`: White background with elevation
- `simple`: White background with minimal styling
- `custom`: Fully customizable style

#### Forms

Forms with built-in validation and submission handling:

```dart
AppForm(
  onSubmit: () => _saveUserData(),
  submitLabel: 'Save Profile',
  children: [
    AppInput(label: 'Name', validator: validateName),
    AppInput(label: 'Email', type: InputType.email, validator: validateEmail),
    AppInput(label: 'Phone', type: InputType.phone),
  ],
)
```

### Services

#### API Service

HTTP client with built-in error handling, logging, and interceptors:

```dart
final apiService = ApiService('https://api.example.com');

// GET request
final response = await apiService.get(
  endpoint: '/users',
  queryParams: {'limit': 10, 'page': 1},
);

// POST request
await apiService.post(
  endpoint: '/users',
  body: {'name': 'John', 'email': 'john@example.com'},
);
```

#### Storage Service

Local storage for persisting data:

```dart
final storage = Get.find<StorageService>();

// Store data
await storage.write('user_settings', {'theme': 'dark', 'notifications': true});

// Read data
final settings = storage.read<Map<String, dynamic>>('user_settings');

// Check if key exists
final hasSettings = storage.hasKey('user_settings');

// Remove data
await storage.remove('user_settings');
```

#### Authentication Service

Manage user authentication:

```dart
final authService = Get.find<AuthService>();

// Login
await authService.login(
  username: 'john@example.com',
  password: 'password123',
);

// Check authentication status
if (authService.isAuthenticated.value) {
  // User is logged in
}

// Logout
await authService.logout();
```

### Utilities

#### Navigation

Simplified navigation with static methods:

```dart
// Navigate to a new screen
NavigationService.push(ProductDetailScreen(product: product));

// Replace current screen
NavigationService.pushReplacement(HomeScreen());

// Pop back
NavigationService.pop();

// Pop until specific route
NavigationService.popUntil('/home');
```

#### Logging

Structured logging for debugging:

```dart
Logger.debug('User tapped on product', tag: 'ProductList');
Logger.info('Loading products from API', data: {'category': 'electronics'});
Logger.warning('API rate limit approaching');
Logger.error('Failed to load products',
  error: e,
  stackTrace: stackTrace
);
```

## Theming

Flutter Kit provides a comprehensive theming system:

```dart
// Initialize theme
AppColors.initialize(
  primary: Colors.indigo,
  accent: Colors.amberAccent,
  error: Colors.redAccent,
);

// Use in your app
ThemeData lightTheme = AppTheme.lightTheme();
ThemeData darkTheme = AppTheme.darkTheme();

// Access colors anywhere
Color primary = AppColors.primary;
Color textColor = AppColors.text;
```

### Text Themes

Consistent text styling across your app:

```dart
// Use predefined text styles
Text('Heading', style: AppTextThemes.heading1()),
Text('Subheading', style: AppTextThemes.heading3(color: Colors.grey)),
Text('Body text', style: AppTextThemes.bodyMedium()),
```

## Pickers & Permission Utilities

### Permission Management

Request device permissions with beautiful dialogs:

```dart
final permissionUtil = PermissionUtil();

// Request camera permission
bool hasPermission = await permissionUtil.request(
  permission: Permission.camera,
  title: 'Camera Access',
  description: 'We need camera access to take photos.',
  icon: Icons.camera_alt_rounded,
);

// Request multiple permissions
final permissions = await permissionUtil.requestMultiple(
  permissions: [Permission.camera, Permission.microphone],
);
```

### Date & Time Pickers

Pick dates and times with customizable UIs:

```dart
// Date picker
final date = await DatePickerUtil.showDatePicker(
  initialDate: DateTime.now(),
  primaryColor: AppColors.primary,
);

// Date range picker
final dateRange = await DatePickerUtil.showDateRangePicker();

// Time picker
final time = await TimePickerUtil.showTimePicker(
  use24HourFormat: true,
);

// Duration picker
final duration = await TimePickerUtil.showDurationPicker(
  initialDuration: Duration(minutes: 30),
);

// Calendar picker
final result = await CalendarPickerUtil.showCalendarPicker(
  mode: CalendarPickerMode.range,
);
```

### File & Media Pickers

Pick files, images, and videos with ease:

```dart
// File picker
final file = await FilePickerUtil().pickFile(
  allowedExtensions: ['pdf', 'doc', 'docx'],
);

// Custom file picker UI
final file = await FilePickerUtil().showCustomFilePicker(
  context: context,
  title: 'Select Document',
);

// Image picker
final image = await ImagePickerUtil().pickImageFromGallery(
  enableCrop: true,
);

// Custom image picker
final image = await ImagePickerUtil().showCustomImagePicker();

// Multiple images
final images = await ImagePickerUtil().pickMultipleImages();

// Video picker
final video = await ImagePickerUtil().pickVideoFromCamera();
```

### QR Code Scanner

Scan QR codes with a beautiful UI:

```dart
final scanResult = await QRScannerUtil().scanQR(
  title: 'Scan QR Code',
  primaryColor: AppColors.primary,
  showFlashlight: true,
);
```

### Simplified API

Use the simplified API for common use cases:

```dart
// Quick access methods
final date = await AppPickers.pickDate();
final image = await AppPickers.pickImageWithDialog();
final qrCode = await AppPickers.scanQR();
final dateRange = await AppPickers.pickCalendarRange();
```

## API Integration

Simplify API calls with built-in error handling:

```dart
final apiService = ApiService('https://api.example.com');

// Use safe request to handle errors gracefully
final userData = await apiService.safeRequest<Map<String, dynamic>>(
  request: () => apiService.get(endpoint: '/user/profile'),
  defaultValue: {},
  showToastOnError: true,
);

// Chain API calls
final posts = await apiService.safeRequest<List<dynamic>>(
  request: () async {
    final userId = await apiService.get(endpoint: '/user/id');
    return apiService.get(
      endpoint: '/posts',
      queryParams: {'userId': userId},
    );
  },
);
```

## Examples

### Basic Screen Layout

```dart
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: 'Profile',
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            AppCard(
              child: Column(
                children: [
                  Text('Personal Information', style: AppTextThemes.heading3()),
                  SizedBox(height: 16),
                  AppInput(label: 'Name', initialValue: 'John Doe'),
                  SizedBox(height: 16),
                  AppInput(label: 'Email', initialValue: 'john@example.com', type: InputType.email),
                ],
              ),
            ),
            SizedBox(height: 16),
            Button(
              text: 'Update Profile',
              type: ButtonType.primary,
              onPressed: () {
                Toast.show(message: 'Profile updated successfully!', type: ToastType.success);
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

### Form with Validation

```dart
class SignupForm extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppForm(
      formKey: formKey,
      onSubmit: () => _handleSignup(),
      submitLabel: 'Create Account',
      children: [
        AppInput(
          label: 'Full Name',
          prefixIcon: Icons.person,
          validator: (value) => value!.isEmpty ? 'Name is required' : null,
        ),
        AppInput(
          label: 'Email',
          prefixIcon: Icons.email,
          type: InputType.email,
          validator: (value) {
            if (value!.isEmpty) return 'Email is required';
            if (!value.contains('@')) return 'Enter a valid email';
            return null;
          },
        ),
        AppInput(
          label: 'Password',
          prefixIcon: Icons.lock,
          type: InputType.password,
          validator: (value) {
            if (value!.isEmpty) return 'Password is required';
            if (value.length < 6) return 'Password must be at least 6 characters';
            return null;
          },
        ),
      ],
    );
  }

  void _handleSignup() {
    Toast.show(message: 'Account created successfully!', type: ToastType.success);
  }
}
```

### Image Picker with Permission

```dart
class ProfileImagePicker extends StatefulWidget {
  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: _imageFile != null
              ? FileImage(_imageFile!)
              : AssetImage('assets/default_avatar.png') as ImageProvider,
        ),
        SizedBox(height: 16),
        Button(
          text: 'Change Profile Picture',
          type: ButtonType.outlined,
          icon: Icons.camera_alt,
          onPressed: _pickImage,
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final image = await ImagePickerUtil().showCustomImagePicker(
      enableCrop: true,
      cropSettings: CropSettings.profilePicture(),
    );

    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add some amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request
