import 'package:fanmovie/helper/date_helper.dart';
import 'package:fanmovie/services/tmdAPI/model/paginable_movie_result.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:fanmovie/services/tmdAPI/model/movie.dart';
import 'package:fanmovie/services/tmdAPI/movie_services.dart';
import 'package:fanmovie/services/tmdAPI/search_services.dart';
import 'package:fanmovie/views/components/search_item.dart';
import '../../routes/routes.dart';
import '../page/movie_page.dart';

class InfiniteScrollListView extends StatefulWidget {
  final String searchText;

  InfiniteScrollListView({Key? key, required this.searchText}) : super(key: key);

  @override
  State<InfiniteScrollListView> createState() => _InfiniteScrollListViewState();
}

class _InfiniteScrollListViewState extends State<InfiniteScrollListView> {
  List<Movie> items = [];
  final _scrollController = ScrollController();
  int page = getActualYear();
  bool hasMore = true;
  final SearchService _searchService = SearchService();
  bool isloading = false;

  @override
  void initState() {
    hasMore = true;

    if (widget.searchText.isNotEmpty) {
      fetchData();
    }

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset && hasMore) {
        fetchData();
      }
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant InfiniteScrollListView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reseta os itens do ListView para a nova pesquisa
    if (oldWidget.searchText != widget.searchText) {
      page = 2022;
      items.clear();
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.fastOutSlowIn);
          setState(() {
      hasMore = true;
            
          });
      fetchData();
    }
  }

  Future<PaginableMovieResult> fetch() async {
    var movieResults = await _searchService.searchMovie(widget.searchText, getAll: true, primaryReleaseYear: page);
    while (movieResults.results.isEmpty && isValidYear()) {
      print('loop page - $page');
      setState(() {
        page--;
      });
      await Future.delayed(const Duration(milliseconds: 200), () {});
      movieResults = await _searchService.searchMovie(widget.searchText, getAll: true, primaryReleaseYear: page);
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
    if (_scrollController.position.hasContentDimensions) {
      if (_scrollController.position.minScrollExtent ==
          _scrollController.position.maxScrollExtent) {
        if (_scrollController.position.maxScrollExtent < 1) {
          fetchData();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
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
              child: Column(
                children: [
                  hasMore && items.isNotEmpty ? const CircularProgressIndicator() : Container(),
                  !hasMore && items.isEmpty ? const Text("Nenhum item Encontrado", style: TextStyle(color: Colors.white),) : Container(),
                ],
              )
            ),
          );
        }
      },
    );
  }
}
