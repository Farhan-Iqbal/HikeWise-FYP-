import 'package:flutter/material.dart';
import 'services/weather_service.dart'; // Ensure this path is correct

class WeatherSafetyPage extends StatefulWidget {
  const WeatherSafetyPage({super.key});

  @override
  State<WeatherSafetyPage> createState() => _WeatherSafetyPageState();
}

class _WeatherSafetyPageState extends State<WeatherSafetyPage> {
  final WeatherService _weatherService = WeatherService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Safety Dashboard"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        // Defaulting to Kuala Terengganu as the general safety indicator
        future: _weatherService.getWeather("Kuala Terengganu"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)));
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Unable to load live safety data."));
          }

          final data = snapshot.data!;
          final mainWeather = data['weather'][0]['main'];
          final temp = data['main']['temp'].round();
          final humidity = data['main']['humidity'];
          final windSpeed = (data['wind']['speed'] * 3.6).toStringAsFixed(1); // Convert m/s to km/h

          // Simple logic for safety status
          bool isSafe = mainWeather.toLowerCase() != 'rain' && mainWeather.toLowerCase() != 'thunderstorm';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildStatusCard(isSafe, mainWeather),
                const SizedBox(height: 30),
                _buildSafetyItem("Temperature", "$temp°C", Icons.thermostat, Colors.orange),
                _buildSafetyItem("Humidity", "$humidity%", Icons.water_drop, Colors.blue),
                _buildSafetyItem("Main Condition", mainWeather, Icons.cloud, Colors.blueGrey),
                _buildSafetyItem("Wind Speed", "$windSpeed km/h", Icons.air, Colors.grey),
                const SizedBox(height: 20),
                const Text(
                  "Data provided by OpenWeatherMap. Always check local trail conditions before starting your hike.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(bool isSafe, String condition) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isSafe ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSafe ? Colors.green.shade200 : Colors.red.shade200),
      ),
      child: Column(
        children: [
          Icon(
            isSafe ? Icons.check_circle : Icons.warning,
            color: isSafe ? Colors.green : Colors.red,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            isSafe ? "Condition: Optimal" : "Condition: Caution",
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold, 
              color: isSafe ? Colors.green : Colors.red
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSafe 
              ? "Terengganu trails are currently safe for hiking. No active weather warnings."
              : "Warning: $condition detected. Trails may be slippery or dangerous. Hike with caution.",
            textAlign: TextAlign.center,
            style: TextStyle(color: isSafe ? Colors.green[900] : Colors.red[900]),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyItem(String title, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}