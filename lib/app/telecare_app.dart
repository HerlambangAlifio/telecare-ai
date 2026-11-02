import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../theme/app_colors.dart';

class TeleCareApp extends StatelessWidget {
  const TeleCareApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'TeleCare AI',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF9FCFF),
      colorScheme: ColorScheme.fromSeed(seedColor: blue),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: navy,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8E5F3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD8E5F3)),
        ),
      ),
    ),
    home: const HomePage(),
  );
}
