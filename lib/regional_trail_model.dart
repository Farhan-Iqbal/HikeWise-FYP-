class RegionalTrail {
  final String name;
  final String location; // District
  final String difficulty;
  final String type; // Jungle, Coastal, Waterfall

  const RegionalTrail({required this.name, required this.location, required this.difficulty, required this.type});
}

// Mock data for your UI testing
const List<RegionalTrail> terengganuTrails = [
  RegionalTrail(name: "Bukit Keluang", location: "Besut", difficulty: "Easy", type: "Coastal"),
  RegionalTrail(name: "Lata Tembakah", location: "Besut", difficulty: "Moderate", type: "Waterfall"),
  RegionalTrail(name: "Chemerong & Berembun", location: "Dungun", difficulty: "Hard", type: "Jungle"),
  RegionalTrail(name: "Bukit Labuhan", location: "Kemaman", difficulty: "Easy", type: "Coastal"),
  RegionalTrail(name: "Bukit Besar", location: "Kuala Terengganu", difficulty: "Moderate", type: "Jungle"),
];