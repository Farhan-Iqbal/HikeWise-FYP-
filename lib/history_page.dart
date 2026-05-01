import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Hike History"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4, // Placeholder count
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(Icons.terrain, color: Color(0xFF2E7D32)),
              ),
              title: Text(index == 0 ? "Bukit Besar" : "Bukit Keluang"),
              subtitle: Text("${DateTime.now().day - index} April 2026 • 1h 20m"),
              trailing: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("3.5km", style: TextStyle(fontWeight: FontWeight.bold)),
                  Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                ],
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}