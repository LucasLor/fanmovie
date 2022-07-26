// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fanmovie/services/tmdAPI/base_api.dart';
import 'model/genre.dart';
import 'model/paginable_movie_result.dart';

enum TimeWindown {
  day,
  week
}

class MovieService extends BaseApi{

  Future<PaginableMovieResult> getUpcoming({page = 1}) async {
    Map<String, String> headers = {'language': 'pt-BR', 'page': page.toString()};
    Map<String, dynamic> responseMap = await getResponse('/movie/upcoming', headers);
    return PaginableMovieResult.fromJson(responseMap);
  }
  Future<PaginableMovieResult> getTopRated({page = 1}) async {
    Map<String, String> headers = {      'language': 'pt-BR',      'page': page.toString()    };
    Map<String, dynamic> responseMap = await getResponse('/movie/top_rated', headers);
    return PaginableMovieResult.fromJson(responseMap);
  }
  Future<PaginableMovieResult> getPopular({page = 1}) async {
    Map<String, String> headers = {      'language': 'pt-BR',      'page': page.toString()    };
    Map<String, dynamic> responseMap = await getResponse('/movie/popular', headers);
    return PaginableMovieResult.fromJson(responseMap);
  }
  Future<PaginableMovieResult> getNowPlaying({page = 1}) async {
    Map<String, String> headers = {      'language': 'pt-BR',      'page': page.toString()   , 'region': 'BR' };
    Map<String, dynamic> responseMap = await getResponse('/movie/now_playing', headers);
    return PaginableMovieResult.fromJson(responseMap);
  }

  Future<List<Genre>> getGenres() async {
    Map<String, String> headers = {'language': 'pt-BR'};
    Map<String, dynamic> responseMap = await getResponse('/genre/movie/list', headers);
    List<dynamic> genresMap = responseMap['genres'];
    List<Genre> genresList = genresMap.map((e) => Genre.fromJson(e)).toList();
    return genresList;
  }

  Future<PaginableMovieResult> getTrending(TimeWindown tw) async {
    Map<String, String> headers = {};
    Map<String, dynamic> responseMap = await getResponse('/trending/movie/${tw.name}', headers);
    return PaginableMovieResult.fromJson(responseMap);
  }  
}





