// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fanmovie/views/components/auto_complet_text_field.dart';
import 'package:fanmovie/views/components/custom_list_tile.dart';
import 'package:fanmovie/views/components/infinite_Scroll.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:fanmovie/model/landscape_caroseul_item.dart';
import 'package:fanmovie/services/tmdAPI/model/keyword.dart';
import 'package:fanmovie/services/tmdAPI/model/movie.dart';
import 'package:fanmovie/services/tmdAPI/model/paginable_keyword_result.dart';
import 'package:fanmovie/services/tmdAPI/model/paginable_movie_result.dart';
import 'package:fanmovie/services/tmdAPI/movie_services.dart';
import 'package:fanmovie/services/tmdAPI/search_services.dart';
import 'package:fanmovie/style/app_colors.dart';
import 'package:fanmovie/views/components/custom_future_builder.dart';
import 'package:fanmovie/views/components/landscape_carousel.dart';
import 'package:fanmovie/views/components/potrait_carousel.dart';
import 'package:fanmovie/views/components/search_item.dart';
import 'package:fanmovie/helper/date_helper.dart' as dt;
import '../../model/potrait_carousel_item.dart';
import '../../routes/routes.dart';
import '../../services/tmdAPI/model/genre.dart';
import '../components/fake_search_bar.dart';
import 'movie_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  MovieService mv = MovieService();
  SearchService sr = SearchService();
  late Future<void> loading;
  late PaginableMovieResult dayTrendsList;
  bool _hasItems = false;
  final _pagingControllerSearchResults =
      PagingController<int, Movie>(firstPageKey: 2022);
  final _pagingControllerBestOfWeek =
      PagingController<int, Movie>(firstPageKey: 1);
  String searchText = '';

  void updateHasItem(bool hasItem) {
    setState(() {
      _hasItems = hasItem;
    });
  }

  /// Pesquisa pelos resultados por ano de forma descendente Ex: 2022, 2021, 2020 ... até 1878.
  void fetchData(int year) async {

    
    // Impede muitas requisições a API quando não não há filmes a serem carregados no respectivo ano.
    await Future.delayed(const Duration(milliseconds: 100), () {});

    if (year < 1878) {
      // Para de fazer requisição a API quando chega no último ano com filme.
      _pagingControllerSearchResults.appendLastPage(List<Movie>.empty());
    } else {
      try {
        var movieResults =
            await sr.searchMovie(searchText, getAll: true, primaryReleaseYear: year);
        movieResults.results.sort((a, b) => a.title.compareTo(b.title));
        _pagingControllerSearchResults.appendPage(
            movieResults.results, year - 1);
      } on Exception catch (e) {
        print(
            'Page Search - Erro ao fazer request na página - $year :  ${e.toString()}');
        _pagingControllerSearchResults.appendPage(
            List<Movie>.empty(), year - 1);
      }
    }
  }

  Future<void> fetchBestOfWeekMovies(int page) async {
    var results = await mv.getPopular();
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

    return;
    if(_pagingControllerSearchResults!.itemList!.isNotEmpty){
      _pagingControllerSearchResults!.itemList!.clear();
    }
    print(searchText);
   _pagingControllerSearchResults.nextPageKey = 2022;
   _pagingControllerSearchResults.notifyPageRequestListeners(2022);
    fetchData(2022);
  }

  @override
  void initState() {
    super.initState();

    _pagingControllerSearchResults.addListener(() {
      updateHasItem(_pagingControllerSearchResults.value.itemList != null &&
          _pagingControllerSearchResults.itemList!.isNotEmpty);

          print('Tem items ' + _hasItems.toString());
    });
    _pagingControllerSearchResults.addPageRequestListener((pageKey) {
      fetchData(pageKey);
    });
    _pagingControllerBestOfWeek.addPageRequestListener((pageKey) {
      fetchBestOfWeekMovies(pageKey);
    });

    loading = Future.wait<void>([
      (() async => dayTrendsList = await mv.getTrending(TimeWindown.day))(),
      (() async => await fetchBestOfWeekMovies(1))(),
    ]);
  }

  void openMovieDetails(int id) {
    Navigator.pushNamed(context, Routes.MovieDetails,
        arguments: MoviePageScreenArgs(movieID: id));
  }

  Widget SearchPagedListView() {
    return PagedListView<int, Movie>(
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      pagingController: _pagingControllerSearchResults,
      builderDelegate: PagedChildBuilderDelegate<Movie>(
        itemBuilder: (context, item, index) {
          return SearchItem(
              title: item.title,
              rating: item.voteAverage,
              releaseYear:
                  DateTime.parse(item.releaseDate ?? '0000-00-00').year,
              imageUrl: item.posterPath,
              overview: item.overview);
        },
      ),
    );
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
      onTilePressed: () {},
    );
  }

  Widget vdssaad(){
    daasdasdasdasd d = daasdasdasdasd(serarchText: searchText,);
return Satasd(searchText: searchText,);
    if(searchText.isEmpty){
      return Header();
    }


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
                onChange: (t) {
                  
                }),
            Expanded(
              child: Satasd(
              searchText: searchText,
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
      onError: (context, error) {
        return Scaffold(
            body: Container(
          color: Colors.pink,
        ));
      },
    );
  }

  Widget Header() {
    return PagedListView<int, Movie>(
      addAutomaticKeepAlives: true,
      scrollDirection: Axis.vertical,
      pagingController: _pagingControllerBestOfWeek,
      builderDelegate: PagedChildBuilderDelegate<Movie>(
        itemBuilder: (context, item, index) {
          var searchitem = SearchItem(
              title: item.title,
              rating: item.voteAverage,
              releaseYear:
                  DateTime.parse(item.releaseDate ?? '0000-00-00').year,
              imageUrl: item.posterPath,
              overview: item.overview,
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
    _pagingControllerSearchResults.dispose();
    super.dispose();
  }
}
