import 'package:sport_scores/api/models/gameinfo.dart';
export 'models/gameinfo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GamesService {
  Future<List<GameInfo>> fetchGamesByDate(date) async {
    const String url = "https://api-nba-v1.p.rapidapi.com/games";
    final Map<String, String> queryParameters = {
      "date": date,
    };

    final Map<String, String> headers = {
      "X-RapidAPI-Key": "f1209231d1msh4921fffcfc193e2p13fa0bjsnaa6b8925a8eb",
      "X-RapidAPI-Host": "api-nba-v1.p.rapidapi.com",
    };

    final Uri uri = Uri.parse(url).replace(queryParameters: queryParameters);
    final response = await http.get(uri, headers: headers);


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<GameInfo> list = [];

      for (var i = 0; i < data['response'].length; i++){
        final entry = data['response'][i];
        list.add(GameInfo.fromJson(entry));
      }
      return list;
    } else {
      throw Exception('HTTP Failed');
    }
  }
}



