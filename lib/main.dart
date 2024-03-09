import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport_scores/api/models/gamesbydate.dart';
import 'api/api_service.dart';
import 'package:http/http.dart' as http;
import 'api/models/standingsby_year.dart';
import 'api/models/standingsinfo.dart';
import 'package:flutter/material.dart';
import 'api/gameservice.dart';


// void main() async {
//   // Assuming fetchStandingsResult is the result from fetchStandings function
//   FetchStandings? fetchStandingsResult = await fetchStandings();
//
//   // Check if fetchStandingsResult is not null and has a response
//   if (fetchStandingsResult != null && fetchStandingsResult.response is List) {
//     // Iterate through the list of teams
//     List<Response> teamsList = fetchStandingsResult.response;
//     for (var teamData in teamsList) {
//       // Access and print information for each team
//       Team team = teamData.team;
//       print('Team Name: ${team.name}');
//       print('Conference: ${teamData.conference.name}');
//       print('Division: ${teamData.division.name}');
//       print('Wins: ${teamData.win.total}');
//       print('Losses: ${teamData.loss.total}');
//       print('---------------------');
//     }
//   } else {
//     print('Invalid response format or missing data');
//   }
// }

void main() async {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)){
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex){
      case 0:
        page = MyScoresPage();
        break;
      case 1:
        page = GeneratorPage();
        break;
      case 2:
        page = Placeholder();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.star),
                        label: Text('Scores'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of((context));
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty){
      return Center(
          child: Text('No Favorites Yet')
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have ' '${appState.favorites.length} favorites:'),
        ),

        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}




class ScoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ListView(
      children: [
        buildGameContainer('Washington Wizards', 'https://upload.wikimedia.org/wikipedia/fr/archive/d/d6/20161212034849%21Wizards2015.png', 102,
                          'Toronto Raptors', 'https://upload.wikimedia.org/wikipedia/fr/8/89/Raptors2015.png', 107),
        // Add more game containers as needed
      ],
    );
  }

  Widget buildGameContainer(String homeTeamName, String homeTeamLogoUrl, int homeScore, String visitorTeamName, String visitorTeamLogoUrl, int visitorScore) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}

class MyScoresPage extends StatefulWidget {
  const MyScoresPage({Key? key}) : super(key: key);

  @override
  _MyScoresPageState createState() => _MyScoresPageState();
}

class _MyScoresPageState extends State<MyScoresPage> {
  late Future<List<GameInfo>> futureGames;

  @override
  void initState() {
    String date = "2022-02-12"; // Replace with the desired date
    super.initState();
    futureGames = GamesService().fetchGamesByDate(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('People')),
        body: Center(
          child: FutureBuilder<List<GameInfo>>(
              future: futureGames,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        GameInfo game = snapshot.data?[index];
                        return ListTile(
                          title: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                      game.homeLogo,
                                      width: 30.0,
                                      height: 30.0,
                                    ),
                                    Text(
                                      game.homeTeamName,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Score: ${game.homeScore.toString()} ',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                      game.visitorLogo,
                                      width: 30.0,
                                      height: 30.0,
                                    ),
                                    Text(
                                      game.visitorTeamName,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Score: ${game.visitorScore.toString()}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: ((context, index) {
                        return const Divider(color: Colors.black);
                      }),
                      itemCount: snapshot.data!.length);

                } else if (snapshot.hasError) {
                  return(Text('ERROR: ${snapshot.error}'));
                }

                return const CircularProgressIndicator();
              }
          )
        )
    );
  }
}



// ListView.builder(
// itemCount: items.length,
// itemBuilder: (context, index) {
// final item = items[index];
// return ListTile(
// title: Text('Item $item'),
// trailing: const Icon(Icons.chevron_right_outlined),
// );
// }
// )
