import 'package:flutter/material.dart';
import 'package:bolt_ui_kit/bolt_kit.dart';
import 'package:get/get.dart';
import 'screens/home_screen.dart';

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
