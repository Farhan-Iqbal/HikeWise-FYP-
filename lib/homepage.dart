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
  
  List<Trail> _allTrails = [];
  List<Trail> _filteredTrails = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  // Track the current filter state
  Map<String, dynamic> _currentFilters = {
    'district': 'All',
    'difficulty': 'All',
    'features': <String>[],
  };

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final trails = await _dbService.getAllTrails();
      setState(() {
        _allTrails = trails;
        _filteredTrails = trails;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Extracts unique features from all trails for the FilterChips
  List<String> _getUniqueFeatures() {
    final Set<String> allFeatures = {};
    for (var trail in _allTrails) {
      if (trail.features != null) {
        allFeatures.addAll(trail.features!);
      }
    }
    return allFeatures.toList()..sort();
  }

  // Combined filtering logic (Search Bar + Bottom Sheet Filters)
  void _applyAdvancedFilters() {
    final String query = _searchController.text.toLowerCase();
    final String district = _currentFilters['district'];
    final String difficulty = _currentFilters['difficulty'];
    final List<String> selectedFeatures = List<String>.from(_currentFilters['features']);

    setState(() {
      _filteredTrails = _allTrails.where((trail) {
        // 1. Search Text Match
        final bool matchesSearch = trail.name.toLowerCase().contains(query) || 
                                   trail.district.toLowerCase().contains(query);
        
        // 2. District Match
        final bool matchesDistrict = district == 'All' || trail.district == district;
        
        // 3. Difficulty Match
        final bool matchesDifficulty = difficulty == 'All' || trail.difficulty == difficulty;
        
        // 4. Features Match (Trail must contain ALL selected features)
        bool matchesFeatures = true;
        if (selectedFeatures.isNotEmpty) {
          matchesFeatures = selectedFeatures.every((f) => 
            trail.features != null && trail.features!.contains(f));
        }

        return matchesSearch && matchesDistrict && matchesDifficulty && matchesFeatures;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                "Explore Terengganu Trails",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _buildTrailContent(),
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
          const Text("Search for your next adventure", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => _applyAdvancedFilters(),
                  decoration: InputDecoration(
                    hintText: "Search trails or districts...",
                    prefixIcon: const Icon(Icons.search),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
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
                  onPressed: () async {
                    // Open filter sheet and wait for result
                    final result = await showModalBottomSheet<Map<String, dynamic>>(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => FilterBottomSheet(
                        availableFeatures: _getUniqueFeatures(),
                        initialFilters: _currentFilters,
                      ),
                    );

                    if (result != null) {
                      _currentFilters = result;
                      _applyAdvancedFilters();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrailContent() {
    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32))),
      );
    }
    if (_errorMessage.isNotEmpty) {
      return Center(child: Text("Error: $_errorMessage"));
    }
    if (_filteredTrails.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text("No trails found. Try another search!"),
            ],
          ),
        ),
      );
    }
    return _buildTrailList();
  }

  Widget _buildTrailList() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filteredTrails.length,
        itemBuilder: (context, index) {
          final trail = _filteredTrails[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrailDetailsPage(trail: trail)),
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
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: trail.imageUrl != null
                        ? Image.network(
                            trail.imageUrl!,
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
                          )
                        : Container(color: Colors.grey[300], height: 130, width: double.infinity, child: const Icon(Icons.terrain)),
                  ),
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
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy': return Colors.green;
      case 'moderate': return Colors.orange;
      case 'hard': return Colors.red;
      default: return Colors.grey;
    }
  }
}