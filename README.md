# Flutter Kit

A comprehensive and modular Flutter UI kit that offers reusable widgets, themes, and utilities for rapid app development.

## Features

- **Responsive Design**: Built with `flutter_screenutil` for fully responsive UI across all devices
- **Dynamic Theming**: Easily customize themes with your brand colors
- **Modular Widgets**: Pre-built, customizable UI components
- **Glass Morphism**: Beautiful frosted glass effects with backdrop blur
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

  await BoltKit.initialize(
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

## Glass Morphism

Flutter Kit includes a comprehensive Glass Morphism system that creates beautiful frosted glass effects with backdrop blur, transparency, and subtle borders. Perfect for modern UI designs.

### Basic Glass Container

```dart
// Simple frosted glass effect
GlassContainer(
  child: Text(
    'Hello Glass!',
    style: TextStyle(color: Colors.white),
  ),
)

// Custom glass with specific type
GlassContainer(
  type: GlassType.crystal,
  blurIntensity: 15.0,
  backgroundOpacity: 0.3,
  borderOpacity: 0.5,
  child: YourWidget(),
)
```

### Glass Types

The Glass Morphism system includes 6 predefined glass types, each with unique visual characteristics:

#### 1. Frosted Glass (Default)
Classic frosted glass effect with moderate blur and opacity.
```dart
GlassContainer(
  type: GlassType.frosted,
  child: Text('Frosted Glass'),
)
```

#### 2. Crystal Glass
More transparent with subtle tinting, perfect for elegant overlays.
```dart
GlassContainer(
  type: GlassType.crystal,
  child: Text('Crystal Glass'),
)
```

#### 3. Smoky Glass
Darker appearance with higher opacity, great for dramatic effects.
```dart
GlassContainer(
  type: GlassType.smoky,
  child: Text('Smoky Glass'),
)
```

#### 4. Vibrant Glass
Uses your app's primary color for colorful glass effects.
```dart
GlassContainer(
  type: GlassType.vibrant,
  child: Text('Vibrant Glass'),
)
```

#### 5. Minimal Glass
Very subtle effect for understated elegance.
```dart
GlassContainer(
  type: GlassType.minimal,
  child: Text('Minimal Glass'),
)
```

#### 6. Custom Glass
Full control over all properties for unique effects.
```dart
GlassContainer(
  type: GlassType.custom,
  backgroundColor: Colors.purple,
  backgroundOpacity: 0.4,
  blurIntensity: 20.0,
  borderColor: Colors.white,
  borderOpacity: 0.6,
  child: Text('Custom Glass'),
)
```

### Glass Shapes

Control the shape of your glass containers with 4 different options:

#### Rectangle
```dart
GlassContainer(
  shape: GlassShape.rectangle,
  child: YourWidget(),
)
```

#### Rounded Rectangle
```dart
GlassContainer(
  shape: GlassShape.roundedRectangle,
  radius: 20.0, // Custom radius
  child: YourWidget(),
)

// Or with custom border radius
GlassContainer(
  shape: GlassShape.roundedRectangle,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(30),
    bottomRight: Radius.circular(30),
  ),
  child: YourWidget(),
)
```

#### Circle
```dart
GlassContainer(
  shape: GlassShape.circle,
  width: 100,
  height: 100,
  child: Icon(Icons.star, color: Colors.white),
)
```

#### Custom Shape
```dart
GlassContainer(
  shape: GlassShape.custom,
  borderRadius: BorderRadius.all(Radius.elliptical(50, 25)),
  child: YourWidget(),
)
```

### Convenience Constructors

Pre-configured glass containers for common use cases:

#### Glass Card
```dart
GlassContainer.card(
  child: Column(
    children: [
      Text('Card Title', style: TextStyle(color: Colors.white)),
      Text('Card content goes here...'),
    ],
  ),
)
```

#### Glass Button
```dart
GlassContainer.button(
  onTap: () => handleButtonPress(),
  child: Text('Glass Button', style: TextStyle(color: Colors.white)),
)
```

#### Glass Dialog
```dart
GlassContainer.dialog(
  width: 300,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Dialog Title'),
      SizedBox(height: 16),
      Text('Dialog message goes here...'),
      // Action buttons
    ],
  ),
)
```

#### Glass App Bar
```dart
GlassContainer.appBar(
  child: Row(
    children: [
      IconButton(icon: Icon(Icons.menu), onPressed: () {}),
      Expanded(child: Text('App Title')),
      IconButton(icon: Icon(Icons.search), onPressed: () {}),
    ],
  ),
)
```

#### Glass Bottom Sheet
```dart
GlassContainer.bottomSheet(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Bottom Sheet Content'),
      // More content
    ],
  ),
)
```

#### Glass Overlay
```dart
GlassContainer.overlay(
  onTap: () => dismissOverlay(),
  child: Center(
    child: Text('Overlay Content'),
  ),
)
```

### Advanced Glass Effects

#### Glass with Gradient Overlay
```dart
GlassContainer(
  type: GlassType.custom,
  gradient: LinearGradient(
    colors: [
      Colors.purple.withOpacity(0.3),
      Colors.blue.withOpacity(0.2),
    ],
  ),
  gradientOpacity: 0.8,
  child: YourWidget(),
)
```

#### Nested Glass Containers
```dart
GlassContainer(
  type: GlassType.smoky,
  padding: EdgeInsets.all(20),
  child: Column(
    children: [
      Text('Outer Glass Container'),
      SizedBox(height: 16),
      GlassContainer(
        type: GlassType.crystal,
        padding: EdgeInsets.all(16),
        child: Text('Inner Glass Container'),
      ),
    ],
  ),
)
```

#### Transformed Glass
```dart
GlassContainer(
  type: GlassType.vibrant,
  transform: Matrix4.rotationZ(0.1),
  child: Text('Rotated Glass'),
)
```

#### Interactive Glass Elements
```dart
GlassContainer(
  type: GlassType.crystal,
  onTap: () => print('Glass tapped!'),
  onLongPress: () => print('Glass long pressed!'),
  onDoubleTap: () => print('Glass double tapped!'),
  child: Text('Interactive Glass'),
)
```

### Pre-built Glass Widgets

For common UI patterns, use the pre-built glass widgets:

#### Glass Loading Indicator
```dart
GlassWidgets.loading(
  message: 'Loading...',
  type: GlassType.frosted,
)
```

#### Glass Notification
```dart
GlassWidgets.notification(
  title: 'New Message',
  message: 'You have received a new message',
  icon: Icons.message,
  onTap: () => openMessage(),
  onDismiss: () => dismissNotification(),
)
```

#### Glass Search Bar
```dart
GlassWidgets.searchBar(
  hintText: 'Search...',
  onChanged: (query) => performSearch(query),
  onClear: () => clearSearch(),
)
```

#### Glass Tab Bar
```dart
GlassWidgets.tabBar(
  tabs: ['Home', 'Search', 'Profile'],
  selectedIndex: selectedTab,
  onTabSelected: (index) => selectTab(index),
)
```

#### Glass Progress Indicator
```dart
GlassWidgets.progressIndicator(
  progress: 0.75,
  label: 'Upload Progress',
  progressColor: Colors.green,
)
```

#### Glass Image Overlay
```dart
GlassWidgets.imageOverlay(
  child: Image.asset('assets/background.jpg'),
  title: 'Beautiful Landscape',
  subtitle: 'Captured in Switzerland',
  actions: [
    IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
    IconButton(icon: Icon(Icons.share), onPressed: () {}),
  ],
)
```

#### Glass Floating Action Button
```dart
GlassWidgets.floatingActionButton(
  onPressed: () => addItem(),
  icon: Icons.add,
  type: GlassType.vibrant,
)
```

### Glass Morphism Customization

#### Full Customization Options
```dart
GlassContainer(
  // Shape and size
  width: 300,
  height: 200,
  shape: GlassShape.roundedRectangle,
  borderRadius: BorderRadius.circular(20),

  // Glass effect properties
  type: GlassType.custom,
  backgroundColor: Colors.blue,
  backgroundOpacity: 0.3,
  blurIntensity: 15.0,

  // Border properties
  borderColor: Colors.white,
  borderWidth: 1.5,
  borderOpacity: 0.4,

  // Shadow properties
  addShadow: true,
  shadowColor: Colors.black,
  shadowBlurRadius: 20.0,
  shadowOffset: Offset(0, 10),

  // Layout properties
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.all(8),
  alignment: Alignment.center,

  // Transform
  transform: Matrix4.identity()..scale(1.1),

  // Gradient overlay
  gradient: LinearGradient(
    colors: [Colors.purple, Colors.blue],
  ),
  gradientOpacity: 0.2,

  // Interaction
  onTap: () => handleTap(),
  onLongPress: () => handleLongPress(),

  child: YourWidget(),
)
```

### Real-World Glass Morphism Examples

#### Music Player Card
```dart
GlassContainer.card(
  type: GlassType.frosted,
  child: Column(
    children: [
      Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.music_note, color: Colors.white),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Song Title', style: TextStyle(color: Colors.white)),
                Text('Artist Name', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GlassContainer.button(
            type: GlassType.minimal,
            onTap: () => previousTrack(),
            child: Icon(Icons.skip_previous, color: Colors.white),
          ),
          GlassContainer.button(
            type: GlassType.crystal,
            onTap: () => togglePlayPause(),
            child: Icon(Icons.play_arrow, color: Colors.white),
          ),
          GlassContainer.button(
            type: GlassType.minimal,
            onTap: () => nextTrack(),
            child: Icon(Icons.skip_next, color: Colors.white),
          ),
        ],
      ),
    ],
  ),
)
```

#### Weather Card
```dart
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
              Text('San Francisco', style: TextStyle(color: Colors.white)),
              Text('Partly Cloudy', style: TextStyle(color: Colors.white70)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('72°', style: TextStyle(color: Colors.white, fontSize: 24)),
              Icon(Icons.wb_cloudy, color: Colors.white),
            ],
          ),
        ],
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _weatherStat('Humidity', '65%'),
          _weatherStat('Wind', '12 mph'),
          _weatherStat('UV Index', '3'),
        ],
      ),
    ],
  ),
)
```

#### Navigation Card
```dart
GlassContainer.card(
  type: GlassType.vibrant,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      _navItem(Icons.home, 'Home', true),
      _navItem(Icons.search, 'Search', false),
      _navItem(Icons.favorite, 'Likes', false),
      _navItem(Icons.person, 'Profile', false),
    ],
  ),
)
```

### Best Practices for Glass Morphism

1. **Use Appropriate Backgrounds**: Glass effects work best over colorful or textured backgrounds
2. **Consider Readability**: Ensure text remains readable over glass surfaces
3. **Layer Thoughtfully**: Use different glass types to create visual hierarchy
4. **Maintain Consistency**: Stick to 2-3 glass types throughout your app
5. **Performance**: Avoid excessive nesting of glass containers
6. **Accessibility**: Ensure sufficient contrast for users with visual impairments

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

## API Service

The `ApiService` class provides a robust HTTP client implementation using Dio with built-in logging, error handling, and retry logic.

### Usage

```dart
// Initialize the API service
final apiService = ApiService('https://api.example.com');

// Make GET request
final response = await apiService.get(
  endpoint: '/users',
  queryParams: {'page': 1},
  headers: {'Authorization': 'Bearer token'},
);

// Make POST request
final response = await apiService.post(
  endpoint: '/users',
  body: {'name': 'John Doe'},
);

// Make PUT request
final response = await apiService.put(
  endpoint: '/users/1',
  body: {'name': 'John Doe Updated'},
);

// Make DELETE request
final response = await apiService.delete(
  endpoint: '/users/1',
);

// Safe request with error handling
final result = await apiService.safeRequest<User>(
  request: () => apiService.get(endpoint: '/users/1'),
  defaultValue: null,
);
```

### Features

- Automatic error handling and logging
- Request/response interceptors
- Timeout handling
- Pretty printing of requests/responses
- Toast notifications for errors
- Type-safe responses
- Customizable base URL and timeout settings

## New Widgets

### PDF Viewer

The `BoltPDFViewer` widget provides a feature-rich PDF viewer with navigation controls and customization options.

```dart
// Show PDF from file
BoltPDFViewer.showPdfDialog(
  context: context,
  filePath: 'assets/document.pdf',
  title: 'Document Viewer',
);

// Show PDF from URL
BoltPDFViewer.openPdf(
  context: context,
  url: 'https://example.com/document.pdf',
  enableNavigation: true,
);
```

Features:
- File, network and asset source support
- Navigation controls
- Page counter
- Full-screen mode
- Custom toolbar actions
- Error handling
- Loading states
- Dark mode support

### Slides Viewer

The `BoltSlidesViewer` widget allows viewing presentations in various formats with a rich set of controls.

```dart
// Show Google Slides
BoltSlidesViewer.showSlidesDialog(
  context: context,
  googleSlidesId: 'presentation_id',
  title: 'Presentation',
);

// Open PowerPoint file
BoltSlidesViewer.openSlidesViewer(
  context: context,
  filePath: 'presentation.pptx',
  sourceType: SlidesSourceType.pptx,
);
```

Features:
- Support for multiple formats (PDF, PPTX, Google Slides)
- Navigation controls
- Slide counter
- Full-screen presentation mode
- Auto-conversion to PDF
- Network file support
- Custom toolbar actions
- Error handling
- Loading states
- Dark mode support

### Input Components

#### PinInput

```dart
// Basic PIN input
BoltPinInput(
  length: 6,
  onCompleted: (pin) => print('PIN: $pin'),
);

// Custom styled PIN dialog
showPinInputDialog(
  context: context,
  title: 'Enter PIN',
  length: 4,
  theme: PinInputTheme.outlined,
);
```

Features:
- Multiple visual themes
- Customizable styling
- Error handling
- Secure input mode
- Dialog helper
- Validation support
- Custom keyboard types

The library also includes other components like:
- File picker with preview
- Image picker with cropping
- Date/time pickers
- Calendar picker
- QR code scanner

All components are designed to be customizable, responsive and support both light and dark themes.

## Best Practices

- Initialize Early
- Consistent Typography
- Responsive Design
- Error Handling
- Secure input mode
- Dialog helper
- Validation support
- Custom keyboard types

The library also includes other components like:
- File picker with preview
- Image picker with cropping
- Date/time pickers
- Calendar picker
- QR code scanner

All components are designed to be customizable, responsive and support both light and dark themes.

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
