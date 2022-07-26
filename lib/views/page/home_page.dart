// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fanmovie/model/landscape_caroseul_item.dart';
import 'package:fanmovie/views/components/landscape_carousel.dart';
import 'package:fanmovie/views/components/potrait_carousel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:fanmovie/services/tmdAPI/model/paginable_movie_result.dart';
import 'package:fanmovie/services/tmdAPI/movie_services.dart';
import 'package:fanmovie/style/app_colors.dart';
import 'package:fanmovie/views/components/custom_future_builder.dart';

import '../../model/potrait_carousel_item.dart';
import '../../services/tmdAPI/model/genre.dart';
import '../components/fake_search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MovieService mv = MovieService();
  late Future<void> loading;
  late PaginableMovieResult upcomingList;
  late PaginableMovieResult nowPlayingList;
  late PaginableMovieResult topRatedList;  
  late PaginableMovieResult popularList;
  late List<Genre> genresList;  
 
  void handlerFakeSearchPress(){
      print('CLicou no search');
  }

  Future<void> onRefreshPage() async {
    setState(() {
      loading = Future.wait<void>([
        (() async => upcomingList = await mv.getUpcoming())(),
        (() async => nowPlayingList = await mv.getNowPlaying())(),
        (() async => genresList = await mv.getGenres())(), 
        (() async => popularList = await mv.getPopular())(), 
        (() async => topRatedList = await mv.getTopRated())(),         
      ]);
    });
  }

  @override
  void initState() {
    super.initState();

    loading =  Future.wait<void>([
      (() async => upcomingList = await  mv.getUpcoming())(),
      (() async => nowPlayingList = await mv.getNowPlaying())(),
      (() async => genresList = await mv.getGenres())(),
      (() async => popularList = await mv.getPopular())(),
      (() async => topRatedList = await mv.getTopRated())(), 
    ]);

  }

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      future: loading,
      onComplete: (context, data) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: Icon(Icons.add_circle, color: AppColors.primary,),
            leadingWidth: 40,
            title: const Text('FanMovie', textAlign: TextAlign.left,),
            backgroundColor: AppColors.background,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: RefreshIndicator(
              onRefresh:onRefreshPage,
              child: SingleChildScrollView(                           
                physics: AlwaysScrollableScrollPhysics(), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FakeSearchBox(
                      onPress: handlerFakeSearchPress,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Em Breve',
                        style: TextStyle(
                          color: AppColors.onBackground,
                          fontSize: 20
                        ),
                      ),
                    ),
                    LandscapeCarousel(
                      items: upcomingList.results.where((element) => element.backdropPath != null && element.posterPath != null && element.releaseDate != null).map((e) => LandscapeCarouselItem(date: DateTime.parse(e.releaseDate.toString()), title: e.title, imageUrl: mv.getImageFromRelativePath(e.backdropPath.toString()).toString())).toList(),
                    ),
                    PotraitCarousel(
                      items: nowPlayingList.results
                          .where((element) =>
                              element.backdropPath != null &&
                              element.posterPath != null)
                          .map((e) => PotraitCarouselItem(imageUrl: mv.getImageFromRelativePath(e.posterPath.toString(), 300).toString(), title: e.title, stars: e.voteAverage ?? 0)).toList(),
                      tileTitle: 'Nos Cinemas',
                      onItemPressed: (p0) {
                        
                      },
                      onTilePressed: () {
                        
                      },

                     ),
                    PotraitCarousel(
                      items: popularList.results.where((element) => element.backdropPath != null && element.posterPath != null).map((e) => PotraitCarouselItem(imageUrl: mv.getImageFromRelativePath(e.posterPath.toString(), 300).toString(), title: e.title, stars: e.voteAverage ?? 0)).toList(),
                      tileTitle: 'Popular',
                      onItemPressed: (p0) {
                        
                      },
                      onTilePressed: () {
                        
                      },

                     ),
                    PotraitCarousel(
                      items: topRatedList.results
                          .where((element) =>
                              element.backdropPath != null &&
                              element.posterPath != null)
                          .map((e) => PotraitCarouselItem(imageUrl: mv.getImageFromRelativePath(e.posterPath.toString(), 300).toString(), title: e.title, stars: e.voteAverage ?? 0)).toList(),
                      tileTitle: 'Melhores Votados',
                      onItemPressed: (p0) {
                        
                      },
                      onTilePressed: () {
                        
                      },

                     ),                     
                  ],
                ),
              ),
            ) ,
          ),
        );
      },
      
      onError: (context, error) {
        return Scaffold(
            body: Container(
          color: Colors.pink,
        ));
      },
    );
  }
}

