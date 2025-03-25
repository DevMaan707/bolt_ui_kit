// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_kit/flutter_kit.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FlutterKit with your brand colors
  await FlutterKit.initialize(
    primaryColor: Color(0xFF6200EE), // Purple
    accentColor: Color(0xFF03DAC5), // Teal
    fontFamily: 'Poppins',
  );

  runApp(DemoApp());
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterKit.builder(
      builder: () => MaterialApp(
        title: 'Flutter Kit Demo',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
