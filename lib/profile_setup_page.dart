import 'package:flutter/material.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  String _fitnessLevel = 'Beginner';
  bool _hasAsthma = false;
  bool _hasHeartIssue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hiker Profile")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Safety Assessment", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              "We use this information to filter out trails that might be unsafe for you.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            const Text("Your Fitness Level", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _fitnessLevel,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              items: ['Beginner', 'Intermediate', 'Expert'].map((String level) {
                return DropdownMenuItem(value: level, child: Text(level));
              }).toList(),
              onChanged: (val) => setState(() => _fitnessLevel = val!),
            ),
            const SizedBox(height: 24),
            const Text("Health Conditions", style: TextStyle(fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text("Asthma"),
              subtitle: const Text("Filters high-elevation trails"),
              value: _hasAsthma,
              onChanged: (val) => setState(() => _hasAsthma = val),
              activeColor: const Color(0xFF2E7D32),
            ),
            SwitchListTile(
              title: const Text("Heart Issues"),
              subtitle: const Text("Filters 'Hard' difficulty trails"),
              value: _hasHeartIssue,
              onChanged: (val) => setState(() => _hasHeartIssue = val),
              activeColor: const Color(0xFF2E7D32),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Save Profile", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}