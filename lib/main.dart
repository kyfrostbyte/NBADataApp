import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport_scores/api/models/standingsinfo.dart';
import 'api/api_service.dart';
import 'api/gameservice.dart';


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

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class StandingsPage extends StatefulWidget {
  @override
  _StandingsPageState createState() => _StandingsPageState();
}

class _StandingsPageState extends State<StandingsPage> {
  late Future<List<StandingsInfo>> standings;

  @override
  void initState() {
    super.initState();
    // Initialize the standings data when the widget is created
    String date = "2021"; // Replace with the desired date
    standings = ApiService().fetchStandings(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Standings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: Row(
            children: [
              // West Conference Standings
              Expanded(
                child: FutureBuilder<List<StandingsInfo>>(
                  future: standings,
                  builder: (context, AsyncSnapshot<List<StandingsInfo>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text("No data available for the West Conference.");
                    } else {
                      // Sort and filter West Conference Standings
                      List<StandingsInfo> westStandings = snapshot.data!
                          .where((info) => info.conference == "west")
                          .toList()
                        ..sort((a, b) => a.rank.compareTo(b.rank));
          
                      return buildStandingsColumn(westStandings);
                    }
                  },
                ),
              ),
              SizedBox(width: 16), // Add spacing between columns
              // East Conference Standings
              Expanded(
                child: FutureBuilder<List<StandingsInfo>>(
                  future: standings,
                  builder: (context, AsyncSnapshot<List<StandingsInfo>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text("No data available for the East Conference.");
                    } else {
                      // Sort and filter East Conference Standings
                      List<StandingsInfo> eastStandings = snapshot.data!
                          .where((info) => info.conference == "east")
                          .toList()
                        ..sort((a, b) => a.rank.compareTo(b.rank));
          
                      return buildStandingsColumn(eastStandings);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStandingsColumn(List<StandingsInfo> standings) {
    return ListView.separated(
      itemBuilder: (context, index) {
        StandingsInfo standingsInfo = standings[index];
        return ListTile(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                    standingsInfo.logo,
                    width: 30.0,
                    height: 30.0,
                  ),
                  Text(
                    standingsInfo.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rank: ${standingsInfo.rank.toString()}',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Text(
                'Conference: ${standingsInfo.conference}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
      separatorBuilder: ((context, index) {
        return const Divider(color: Colors.black);
      }),
      itemCount: standings.length,
    );
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
        page = StandingsPage();
        break;
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
                        icon: Icon(Icons.event_note_outlined),
                        label: Text('Scores'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.format_list_numbered_rtl_sharp),
                        label: Text('Rankings'),
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


class MyScoresPage extends StatefulWidget {
  const MyScoresPage({Key? key}) : super(key: key);

  @override
  _MyScoresPageState createState() => _MyScoresPageState();


}

class _MyScoresPageState extends State<MyScoresPage> {
  late Future<List<GameInfo>> futureGames;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    String date = "2022-02-12"; // Replace with the desired date
    super.initState();
    futureGames = GamesService().fetchGamesByDate(date);
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void onDateSelected(String date) {
    // Implement the logic for handling the selected date here
    setState(() {
      futureGames = GamesService().fetchGamesByDate(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NBA Scores By Date')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add a TextField for input above the FutureBuilder
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Enter Date (YYYY-MM-DD)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onDateSelected(_dateController.text);
              },
              child: Text('Get Games'),
            ),
            SizedBox(height: 20),
            // The FutureBuilder for displaying the list
            FutureBuilder<List<GameInfo>>(
              future: futureGames,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        GameInfo game = snapshot.data?[index];
                        return ListTile(
                          title: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Image.network(
                                    game.homeLogo,
                                    width: 30.0,
                                    height: 30.0,
                                  ),
                                  Text(
                                    game.homeTeamName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Score: ${game.homeScore.toString()} ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Image.network(
                                    game.visitorLogo,
                                    width: 30.0,
                                    height: 30.0,
                                  ),
                                  Text(
                                    game.visitorTeamName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Score: ${game.visitorScore.toString()}',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: ((context, index) {
                        return const Divider(color: Colors.black);
                      }),
                      itemCount: snapshot.data!.length,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('ERROR: ${snapshot.error}');
                }

                return const SizedBox(); // Return an empty container or some default widget
              },
            ),
          ],
        ),
      ),
    );
  }
}

