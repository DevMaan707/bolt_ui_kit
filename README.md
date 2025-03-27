# Flutter Kit

A comprehensive and modular Flutter UI kit that offers reusable widgets, themes, and utilities for rapid app development.

## Features

- **Responsive Design**: Built with `flutter_screenutil` for fully responsive UI across all devices
- **Dynamic Theming**: Easily customize themes with your brand colors
- **Modular Widgets**: Pre-built, customizable UI components
- **API Integration**: Simplified API handling with error management
- **Toast Notifications**: Beautiful toast messages for user feedback
- **Layouts**: Flexible layout options for different UI needs
- **Input Controls**: Form components with validation support
- **State Management**: Built with GetX for efficient state management
- **Storage Solutions**: Persistent storage with easy-to-use interface

## Installation

Add Flutter Kit to your project by including it in your `pubspec.yaml`:

```yaml
dependencies:
  bolt_ui_kit:
    git:
      url: https://github.com/DevMaan707/bolt_ui_kit.git
      ref: main
```

## Getting Started

### Initialize the Kit

Before using any components, initialize the Flutter Kit with your app's colors and preferences:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterKit.initialize(
    primaryColor: Color(0xFF1976D2),   // Your primary brand color
    accentColor: Color(0xFF64B5F6),    // Your accent/secondary color
    fontFamily: 'Poppins',             // Optional: Default font family
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterKit.builder(
      builder: () => GetMaterialApp(
        title: 'My App',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        home: HomeScreen(),
      ),
    );
  }
}
```

## Components Usage

### Buttons

```dart
// Primary Button
Button(
  text: 'Sign In',
  type: ButtonType.primary,
  onPressed: () => handleSignIn(),
)

// Secondary Button
Button(
  text: 'Cancel',
  type: ButtonType.secondary,
  onPressed: () => Navigator.pop(context),
)

// Outlined Button
Button(
  text: 'View Details',
  type: ButtonType.outlined,
  onPressed: () => viewDetails(),
)

// Button with icon
Button(
  text: 'Add to Cart',
  type: ButtonType.primary,
  icon: Icons.shopping_cart,
  onPressed: () => addToCart(),
)

// Loading Button
Button(
  text: 'Processing...',
  type: ButtonType.primary,
  isLoading: true,
  onPressed: null,
)
```

### Cards

```dart
// Standard Card
AppCard(
  child: Text('This is a standard card'),
)

// Elevated Card
AppCard(
  type: CardType.elevated,
  child: Text('This is an elevated card with more shadow'),
)

// Outlined Card
AppCard(
  type: CardType.outlined,
  child: Text('This is an outlined card without shadow'),
)

// Interactive Card
AppCard(
  onTap: () => handleCardTap(),
  child: Text('Tap this card'),
)

// Custom Card
AppCard(
  backgroundColor: Colors.blue.shade50,
  borderRadius: BorderRadius.circular(16),
  padding: EdgeInsets.all(24),
  child: Text('Custom styled card'),
)
```

### Toast Notifications

```dart
// Success Toast
Toast.show(
  message: 'Profile updated successfully!',
  type: ToastType.success,
)

// Error Toast
Toast.show(
  message: 'Failed to connect to server',
  type: ToastType.error,
)

// Info Toast
Toast.show(
  message: 'New message received',
  type: ToastType.info,
)

// Warning Toast
Toast.show(
  message: 'Your subscription will expire soon',
  type: ToastType.warning,
)

// Custom Toast
Toast.show(
  message: 'Custom notification',
  type: ToastType.info,
  title: 'Important Update',
  duration: Duration(seconds: 5),
  position: Alignment.topCenter,
  dismissible: false,
)
```
## Pickers & Selectors

Flutter Kit includes beautiful, customizable pickers that follow your app's theme for consistent UI:

### Date & Time Pickers

```dart
// Date picker with theme-consistent styling
final date = await DatePickerUtil.showCustomDatePicker(
  initialDate: DateTime.now(),
  firstDate: DateTime(2000),
  lastDate: DateTime(2100),
  helpText: 'Select Date',
  confirmText: 'Choose',
  cancelText: 'Cancel',
);

// Date range picker
final dateRange = await DatePickerUtil.showCustomDateRangePicker(
  initialDateRange: DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(Duration(days: 7)),
  ),
  helpText: 'Select Date Range',
);

// Time picker with themed UI
final time = await TimePickerUtil.showCustomTimePicker(
  initialTime: TimeOfDay.now(),
  helpText: 'Select Time',
  use24HourFormat: false,
);

