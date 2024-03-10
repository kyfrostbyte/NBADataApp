# Overview
I made this app as a way to break the ice in terms of my app building experience. Since this was my first mobile app development project, I wanted to start small, and tie in some of the work from
one of my previous projects. In the past I wrote a python program that analyzed NBA data that came by way of an API. I decided I would repurpose aspects of that program, and get the data
to display inside of an interactive app, instead of just the terminal. This forced me to learn concepts such as models, async methods, classes, and of course, many different widgets.

The app is pretty simple. It is made of up 2 screens, and a navigation rail on the side. The scores screen accepts an input from the user to specify a date. Once the date is received, the screen
will populate with all of the NBA games and their scores from that day. The second screen simply display the NBA rankings. The rankings information also comes from an API, but I did not have the chance
to make it so the user specify the year. So for now, it just always returns the same rankings from the same year.

[Software Demo Video](https://youtu.be/xpIii3My3Sc)

# Development Environment

I programmed the app in Android Studio using the Flutter framework. For the most part I just used the most basic of flutter libraries, such as material and convert.
The main one was the HTTP library, which is require to make API requests. I set up an android emulator, so I was able to test the app on that, as well as having it display in a browser.

# Useful Websites

* [Basic Flutter App Tutorial](https://codelabs.developers.google.com/codelabs/flutter-codelab-first#0)
* [Flutter API/Async Tutorial](https://www.youtube.com/watch?v=U7z5IeWuaLI&t=2333s&ab_channel=SimonGrimm)
* [API](https://rapidapi.com/)
* [Pub.dev](https://pub.dev/)

# Future Work

* Date picker calendar
* Search Standings by year
* Implement some sort of name based searching
* Login info
* Add more screens for things like player stats, team stats by game and season
* Implement a way to save certain searches, or responses of data
* Fix api_service class and gameservice classes. One class for the API request logic. Then a class for each model, and a class for each container of that model.