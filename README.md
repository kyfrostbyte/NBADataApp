# sport_scores

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


runApp(MyApp)


try {
final standings = await fetchStandings();
print(standings);
} catch (e) {
print('An error occurred: $e');
}
}


runApp(MyApp());

Completed things:


# Get data for NBA game by date
String date = "2022-02-12"; // Replace with the desired date
GamesByDate? gamesByDate = await fetchGamesByDate(date);

if (gamesByDate != null) {
for (GameInfo game in gamesByDate.games){
print("Team: ${game.visitorTeamName}, Score: ${game.visitorScore}, Logo: ${game.visitorLogo}");
print("Team: ${game.homeTeamName}, Score: ${game.homeScore}, Logo: ${game.homeLogo}");
print(" ");
}
}


# Get standings. Sorted by rank and conference
String date = "2021"; // Replace with the desired date
StandingsByYear? standingsByYear = await fetchStandings(date);

if (standingsByYear != null) {
standingsByYear.standings.sort((a, b) {
// First, sort by conference
int conferenceComparison = a.conference.compareTo(b.conference);

      // If the conferences are the same, sort by rank
      if (conferenceComparison == 0) {
        return a.rank.compareTo(b.rank);
      } else {
        return conferenceComparison;
      }
    });

    for (StandingsInfo standing in standingsByYear.standings) {
      print("Team: ${standing.name}, Rank: ${standing
          .rank}, Conference: ${standing.conference}");
    }
}