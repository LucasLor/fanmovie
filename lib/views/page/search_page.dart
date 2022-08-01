import 'package:fanmovie/views/components/auto_complet_text_field.dart';
import 'package:fanmovie/views/components/custom_circular_progress_bar.dart';
import 'package:fanmovie/views/components/custom_list_tile.dart';
import 'package:fanmovie/views/components/search_infinite_Scroll.dart';
import 'package:fanmovie/views/components/search_item.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:fanmovie/services/tmdAPI/model/movie.dart';
import 'package:fanmovie/services/tmdAPI/model/paginable_movie_result.dart';
import 'package:fanmovie/services/tmdAPI/movie_services.dart';
import 'package:fanmovie/style/app_colors.dart';
import 'package:fanmovie/views/components/custom_future_builder.dart';
import 'package:fanmovie/views/components/potrait_carousel.dart';
import '../../model/potrait_carousel_item.dart';
import '../../routes/routes.dart';
import 'movie_page.dart';
import 'search_page copy.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final MovieService _movieService = MovieService();
  late Future<void> loading;
  late PaginableMovieResult dayTrendsList;
  final _pagingControllerBestOfWeek =
      PagingController<int, Movie>(firstPageKey: 1);
  String searchText = '';

  Future<void> fetchBestOfWeekMovies(int page) async {
    var results = await _movieService.getTrending(TimeWindown.week);
    if (results.results.isNotEmpty) {
      if (page <= results.totalPages) {
        _pagingControllerBestOfWeek.appendPage(results.results, page + 1);
      } else {
        _pagingControllerBestOfWeek.appendLastPage(results.results);
      }
    } else {
      _pagingControllerBestOfWeek.appendLastPage([]);
    }
  }

  void handlerOnSearchText(String text) {
    setState(() {
      searchText = text;
    });
  }

  @override
  void initState() {
    super.initState();

    _pagingControllerBestOfWeek.addPageRequestListener((pageKey) {
      fetchBestOfWeekMovies(pageKey);
    });

    loading = Future.wait<void>([
      (() async => dayTrendsList = await _movieService.getTrending(TimeWindown.day))(),
      (() async => await fetchBestOfWeekMovies(1))(),
    ]);
  }

  void openMovieDetails(int id) {
    Navigator.pushNamed(context, Routes.MovieDetails,
        arguments: MoviePageScreenArgs(movieID: id));
  }

void openCategoryMovies(MovieEndPoints endpoint, String title) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewMore(args: ViewMorePageScreenArgs(endpoint:endpoint, title: title),)));
  }
  
  Widget potraitCarrosuel() {
    return PotraitCarousel(
      items: dayTrendsList.results
          .map((e) => PotraitCarouselItemList(
              id: e.id,
              imageUrl: e.posterPath,
              title: e.title,
              stars: e.voteAverage))
          .toList(),
      tileTitle: 'Melhores do dia',
      onItemPressed: openMovieDetails,
      onTilePressed: ()=> openCategoryMovies(MovieEndPoints.trending, 'Melhores do dia'),
    );
  }
  
  Widget _onComplete(BuildContext context, dynamic data) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Icon(
          Icons.add_circle,
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
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AutoCompleteSearchWidget(
                onSubmitted: handlerOnSearchText,
                onChange: (_) {}
              ),
            Expanded(
              child: searchText.isEmpty ? trendsPage() : Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SearchInfiniteScroll(
                searchText: searchText,
                onPress: openMovieDetails,
            ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      future: loading,
      onComplete: _onComplete,
      onLoading: (context) => const CustomCircularProgressBar(),
    );
  }

  Widget trendsPage() {
    return PagedListView<int, Movie>(
      addAutomaticKeepAlives: true,
      pagingController: _pagingControllerBestOfWeek,
      builderDelegate: PagedChildBuilderDelegate<Movie>(
        itemBuilder: (context, item, index) {
          var searchitem = SearchItem(
            onPress: () => openMovieDetails(item.id),
              title: item.title,
              rating: item.voteAverage,
              releaseYear:
                  DateTime.parse(item.releaseDate ?? '0000-00-00').year,
              imageUrl: item.posterPath,
              overview: item.overview,
              genres: item.genreIds,
            );

          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                potraitCarrosuel(),
                CustomListTile(onTilePressed: (){}, tileTitle:  'Melhores da Semana'),
                searchitem,
                ],
            );
          }

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
