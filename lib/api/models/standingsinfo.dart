
class StandingsInfo {
  final String name;
  final String conference;
  final int rank;

  StandingsInfo({
    required this.name,
    required this.conference,
    required this.rank,
  });


  factory StandingsInfo.fromJson(Map<String, dynamic> json) {
    return StandingsInfo (
      name: json['team']['name'] ?? "",
      conference: json['conference']['name'] ?? "",
      rank: json['conference']['rank'] ?? 0,
    );
  }
}