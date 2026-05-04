import 'package:flutter/material.dart';
import 'trail_map_page.dart'; // Updated to point to your new OSM page
import 'models/trail_model.dart';

class TrailDetailsPage extends StatelessWidget {
  final Trail trail;

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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black45)],
                ),
              ),
              background: Hero(
                tag: 'trail-image-${trail.id}',
                child: trail.imageUrl != null
                    ? Image.network(trail.imageUrl!, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey[400],
                        child: const Icon(Icons.terrain, size: 50, color: Colors.white),
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
                    // Statistics Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(Icons.straighten, "${trail.distanceKm} km", "Distance"),
                        _buildStat(Icons.terrain, "${trail.elevationM} m", "Elevation"),
                        _buildStat(Icons.auto_graph, trail.difficulty, "Difficulty"),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Location section with quick map access
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("${trail.district}, Terengganu", style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        IconButton.filledTonal(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TrailMapPage(trail: trail)),
                          ),
                          icon: const Icon(Icons.map_outlined),
                          style: IconButton.styleFrom(foregroundColor: const Color(0xFF2E7D32)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Text("About this Trail", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      trail.description,
                      style: const TextStyle(color: Colors.black87, height: 1.5, fontSize: 15),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      )).toList(),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Main action button
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrailMapPage(trail: trail),
                        ),
                      ),
                      icon: const Icon(Icons.navigation),
                      label: const Text("Start Hiking / View Map", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 2,
                      ),
                    ),
                    const SizedBox(height: 20),
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