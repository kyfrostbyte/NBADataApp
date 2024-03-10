
class StandingsInfo {
  final String name;
  final String conference;
  final int rank;
  final String logo;

  StandingsInfo({
    required this.name,
    required this.conference,
    required this.rank,
    required this.logo,
  });

  factory StandingsInfo.fromJson(Map<String, dynamic> json) {
    return StandingsInfo (
      name: json['team']['name'] ?? "",
      conference: json['conference']['name'] ?? "",
      rank: json['conference']['rank'] ?? 0,
      logo: json['team']['logo'] ?? "",
    );
  }
}