// Duration picker
final duration = await TimePickerUtil.showDurationPicker(
  initialDuration: Duration(minutes: 30),
  showHours: true,
  showMinutes: true,
  showSeconds: true,
);
```

### Calendar Picker

```dart
// Single date selection
final result = await CalendarPickerUtil.showCalendarPicker(
  mode: CalendarPickerMode.single,
  primaryColor: AppColors.primary,
  selectedColor: AppColors.accent,
  title: 'Select Date',
);

// Multiple dates selection
final result = await CalendarPickerUtil.showCalendarPicker(
  mode: CalendarPickerMode.multi,
  initialSelectedDates: [DateTime.now()],
  title: 'Select Multiple Dates',
);

// Date range selection
final result = await CalendarPickerUtil.showCalendarPicker(
  mode: CalendarPickerMode.range,
  title: 'Select Date Range',
);
```

### File & Media Pickers

```dart
// Image picker with beautiful UI
final image = await ImagePickerUtil().showCustomImagePicker(
  enableCrop: true,
  cropSettings: CropSettings.square(
    primaryColor: AppColors.primary,
  ),
);

// File picker with custom UI
final file = await FilePickerUtil().showCustomFilePicker(
  context: context,
  title: 'Select File',
  primaryColor: AppColors.primary,
);

// QR Scanner with animated UI
final result = await QRScannerUtil().scanQR(
  title: 'Scan QR Code',
  scanInstructions: 'Position the QR code within the frame',
  primaryColor: AppColors.primary,
);
```

### Simplified Access

```dart
// Quick access through the AppPickers utility class
final date = await AppPickers.pickDate();
final time = await AppPickers.pickTime();
final image = await AppPickers.pickImageWithDialog();
final qrCode = await AppPickers.scanQR();
final dateRange = await AppPickers.pickDateRange();
final dates = await AppPickers.pickMultipleDates();
```
### Input Forms

```dart
// Text Input
AppInput(
  label: 'Username',
  hint: 'Enter your username',
  prefixIcon: Icons.person,
  onChanged: (value) => updateUsername(value),
)

// Password Input
AppInput(
  label: 'Password',
  hint: 'Enter your password',
  prefixIcon: Icons.lock,
  type: InputType.password,
  onChanged: (value) => updatePassword(value),
)

// Email Input with validation
AppInput(
  label: 'Email',
  hint: 'Enter your email address',
  type: InputType.email,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Enter a valid email address';
    }
    return null;
  },
)

// Multiline Input
AppInput(
  label: 'Notes',
  hint: 'Enter additional notes',
  type: InputType.multiline,
  maxLines: 5,
)
```

### Complete Form

```dart
AppForm(
  formKey: _formKey,
  onSubmit: () => handleFormSubmit(),
  submitLabel: 'Create Account',
  children: [
    AppInput(
      label: 'Full Name',
      hint: 'Enter your full name',
      prefixIcon: Icons.person,
      validator: (value) => value!.isEmpty ? 'Name is required' : null,
    ),
    AppInput(
      label: 'Email',
      hint: 'Enter your email',
      type: InputType.email,
      prefixIcon: Icons.email,
      validator: (value) => !value!.contains('@') ? 'Invalid email' : null,
    ),
    AppInput(
      label: 'Password',
      hint: 'Create a password',
      type: InputType.password,
      prefixIcon: Icons.lock,
      validator: (value) => value!.length < 6
        ? 'Password must be at least 6 characters'
        : null,
    ),
  ],
)
```

### Layouts

```dart
// Standard Layout
AppLayout(
  type: AppLayoutType.standard,
  padding: EdgeInsets.all(16),
  child: Center(child: Text('Standard Layout')),
)

// Scrollable Layout
AppLayout(
  type: AppLayoutType.scroll,
  padding: EdgeInsets.all(16),
  child: Column(
    children: [
      // Long content here
    ],
  ),
)

// Safe Area Layout
AppLayout(
  type: AppLayoutType.safeArea,
  padding: EdgeInsets.all(16),
  child: Text('Protected from notches and system UI'),
)

// Constrained Width Layout (good for tablets/web)
AppLayout(
  type: AppLayoutType.constrained,
  padding: EdgeInsets.all(16),
  child: Text('Width constrained layout'),
)
```

### API Service

```dart
// Initialize API Service
final apiService = ApiService('https://api.example.com');

