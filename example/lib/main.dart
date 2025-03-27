import 'package:flutter/material.dart';
import 'package:flutter_kit/flutter_kit.dart';
import 'package:get/get.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterKit.initialize(
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
    return FlutterKit.builder(
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
