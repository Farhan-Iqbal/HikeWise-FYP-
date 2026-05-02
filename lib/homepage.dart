import 'package:flutter/material.dart';
import 'trail_details_page.dart';
import 'settings_page.dart';
import 'filter_bottom_sheet.dart';
import 'services/database_service.dart';
import 'models/trail_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _dbService = DatabaseService();
  late Future<List<Trail>> _trailsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch data once when the page is initialized
    _trailsFuture = _dbService.getAllTrails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("HikeWise", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text(
                "Recommended for You",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _buildTrailList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF2E7D32),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Hello, Hiker!",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("Explore the best of Terengganu", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search trails...",
                    prefixIcon: const Icon(Icons.search),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                  icon: const Icon(Icons.tune, color: Color(0xFF2E7D32)),
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => const FilterBottomSheet(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrailList(BuildContext context) {
    return SizedBox(
      height: 280, // Increased slightly to fit content
      child: FutureBuilder<List<Trail>>(
        future: _trailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)));
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final trails = snapshot.data ?? [];

          if (trails.isEmpty) {
            return const Center(child: Text("No trails found in Terengganu."));
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: trails.length,
            itemBuilder: (context, index) {
              final trail = trails[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrailDetailsPage(trail: trail), 
                  ),
                ),
                child: Container(
                  width: 240,
                  margin: const EdgeInsets.only(right: 16, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- TRAIL IMAGE ---
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: trail.imageUrl != null
                            ? Image.network(
                                trail.imageUrl!,
                                height: 130,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                // Error handling if image fails to load
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
                              )
                            : Container(color: Colors.grey[300], height: 130, width: double.infinity, child: const Icon(Icons.terrain)),
                      ),
                      // --- TRAIL INFO ---
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(trail.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(trail.district, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.height, color: Colors.blue, size: 16),
                                Text(" ${trail.elevationM}m", style: const TextStyle(fontSize: 12)),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getDifficultyColor(trail.difficulty).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    trail.difficulty,
                                    style: TextStyle(
                                      color: _getDifficultyColor(trail.difficulty),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Helper to color-code difficulty levels
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy': return Colors.green;
      case 'moderate': return Colors.orange;
      case 'hard': return Colors.red;
      default: return Colors.grey;
    }
  }
}