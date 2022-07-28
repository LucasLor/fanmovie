// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fanmovie/views/components/auto_complet_text_field.dart';
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
import '../../services/tmdAPI/model/genre.dart';
import '../components/fake_search_bar.dart';

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
  final _pagingController =  PagingController<int, Movie>(firstPageKey: 2022);
  String searchText = '';

  void updateHasItem(bool hasItem) {
    setState(() {
      _hasItems = hasItem;
    });
  }

  void handlerSearchSubmit(){

  }

  /// Pesquisa pelos resultados por ano de forma descendente Ex: 2022, 2021, 2020 ... até 1878.
  void fetchData(int year) async {
    // Impede muitas requisições a API quando não não há filmes a serem carregados no respectivo ano.
    await Future.delayed(const Duration(milliseconds: 100), () {});

    if (year < 1878) {
      // Para de fazer requisição a API quando chega no último ano com filme.
      _pagingController.appendLastPage(List<Movie>.empty());
    } else {
      try {
        var movieResults =
            await sr.searchMovie('aa', getAll: true, primaryReleaseYear: year);
        movieResults.results.sort((a, b) => a.title.compareTo(b.title));
        _pagingController.appendPage(movieResults.results, year - 1);
      } on Exception catch (e) {
        print(
            'Page Search - Erro ao fazer request na página - $year :  ${e.toString()}');
        _pagingController.appendPage(List<Movie>.empty(), year - 1);
      }
    }
  }

  void handlerOnSearchText(String text){
    _pagingController.itemList?.clear();
    setState(() {
      searchText = text;
    });
    fetchData(2022);
  }

  @override
  void initState() {
    super.initState();

    _pagingController.addListener(() {
      updateHasItem(_pagingController.value.itemList != null &&
          _pagingController.itemList!.isNotEmpty);
    });
    _pagingController.addPageRequestListener((pageKey) {
      fetchData(pageKey);
    });

    loading = Future.wait<void>([
      (() async => dayTrendsList = await mv.getTrending(TimeWindown.day))(),
      // (() async => autoCompleteKeyword = (await sr.searchKeyword('av')).results)(),
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
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AutoCompleteSearchWidget(
                    onSelect: handlerOnSearchText,
                    onChange:   (t){
                      setState(() {
                        searchText = t;
                      });
                    }
                  ),
                  if (_hasItems)
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: PagedListView<int, Movie>(
                          addAutomaticKeepAlives: true,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          pagingController: _pagingController,
                          builderDelegate: PagedChildBuilderDelegate<Movie>(
                            itemBuilder: (context, item, index) {
                              return SearchItem(
                                  title: item.title,
                                  rating: item.voteAverage,
                                  releaseYear: DateTime.parse(
                                          item.releaseDate ?? '0000-00-00')
                                      .year,
                                  imageUrl: item.posterPath != ''
                                      ? mv
                                          .getImageFromRelativePath(
                                              item.posterPath, 300)
                                          .toString()
                                      : 'https://lightwidget.com/wp-content/uploads/local-file-not-found-480x488.png',
                                  overview: item.overview);
                            },
                          ),
                        ),
                      ),
                    )
                  else
                    Header(),
                ],
              ),
            ),
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

  Widget Header() {
    return PotraitCarousel(
      items: dayTrendsList.results
          .map((e) => PotraitCarouselItemList(
            id: e.id,
              imageUrl: mv
                  .getImageFromRelativePath(e.posterPath.toString(), 300)
                  .toString(),
              title: e.title,
              stars: e.voteAverage ?? 0))
          .toList(),
      tileTitle: 'Melhores do dia',
      onItemPressed: (p0) {},
      onTilePressed: () {},
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  } 
}
