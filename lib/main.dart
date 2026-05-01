import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'splash_screen.dart';
import 'login_page.dart';
import 'main_navigation_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with your project credentials
  await Supabase.initialize(
    url: 'https://lwkgsofcmfjdkdfabxnn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3a2dzb2ZjbWZqZGtkZmFieG5uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcyNjA1MjksImV4cCI6MjA5MjgzNjUyOX0.95AnVOTybQpwOuE1vwA0bCs6B-IMYJFrZRBUo0BcqAM',
  );

  runApp(const HikeWiseApp());
}

class HikeWiseApp extends StatelessWidget {
  const HikeWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HikeWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
        ),
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      // The home now points to our Auth Checker logic
      home: const AuthChecker(),
    );
  }
}

/// This widget determines if the user should see the Login Page or the Main App
class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _countDown();
  }

  // We keep your splash screen behavior for 3 seconds to show the branding
  void _countDown() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Show Splash Screen first for the branding experience
    if (_showSplash) {
      return const SplashScreen();
    }

    // 2. Once splash is done, check the Supabase session
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // User is already logged in (Persistence)
      return const MainNavigationWrapper();
    } else {
      // User needs to sign in
      return const LoginPage();
    }
  }
}