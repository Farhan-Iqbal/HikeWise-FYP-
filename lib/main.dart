import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'splash_screen.dart';
import 'login_page.dart';
import 'main_navigation_wrapper.dart';
import 'screens/health_questionnaire_screen.dart';
import 'services/database_service.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      // CRITICAL: AuthChecker must be the initial 'home'
      home: const AuthChecker(), 
      routes: {
        '/login': (context) => const LoginPage(),
        '/health_questionnaire': (context) => HealthQuestionnaireScreen(),
        '/home': (context) => const MainNavigationWrapper(),
      },
    );
  }
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  final _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // 1. Wait for splash (3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    // 2. Get current session immediately
    final session = Supabase.instance.client.auth.currentSession;

    if (!mounted) return;

    if (session != null) {
      // 3. User is logged in, check if profile is done
      final hasProfile = await _dbService.hasCompletedProfile();
      if (mounted) {
        if (hasProfile) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/health_questionnaire');
        }
      }
    } else {
      // 4. No session, go to login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Always show splash while checking
    return const SplashScreen();
  }
}