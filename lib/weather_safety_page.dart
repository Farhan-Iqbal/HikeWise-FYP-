import 'package:flutter/material.dart';

class WeatherSafetyPage extends StatelessWidget {
  const WeatherSafetyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Safety Dashboard"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 64),
                  const SizedBox(height: 16),
                  const Text("Condition: Optimal", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 8),
                  Text(
                    "Terengganu trails are currently safe for hiking. No active weather warnings.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green[900]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildSafetyItem("Temperature", "30°C", Icons.thermostat, Colors.orange),
            _buildSafetyItem("Humidity", "75%", Icons.water_drop, Colors.blue),
            _buildSafetyItem("UV Index", "Moderate", Icons.wb_sunny, Colors.yellow[800]!),
            _buildSafetyItem("Wind Speed", "10 km/h", Icons.air, Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyItem(String title, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}