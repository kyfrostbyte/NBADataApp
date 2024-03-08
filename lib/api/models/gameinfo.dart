class GameInfo {
  final String homeTeamName;
  final int homeScore;
  final String homeLogo;

  final String visitorTeamName;
  final int visitorScore;
  final String visitorLogo;

  GameInfo({
    required this.homeTeamName,
    required this.homeScore,
    required this.homeLogo,

    required this.visitorTeamName,
    required this.visitorScore,
    required this.visitorLogo,
  });

  factory GameInfo.fromJson(Map<String, dynamic> json) {
    return GameInfo(
      visitorTeamName: json['teams']['visitors']['name'] ?? "",
      visitorScore: json['scores']['visitors']['points'] ?? 0,
      visitorLogo: json['teams']['visitors']['logo'] ?? "",

      homeTeamName: json['teams']['home']['name'] ?? "",
      homeScore: json['scores']['home']['points'] ?? 0,
      homeLogo: json['teams']['home']['logo'] ?? "",
    );
  }
}