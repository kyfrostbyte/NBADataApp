import 'package:sport_scores/api/api_service.dart';
import 'package:sport_scores/api/models/standingsinfo.dart';

class StandingsByYear {
  final List<StandingsInfo> standings;

  StandingsByYear({
    required this.standings,
  });

  factory StandingsByYear.fromJson(Map<String, dynamic> json) {
    final List<StandingsInfo> standings = (json['response'] as List<dynamic>?)
        ?.map((item) => StandingsInfo.fromJson(item))
        .toList() ?? [];

    return StandingsByYear(standings: standings);
  }
}
