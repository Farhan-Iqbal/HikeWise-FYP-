import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF2E7D32),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.terrain, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "HikeWise",
              style: TextStyle(
                color: Colors.white, 
                fontSize: 40, 
                fontWeight: FontWeight.bold, 
                letterSpacing: 2
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}