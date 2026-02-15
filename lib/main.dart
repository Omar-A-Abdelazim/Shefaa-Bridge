import 'package:flutter/material.dart';
import 'package:pharmacy_app/Login/Login%20Screen.dart';
import 'package:pharmacy_app/Login/Signup%20Step%201.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/main/main_navigation_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const PharmacyApp(),
    ),
  );
}

class PharmacyApp extends StatelessWidget {
  const PharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharmacy B2B Marketplace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1DE9B6),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1DE9B6),
          primary: const Color(0xFF1DE9B6),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const OnBoardingScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupStep1(),
        '/main': (context) => const MainNavigationScreen(),
      },
    );
  }
}
