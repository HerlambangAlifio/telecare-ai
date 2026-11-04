
import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/doctor_home_page.dart';
import '../theme/app_colors.dart';

class TeleCareApp extends StatefulWidget {
  const TeleCareApp({super.key});

  @override
  State<TeleCareApp> createState() =>
      _TeleCareAppState();
}

class _TeleCareAppState extends State<TeleCareApp> {
  String? _loggedInRole;

  // LOGIN
  void _login(String role) {
    if (role != 'pasien' && role != 'dokter') {
      return;
    }

    setState(() {
      _loggedInRole = role;
    });
  }

  // LOGOUT
  void _logout() {
    setState(() {
      _loggedInRole = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeleCare AI',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor:
            const Color(0xFFF9FCFF),

        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: navy,
          centerTitle: false,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFD8E5F3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFD8E5F3),
            ),
          ),
        ),
      ),

      home: _loggedInRole == null
          ? LoginPage(
              onLogin: _login,
            )
          : _loggedInRole == 'dokter'
              ? DoctorHomePage(
                  onLogout: _logout,
                )
              : HomePage(
                  onLogout: _logout,
                ),
    );
  }
}
