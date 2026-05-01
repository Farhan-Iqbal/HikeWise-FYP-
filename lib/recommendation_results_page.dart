import 'package:flutter/material.dart';

class RecommendationResultsPage extends StatelessWidget {
  const RecommendationResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Matches"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            // FIXED: Changed from EdgeInsets.bottom to EdgeInsets.only
            margin: const EdgeInsets.only(bottom: 16), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[800],
                    child: Text("${98 - (index * 5)}%", 
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(index == 0 ? "Bukit Besar" : "Bukit Maras", 
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Hybrid Recommendation Match"),
                  trailing: const Icon(Icons.verified_user, color: Colors.green),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    "This trail is selected because it bypasses your health constraints and aligns with your preference for scenic views.",
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}