class Trail {
  final String id;
  final String name;
  final String district;
  final String difficulty;
  final String type;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final int elevationM; // Variable name: elevationM
  final List<String> features;
  final String description;
  final String? imageUrl;

  Trail({
    required this.id,
    required this.name,
    required this.district,
    required this.difficulty,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.elevationM, // Constructor name: elevationM
    required this.features,
    required this.description,
    this.imageUrl,
  });

  factory Trail.fromJson(Map<String, dynamic> json) {
    // Helper to turn CSV strings ("View, Forest") into a List ["View", "Forest"]
    List<String> _parseFeatures(dynamic data) {
      if (data == null) return [];
      if (data is List) return List<String>.from(data);
      if (data is String) return data.split(',').map((e) => e.trim()).toList();
      return [];
    }

    return Trail(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown',
      district: json['district'] ?? 'Terengganu',
      difficulty: json['difficulty'] ?? 'Moderate',
      type: json['type'] ?? 'Hiking',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      
      // Matches the columns I provided in the PDF/SQL
      latitude: double.tryParse(json['latitude']?.toString() ?? '0.0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0.0') ?? 0.0,
      
      // Matches your CSV column names
      distanceKm: double.tryParse(json['distance_km']?.toString() ?? '0.0') ?? 0.0,
      elevationM: int.tryParse(json['elevation_m']?.toString() ?? '0') ?? 0,
      
      features: _parseFeatures(json['features']),
    );
  }
}