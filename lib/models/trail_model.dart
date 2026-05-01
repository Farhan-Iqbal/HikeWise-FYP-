class Trail {
  final int id;
  final String name;
  final String district;
  final String difficulty;
  final double distanceKm;
  final int elevationM;
  final String type;           
  final List<String> features;
  final String description;
  final String? imageUrl;      

  Trail({
    required this.id,
    required this.name,
    required this.district,
    required this.difficulty,
    required this.distanceKm,
    required this.elevationM,
    required this.type,
    required this.features,
    required this.description,
    this.imageUrl,
  });

  factory Trail.fromJson(Map<String, dynamic> json) {
  // 1. Handle the features conversion carefully
  List<String> parsedFeatures = [];
  
  if (json['features'] is List) {
    // If it's already a list, just copy it
    parsedFeatures = List<String>.from(json['features']);
  } else if (json['features'] is String && json['features'].isNotEmpty) {
    // If it's a string like "Forest, River", split it by the comma
    parsedFeatures = (json['features'] as String)
        .split(',')
        .map((e) => e.trim())
        .toList();
  }

  return Trail(
    id: (json['id'] as num).toInt(),
    name: json['name'] ?? 'Unknown',
    district: json['district'] ?? 'Unknown',
    difficulty: json['difficulty'] ?? 'Moderate',
    distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
    elevationM: (json['elevation_m'] as num?)?.toInt() ?? 0,
    type: json['type'] ?? 'General',
    features: parsedFeatures, // Use our newly parsed list
    description: json['description'] ?? 'No description available.',
    imageUrl: json['image_url'],
  );
}
}