import 'package:fanmovie/services/tmdAPI/model/paginable_movie_result.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:fanmovie/services/tmdAPI/model/movie.dart';
import 'package:fanmovie/services/tmdAPI/movie_services.dart';
import 'package:fanmovie/services/tmdAPI/search_services.dart';
import 'package:fanmovie/views/components/search_item.dart';
import '../../routes/routes.dart';
import '../page/movie_page.dart';

class daasdasdasdasd extends StatefulWidget {
  String serarchText = '';

  daasdasdasdasd({Key? key, required this.serarchText}) : super(key: key);

  @override
  State<daasdasdasdasd> createState() => _daasdasdasdasdState();
}

class _daasdasdasdasdState extends State<daasdasdasdasd> {
  MovieService mv = MovieService();
  SearchService sr = SearchService();
  final _pagingControllerSearchResults =
      PagingController<int, Movie>(firstPageKey: 2022);

  /// Pesquisa pelos resultados por ano de forma descendente Ex: 2022, 2021, 2020 ... até 1878.
  void fetchData(int year) async {
    // Impede muitas requisições a API quando não não há filmes a serem carregados no respectivo ano.
    await Future.delayed(const Duration(milliseconds: 100), () {});

    if (year < 1878) {
      // Para de fazer requisição a API quando chega no último ano com filme.
      _pagingControllerSearchResults.appendLastPage(List<Movie>.empty());
    } else {
      try {
        var movieResults = await sr.searchMovie(widget.serarchText,
            getAll: true, primaryReleaseYear: year);
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

  @override
  void initState() {
    super.initState();

    _pagingControllerSearchResults.addPageRequestListener((pageKey) {
      fetchData(pageKey);
    });
  }

  void openMovieDetails(int id) {
    Navigator.pushNamed(context, Routes.MovieDetails,
        arguments: MoviePageScreenArgs(movieID: id));
  }

  Widget SearchPagedListView() {
    return PagedListView<int, Movie>(
      addAutomaticKeepAlives: true,
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

  @override
  Widget build(BuildContext context) {
    return SearchPagedListView();
  }

  @override
  void dispose() {
    _pagingControllerSearchResults.dispose();
    super.dispose();
  }
}

class Satasd extends StatefulWidget {
  final String searchText;

  Satasd({Key? key, required this.searchText}) : super(key: key);

  @override
  State<Satasd> createState() => _SatasdState();
}

class _SatasdState extends State<Satasd> {
  List<Movie> items = [];
  final controller = ScrollController();
  int page = 2022;
  bool hasMore = true;
  MovieService mv = MovieService();
  SearchService sr = SearchService();
  bool isloading = false;

  @override
  void initState() {
    hasMore = true;
    if (widget.searchText.isNotEmpty) {
      fetchData();
    }

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset && hasMore) {
        fetchData();
      }
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant Satasd oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reseta os itens do ListView para a nova pesquisa
    if (oldWidget.searchText != widget.searchText) {
      page = 2022;
      items.clear();
      controller.animateTo(0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.fastOutSlowIn);
          setState(() {
      hasMore = true;
            
          });
      fetchData();
    }
  }

  Future<PaginableMovieResult> fetch() async {
    var movieResults = await sr.searchMovie(widget.searchText, getAll: true, primaryReleaseYear: page);
    while (movieResults.results.isEmpty && isValidYear()) {
      print('loop page - $page');
      setState(() {
        page--;
      });
      await Future.delayed(const Duration(milliseconds: 200), () {});
      movieResults = await sr.searchMovie(widget.searchText, getAll: true, primaryReleaseYear: page);
    }

    return movieResults;
  }

  bool isValidYear() {
    return page >= 1878;
  }

  /// Pesquisa pelos resultados por ano de forma descendente Ex: 2022, 2021, 2020 ... até 1878.
  Future fetchData() async {
    if (!isValidYear()) {
      setState(() {
        hasMore = false;
      });
      return;
    }

    if (isloading) return;
    isloading = true;

    // Impede muitas requisições a API quando não não há filmes a serem carregados no respectivo ano.
    await Future.delayed(const Duration(milliseconds: 200), () {});
    print(page);

    try {
      var movieResults = await fetch();
      movieResults.results.sort((a, b) => a.title.compareTo(b.title));
      setState(() {
        page--;
        isloading = false;
        if(!isValidYear()){
          hasMore = false;
        }
        items.addAll(movieResults.results);
      });
    } on Exception catch (e) {
      print(
          'InfinitScroll - Erro ao fazer request na página - $page :  ${e.toString()}');
      setState(() {
        page--;
        isloading = false;
      });
      fetchData();
    }

    // Caso a primeira busca retorne poucos items, continua buscando dados até completar a tela.
    if (controller.position.hasContentDimensions) {
      if (controller.position.minScrollExtent ==
          controller.position.maxScrollExtent) {
        if (controller.position.maxScrollExtent < 1) {
          fetchData();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index < items.length) {
          return SearchItem(
              title: items[index].title,
              rating: items[index].voteAverage,
              releaseYear:
                  DateTime.parse(items[index].releaseDate ?? '0000-00-00').year,
              imageUrl: items[index].posterPath,
              overview: items[index].overview);
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: hasMore ? 30 : 0),
            child: Center(
              child: hasMore ? const CircularProgressIndicator() : Container(),
            ),
          );
        }
      },
    );
  }
}
