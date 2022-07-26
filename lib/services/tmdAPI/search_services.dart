import 'package:fanmovie/services/tmdAPI/base_api.dart';
import 'package:fanmovie/services/tmdAPI/model/keyword.dart';
import 'package:fanmovie/services/tmdAPI/model/paginable_keyword_result.dart';
import 'model/movie.dart';
import 'model/paginable_movie_result.dart';


class SearchService extends BaseApi {

  /// primaryReleaseYear = 2022, 2021, 2020 ...
   Future<PaginableMovieResult> searchMovie(String query, {adult = false, page = 1, primaryReleaseYear = 0, getAll = false}) async {
    // primaryReleaseYear != do padrão 2022 é ignorado.
    Map<String, String> headers = {'language': 'pt-BR',
     'page': '$page',
      'include_adult': '$adult',
       'query': query, 
       'primary_release_year': '$primaryReleaseYear'
       };
    Map<String, dynamic> responseMap = await getResponse('/search/movie', headers);
    var responseObject = PaginableMovieResult.fromJson(responseMap);
    if(getAll && responseObject.totalPages > 1){
      for (var i = 2; i < responseObject.totalPages + 1; i++) {
        headers.update('page', (value) => '$i');
          Map<String, dynamic> abcdef = await getResponse('/search/movie',headers );
          responseObject.results.addAll(
            List.from(abcdef['results']).map((e) => Movie.fromJson(e)).toList()
          );
      }
    }
    return  responseObject;
  }

   Future<PaginableMovieResult> searchTv(String query, {adult = false, page = 1}) async {
    Map<String, String> headers = {'language': 'pt-BR', 'page': page, 'include_adult': adult};
    Map<String, dynamic> responseMap = await getResponse('/search/tv}', headers);
    return PaginableMovieResult.fromJson(responseMap);
  }

   Future<PaginableKeywordResult> searchKeyword(String query, {page = 1}) async {
    Map<String, String> headers = {'language': 'pt-BR', 'page': '$page',  'query': query};
    Map<String, dynamic> responseMap = await getResponse('/search/keyword', headers);
    return PaginableKeywordResult.fromJson(responseMap);
  }

   Future<List<Keyword>> movieSuggest(String query, {page = 1}) async {
    Map<String, String> headers = {'language': 'pt-BR', 'page': '$page',  'query': query};
    Map<String, dynamic> responseMap = await getResponse('/search/movie', headers);
    var keywordMap = (responseMap['results'] as Iterable<dynamic>).map((e) => Keyword.fromJson({'name': e['title'], 'id':e['id']}));
    return keywordMap.toList();
  }
  
}