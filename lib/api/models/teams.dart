// To parse this JSON data, do
//
//     final parseStandings = parseStandingsFromJson(jsonString);

import 'dart:convert';

ParseStandings parseStandingsFromJson(String str) => ParseStandings.fromJson(json.decode(str));

String parseStandingsToJson(ParseStandings data) => json.encode(data.toJson());

class ParseStandings {
  String parseStandingsGet;
  Parameters parameters;
  List<dynamic> errors;
  int results;
  List<Response> response;

  ParseStandings({
    required this.parseStandingsGet,
    required this.parameters,
    required this.errors,
    required this.results,
    required this.response,
  });

  factory ParseStandings.fromJson(Map<String, dynamic> json) => ParseStandings(
    parseStandingsGet: json["get"],
    parameters: Parameters.fromJson(json["parameters"]),
    errors: List<dynamic>.from(json["errors"].map((x) => x)),
    results: json["results"],
    response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "get": parseStandingsGet,
    "parameters": parameters.toJson(),
    "errors": List<dynamic>.from(errors.map((x) => x)),
    "results": results,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class Parameters {
  League league;
  String season;

  Parameters({
    required this.league,
    required this.season,
  });

  factory Parameters.fromJson(Map<String, dynamic> json) => Parameters(
    league: leagueValues.map[json["league"]]!,
    season: json["season"],
  );

  Map<String, dynamic> toJson() => {
    "league": leagueValues.reverse[league],
    "season": season,
  };
}

enum League {
  STANDARD
}

final leagueValues = EnumValues({
  "standard": League.STANDARD
});

class Response {
  League league;
  int season;
  Team team;
  Conference conference;
  Conference division;
  Loss win;
  Loss loss;
  String gamesBehind;
  int streak;
  bool winStreak;
  dynamic tieBreakerPoints;

  Response({
    required this.league,
    required this.season,
    required this.team,
    required this.conference,
    required this.division,
    required this.win,
    required this.loss,
    required this.gamesBehind,
    required this.streak,
    required this.winStreak,
    required this.tieBreakerPoints,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    league: leagueValues.map[json["league"]]!,
    season: json["season"],
    team: Team.fromJson(json["team"]),
    conference: Conference.fromJson(json["conference"]),
    division: Conference.fromJson(json["division"]),
    win: Loss.fromJson(json["win"]),
    loss: Loss.fromJson(json["loss"]),
    gamesBehind: json["gamesBehind"],
    streak: json["streak"],
    winStreak: json["winStreak"],
    tieBreakerPoints: json["tieBreakerPoints"],
  );

  Map<String, dynamic> toJson() => {
    "league": leagueValues.reverse[league],
    "season": season,
    "team": team.toJson(),
    "conference": conference.toJson(),
    "division": division.toJson(),
    "win": win.toJson(),
    "loss": loss.toJson(),
    "gamesBehind": gamesBehind,
    "streak": streak,
    "winStreak": winStreak,
    "tieBreakerPoints": tieBreakerPoints,
  };
}

class Conference {
  String name;
  int rank;
  int win;
  int loss;
  String? gamesBehind;

  Conference({
    required this.name,
    required this.rank,
    required this.win,
    required this.loss,
    this.gamesBehind,
  });

  factory Conference.fromJson(Map<String, dynamic> json) => Conference(
    name: json["name"],
    rank: json["rank"],
    win: json["win"],
    loss: json["loss"],
    gamesBehind: json["gamesBehind"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "rank": rank,
    "win": win,
    "loss": loss,
    "gamesBehind": gamesBehind,
  };
}

class Loss {
  int home;
  int away;
  int total;
  String percentage;
  int lastTen;

  Loss({
    required this.home,
    required this.away,
    required this.total,
    required this.percentage,
    required this.lastTen,
  });

  factory Loss.fromJson(Map<String, dynamic> json) => Loss(
    home: json["home"],
    away: json["away"],
    total: json["total"],
    percentage: json["percentage"],
    lastTen: json["lastTen"],
  );

  Map<String, dynamic> toJson() => {
    "home": home,
    "away": away,
    "total": total,
    "percentage": percentage,
    "lastTen": lastTen,
  };
}

class Team {
  int id;
  String name;
  String nickname;
  String code;
  String logo;

  Team({
    required this.id,
    required this.name,
    required this.nickname,
    required this.code,
    required this.logo,
  });

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    id: json["id"],
    name: json["name"],
    nickname: json["nickname"],
    code: json["code"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "nickname": nickname,
    "code": code,
    "logo": logo,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