// GET Request
Future<void> fetchUsers() async {
  try {
    final response = await apiService.get(
      endpoint: '/users',
      queryParams: {'page': '1', 'limit': '10'},
    );

    // Process response data
    final users = response as List<dynamic>;
    print('Fetched ${users.length} users');
  } catch (e) {
    print('Error fetching users: $e');
  }
}

// POST Request
Future<void> createUser() async {
  try {
    final response = await apiService.post(
      endpoint: '/users',
      body: {
        'name': 'John Doe',
        'email': 'john@example.com',
      },
    );

    print('User created with ID: ${response['id']}');
  } catch (e) {
    print('Error creating user: $e');
  }
}

// Safe Request (with automatic error handling)
Future<void> safeGetUsers() async {
  final users = await apiService.safeRequest<List<dynamic>>(
    request: () => apiService.get(endpoint: '/users'),
    defaultValue: [],
  );

  print('Safely fetched ${users?.length ?? 0} users');
}
```

### Using AppNavbar

```dart
Scaffold(
  appBar: Navbar(
    title: 'Dashboard',
    style: NavbarStyle.standard,
    actions: [
      IconButton(
        icon: Icon(Icons.notifications),
        onPressed: () => showNotifications(),
      ),
    ],
  ),
  body: AppLayout(
    // Content here
  ),
)

// Transparent Navigation Bar
Navbar(
  title: 'Product Details',
  style: NavbarStyle.transparent,
  iconColor: Colors.white,
  titleColor: Colors.white,
)

// Elevated Navigation Bar
Navbar(
  title: 'Settings',
  style: NavbarStyle.elevated,
  centerTitle: false,
)
```

### Using Theme Colors and Typography

```dart
Container(
  color: AppColors.primary,
  child: Text(
    'Primary Color Background',
    style: AppTextThemes.heading5(color: Colors.white),
  ),
)

Text(
  'This is a body text',
  style: AppTextThemes.bodyMedium(),
)

Text(
  'Error message',
  style: AppTextThemes.bodySmall(color: AppColors.error),
)
```

## Working with Storage Service

```dart
// Initialize is handled automatically by FlutterKit.initialize()
final storage = Get.find<StorageService>();

// Store a value
await storage.write('user_id', '12345');

// Read a value
String? userId = storage.read<String>('user_id');

// Store a complex object
await storage.writeObject('user_profile', userProfile);

// Read a complex object
UserProfile? profile = storage.readObject<UserProfile>(
  'user_profile',
  (json) => UserProfile.fromJson(json),
);
```

## Advanced Customization

### Custom Colors

You can access and override the default colors after initialization:

```dart
// Override colors after initialization
AppColors.success = Colors.green.shade800;
AppColors.error = Colors.red.shade900;
```

### Custom Text Styles

```dart
// Create a custom text style based on the app's theme
final customStyle = AppTextThemes.bodyLarge(
  color: AppColors.primary,
  fontWeight: FontWeight.w700,
);

Text('Custom styled text', style: customStyle);
```

## Navigation

```dart
// Basic navigation
NavigationService.push(DetailsScreen());

// Named route navigation
NavigationService.pushNamed('/details', arguments: {'id': '123'});

// Replace current screen
NavigationService.pushReplacement(NewScreen());

// Clear stack and navigate
NavigationService.pushAndRemoveUntil(HomeScreen());

// Go back
NavigationService.pop();
```

## Best Practices

1. **Initialize Early**: Call `FlutterKit.initialize()` as early as possible in your app lifecycle.

2. **Consistent Typography**: Use the provided text themes for consistent typography throughout your app.

3. **Responsive Design**: Always use screenutil's responsive units (`.w`, `.h`, `.sp`) for dimensions.

4. **Error Handling**: Use the API service's `safeRequest` method to simplify error handling.

5. **Form Validation**: Leverage the built-in form validation capabilities of `AppInput` and `AppForm`.

6. **Theme Extensions**: Extend the theme as needed by creating your own theme extension classes.

## Requirements

- Flutter SDK: >=2.17.0
- Dart SDK: >=2.17.0

## Dependencies

- flutter_screenutil: ^5.7.0
- get: ^4.6.5
- get_storage: ^2.1.1
- google_fonts: ^5.1.0
- dio: ^5.3.2
- intl: ^0.18.1

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

For more detailed information and examples, check out the [documentation](https://github.com/DevMaan707/bolt_ui_kit/wiki).
