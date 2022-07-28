
import 'package:fanmovie/routes/main_route.dart';
import 'package:fanmovie/routes/routes.dart';
import 'package:fanmovie/style/theme.dart';
import 'package:fanmovie/views/page/movie_page.dart';
import 'package:fanmovie/views/page/search_page.dart';
import 'package:fanmovie/views/page/splash_screen_page.dart';
import 'package:fanmovie/views/page/home_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FanMovie',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: Routes.home,
      routes: {
        Routes.home :(context) => const MainBottonTabNav(),
        Routes.MovieDetails: (context) => MoviePage(),
      },
    );
  }

}