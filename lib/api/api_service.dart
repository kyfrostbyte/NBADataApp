// lib/api/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sport_scores/api/models/gameinfo.dart';
import 'models/gamesbydate.dart';
import 'models/standingsby_year.dart';
import 'dart:async';
export 'models/standingsby_year.dart';
export 'models/gameinfo.dart';


Future<StandingsByYear?> fetchStandings(year) async {
  const String url = "https://api-nba-v1.p.rapidapi.com/standings";
  final Map<String, String> queryParameters = {
    "league": "standard",
    "season": year,
  };

  final Map<String, String> headers = {
    "X-RapidAPI-Key": "f1209231d1msh4921fffcfc193e2p13fa0bjsnaa6b8925a8eb",
    "X-RapidAPI-Host": "api-nba-v1.p.rapidapi.com",
  };

  final Uri uri = Uri.parse(url).replace(queryParameters: queryParameters);

  final response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    print("StandingsByYear Request Successful");

    // Convert the decoded JSON map to a FetchStandings object
    final Map<String, dynamic> responseJson = json.decode(response.body);
    return StandingsByYear.fromJson(responseJson);
  } else {
    // Handle error (you might want to throw an exception or return an error object)
    print('Error: ${response.statusCode}');
    return null;
  }
}




