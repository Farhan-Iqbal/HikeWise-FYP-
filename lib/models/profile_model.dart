class UserProfile {
  final String id;
  final String fullName;
  final int fitnessLevel;
  final bool hasAsthma;
  final bool hasKneeInjury;
  final bool hasHeartCondition;
  final String preferredDifficulty;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.fitnessLevel,
    required this.hasAsthma,
    required this.hasKneeInjury,
    required this.hasHeartCondition,
    required this.preferredDifficulty,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      fitnessLevel: json['fitness_level'] ?? 1,
      hasAsthma: json['has_asthma'] ?? false,
      hasKneeInjury: json['has_knee_injury'] ?? false,
      hasHeartCondition: json['has_heart_condition'] ?? false,
      preferredDifficulty: json['preferred_difficulty'] ?? 'Easy',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'fitness_level': fitnessLevel,
      'has_asthma': hasAsthma,
      'has_knee_injury': hasKneeInjury,
      'has_heart_condition': hasHeartCondition,
      'preferred_difficulty': preferredDifficulty,
    };
  }
}