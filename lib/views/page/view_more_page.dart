// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fanmovie/views/components/custom_try_again.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:fanmovie/services/tmdAPI/model/movie.dart';
import 'package:fanmovie/services/tmdAPI/model/paginable_movie_result.dart';
import 'package:fanmovie/services/tmdAPI/movie_services.dart';
import 'package:fanmovie/style/app_colors.dart';
import 'package:fanmovie/views/components/search_item.dart';
import '../../routes/routes.dart';
import 'movie_page.dart';

class ViewMorePageScreenArgs {
  MovieEndPoints endpoint;
  String? title;
  TimeWindown? tw;
  int? movieId;

  ViewMorePageScreenArgs({
    required this.endpoint,
    this.title,
    this.tw,
    this.movieId,
  });
}

class ViewMore extends StatefulWidget {
  final ViewMorePageScreenArgs? args;

  const ViewMore({
    Key? key,
    this.args,
  }) : super(key: key);

  @override
  State<ViewMore> createState() => _ViewMoreState();
}

class _ViewMoreState extends State<ViewMore> {
  final _pagingControllerBestOfWeek =
      PagingController<int, Movie>(firstPageKey: 1);
  late Future<List<void>> loading;
  final ms = MovieService();
  late String title;
  bool hasError = false;

  Future<void> _getNextData(int page, MovieEndPoints endpoint,
      [TimeWindown tm = TimeWindown.day, int movieId = -1]) async {
    try {
      var results = await _fetch(page, endpoint, tm, movieId);

      if (results.results.isNotEmpty) {
        if (page <= results.totalPages) {
          _pagingControllerBestOfWeek.appendPage(results.results, page + 1);
        } else {
          _pagingControllerBestOfWeek.appendLastPage(results.results);
        }
      } else {
        _pagingControllerBestOfWeek.appendLastPage([]);
      }
    } catch (e) {
      setState(() {
        hasError = true;
      });
    }
  }

  Future<PaginableMovieResult> _fetch(int page, MovieEndPoints endpoint,
      [TimeWindown tm = TimeWindown.day, int movieId = -1]) async {
    PaginableMovieResult func;
    switch (endpoint) {
      case MovieEndPoints.topRated:
        func = await ms.getTopRated(page: page);
        break;
      case MovieEndPoints.nowPlaying:
        func = await ms.getNowPlaying(page: page);
        break;
      case MovieEndPoints.pupular:
        func = await ms.getPopular(page: page);
        break;
      case MovieEndPoints.upcoming:
        func = await ms.getUpcoming(page: page);
        break;
      case MovieEndPoints.details:
        throw UnimplementedError();
      case MovieEndPoints.trending:
        func = await ms.getTrending(tm);
        break;
      case MovieEndPoints.recommendations:
        if (movieId < 0) {
          throw ErrorDescription('É necessário informar um id válido');
        }
        func = await ms.getRecommendations(movieId, page);
        break;
    }
    return func;
  }

  @override
  void initState() {
    super.initState();

    if (widget.args == null) {
      hasError = true;
    }

    title = widget.args!.title ?? '';
    var tw = widget.args!.tw ?? TimeWindown.day;
    var movieId = widget.args!.movieId ?? -1;

    _pagingControllerBestOfWeek.addPageRequestListener((pageKey) {
      _getNextData(pageKey, widget.args!.endpoint, tw, movieId);
    });
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  void openMovieDetails(int id) {
    Navigator.pushNamed(context, Routes.movieDetails,
        arguments: MoviePageScreenArgs(movieID: id));
  }

  Widget _onComplete() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.onBackground),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
        child: scrollItems(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return hasError ? CustomTryAgain(onTryAgainPress: goBack) : _onComplete();
  }

  Widget scrollItems() {
    return PagedListView<int, Movie>(
      addAutomaticKeepAlives: true,
      pagingController: _pagingControllerBestOfWeek,
      builderDelegate: PagedChildBuilderDelegate<Movie>(
        itemBuilder: (context, item, index) {
          var searchitem = SearchItem(
            onPress: () => openMovieDetails(item.id),
            title: item.title,
            rating: item.voteAverage,
            releaseYear: DateTime.tryParse(item.releaseDate ?? '')?.year ?? 0,
            imageUrl: item.posterPath,
            overview: item.overview,
            genres: item.genreIds,
          );

          return searchitem;
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pagingControllerBestOfWeek.dispose();
  }
}
