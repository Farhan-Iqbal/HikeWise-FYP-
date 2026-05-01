import 'package:flutter/material.dart';
import 'main_navigation_wrapper.dart';

class DistrictPickerPage extends StatelessWidget {
  const DistrictPickerPage({super.key});

  final List<String> districts = const [
    "Kuala Terengganu", "Besut", "Dungun", "Hulu Terengganu", 
    "Kemaman", "Marang", "Setiu", "Kuala Nerus"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select District")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.5,
        ),
        itemCount: districts.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const MainNavigationWrapper())),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2E7D32),
              side: const BorderSide(color: Color(0xFF2E7D32)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(districts[index], textAlign: TextAlign.center),
          );
        },
      ),
    );
  }
}