import 'package:sport_scores/api/models/gameinfo.dart';

class GamesByDate {
  final List<GameInfo> games;

  GamesByDate({
    required this.games,
  });

  factory GamesByDate.fromJson(Map<String, dynamic> json) {
    final List<GameInfo> games = (json['response'] as List<dynamic>?)
        ?.map((item) => GameInfo.fromJson(item))
        .toList() ??
        [];

    return GamesByDate(games: games);
  }
}
