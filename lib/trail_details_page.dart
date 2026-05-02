import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'models/trail_model.dart'; // Ensure this path is correct

class TrailDetailsPage extends StatelessWidget {
  final Trail trail; // This captures the trail passed from HomePage

  const TrailDetailsPage({super.key, required this.trail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                trail.name, 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
              background: Hero(
                tag: 'trail-image-${trail.id}',
                child: trail.imageUrl != null
                    ? Image.network(trail.imageUrl!, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey[400], 
                        child: const Icon(Icons.terrain, size: 50, color: Colors.white)
                      ),
              ),
            ),
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(Icons.straighten, "${trail.distanceKm} km", "Distance"),
                        _buildStat(Icons.terrain, "${trail.elevationM} m", "Elevation"),
                        _buildStat(Icons.auto_graph, trail.difficulty, "Difficulty"),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text("About this Trail", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      trail.description,
                      style: const TextStyle(color: Colors.black87, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    const Text("Features", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: trail.features.map((feature) => Chip(
                        label: Text(feature, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.green.withOpacity(0.1),
                        side: BorderSide.none,
                      )).toList(),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MapScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Start Hiking", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF2E7D32), size: 28),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}