import 'package:flutter/material.dart';
import 'profile_setup_page.dart';
import 'login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _buildSectionHeader("Account & Safety"),
          ListTile(
            leading: const Icon(Icons.health_and_safety, color: Color(0xFF2E7D32)),
            title: const Text("Hiker Profile"),
            subtitle: const Text("Update health conditions and fitness level"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
            ),
          ),
          const Divider(),
          _buildSectionHeader("App Preferences"),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active, color: Color(0xFF2E7D32)),
            title: const Text("Safety Alerts"),
            subtitle: const Text("Notify me about bad weather in Terengganu"),
            value: true,
            onChanged: (val) {},
            activeColor: const Color(0xFF2E7D32),
          ),
          const Divider(),
          _buildSectionHeader("System"),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}