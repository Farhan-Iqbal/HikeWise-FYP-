import 'package:flutter/material.dart';
import 'homepage.dart';

class PreferencePickerPage extends StatefulWidget {
  const PreferencePickerPage({super.key});

  @override
  State<PreferencePickerPage> createState() => _PreferencePickerPageState();
}

class _PreferencePickerPageState extends State<PreferencePickerPage> {
  double _distWeight = 0.5;
  double _elevWeight = 0.5;
  double _scenicWeight = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personalize Your Hike")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("What do you prioritize?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            _buildSlider("Short Distance", _distWeight, (val) => setState(() => _distWeight = val)),
            const SizedBox(height: 20),
            _buildSlider("Low Elevation", _elevWeight, (val) => setState(() => _elevWeight = val)),
            const SizedBox(height: 20),
            _buildSlider("Scenic Views", _scenicWeight, (val) => setState(() => _scenicWeight = val)),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Generate Recommendations", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Slider(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF2E7D32),
          inactiveColor: Colors.green[100],
        ),
      ],
    );
  }
}