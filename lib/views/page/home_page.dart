// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fanmovie/routes/main_route.dart';
import 'package:fanmovie/routes/routes.dart';
import 'package:fanmovie/views/components/custom_try_again.dart';
import 'package:fanmovie/views/page/movie_page.dart';
import 'package:fanmovie/views/page/view_more_page.dart';
import 'package:flutter/material.dart';

import 'package:fanmovie/model/landscape_caroseul_item.dart';
import 'package:fanmovie/services/tmdAPI/model/paginable_movie_result.dart';
import 'package:fanmovie/services/tmdAPI/movie_services.dart';
import 'package:fanmovie/style/app_colors.dart';
import 'package:fanmovie/views/components/custom_circular_progress_bar.dart';
import 'package:fanmovie/views/components/custom_future_builder.dart';
import 'package:fanmovie/views/components/landscape_carousel.dart';
import 'package:fanmovie/views/components/potrait_carousel.dart';

import '../../model/potrait_carousel_item.dart';
import '../../services/tmdAPI/model/movie.dart';
import '../components/fake_search_bar.dart';

class HomePage extends StatefulWidget {
  // Usado para navegar entre as telas Home e Search
  final void Function(MainTabs)? navigateTo;

  const HomePage({
    Key? key,
    this.navigateTo,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MovieService _movieService = MovieService();
  late Future<void> _loading;
  late PaginableMovieResult _upcomingList;
  late PaginableMovieResult _nowPlayingList;
  late PaginableMovieResult _topRatedList;
  late PaginableMovieResult _popularList;

  void _handlerFakeSearchPress() {
    // Navega par a página de Search
    if (widget.navigateTo != null) {
      widget.navigateTo!(MainTabs.search);
    }
  }

  void _openMovieDetails(int id){
      Navigator.pushNamed(context, Routes.movieDetails, arguments: MoviePageScreenArgs(movieID: id));
  }

  void _openViewMorePage(MovieEndPoints endpoint, String title) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewMore(args: ViewMorePageScreenArgs(endpoint:endpoint, title: title),)));
  }

  Future<void> refreshPage() async {
    await _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = Future.wait<void>([
        (() async => _upcomingList = await _movieService.getUpcoming())(),
        (() async => _nowPlayingList = await _movieService.getNowPlaying())(),
        (() async => _popularList = await _movieService.getPopular())(),
        (() async => _topRatedList = await _movieService.getTopRated())(),
      ]);
    });
  }

  Widget _createPotraitCarrousel(String label, List<Movie> items, MovieEndPoints endpoint) {
    return PotraitCarousel(
      items: items
          .map((e) => PotraitCarouselItemList(
              imageUrl: e.posterPath, title: e.title, stars: e.voteAverage, id: e.id))
          .toList(),
      tileTitle: label,
      onItemPressed: _openMovieDetails,
      onTilePressed: ()=> _openViewMorePage(endpoint, label),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Widget _onCompletePage(BuildContext context, Object? data) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        leading: Icon(
          Icons.movie,
          color: AppColors.primary,
        ),
        leadingWidth: 40,
        title: const Text(
          'FanMovie',
          textAlign: TextAlign.left,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
        child: RefreshIndicator(
          onRefresh: refreshPage,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FakeSearchBox(
                  onPress: _handlerFakeSearchPress,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Em Breve',
                    style:
                        TextStyle(color: AppColors.onBackground, fontSize: 20),
                  ),
                ),
                LandscapeCarousel(
                  onPress: _openMovieDetails ,
                  items: _upcomingList.results
                      .map((e) => LandscapeCarouselListItems(
                        genres: e.genreIds,
                        id: e.id,
                          date: DateTime.parse(e.releaseDate.toString()),
                          title: e.title,
                          imageUrl: e.backdropPath))
                      .toList(),
                ),
                _createPotraitCarrousel('Nos Cinemas', _nowPlayingList.results, MovieEndPoints.nowPlaying), 
                _createPotraitCarrousel('Popular', _popularList.results, MovieEndPoints.pupular), 
                _createPotraitCarrousel('Melhores Votados', _topRatedList.results, MovieEndPoints.topRated), 
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _onErrorPage(BuildContext context, dynamic error) {
    return CustomTryAgain(onTryAgainPress: refreshPage);
  }

  Widget _onLoadingPage(BuildContext context) {
    return const CustomCircularProgressBar();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      future: _loading,
      onComplete: _onCompletePage,
      onLoading: _onLoadingPage,
      onError: _onErrorPage,
    );
  }
}
