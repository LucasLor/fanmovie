// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:fanmovie/services/tmdAPI/base_api.dart';
import 'package:fanmovie/services/tmdAPI/model/movie_details.dart';

import 'model/genre.dart';
import 'model/paginable_movie_result.dart';

enum TimeWindown { day, week }

/// Lista de Endpoints disponíveis
enum MovieEndPoints{
  upcoming,
  topRated,
  pupular,
  nowPlaying,
  details,
  trending,
  recommendations
}

class MovieService extends BaseApi {
  /// Get a list of upcoming movies in theatres. This is a release type query that looks for all movies that have a release type of 2 or 3 within the specified date range.
  Future<PaginableMovieResult> getUpcoming({page = 1}) async {
    Map<String, String> headers = {
      'language': 'pt-BR',
      'page': page.toString()
    };
    Map<String, dynamic> responseMap =
        await getResponse('/movie/upcoming', headers);
    return PaginableMovieResult.fromJson(responseMap);
  }

  /// Get the top rated movies on TMDB.
  Future<PaginableMovieResult> getTopRated({page = 1}) async {
    Map<String, String> headers = {
      'language': 'pt-BR',
      'page': page.toString()
    };
    if(BaseApi.genresList.isEmpty){
        await updateGenres();
    }
    Map<String, dynamic> responseMap =
        await getResponse('/movie/top_rated', headers);
    return PaginableMovieResult.fromJson(responseMap);
  }

  /// Get a list of the current popular movies on TMDB. This list updates daily.
  Future<PaginableMovieResult> getPopular({page = 1}) async {
    Map<String, String> headers = {
      'language': 'pt-BR',
      'page': page.toString()
    };
    if (BaseApi.genresList.isEmpty) {
      await updateGenres();
    }
    Map<String, dynamic> responseMap =
        await getResponse('/movie/popular', headers);
    return PaginableMovieResult.fromJson(responseMap);
  }

  /// Get a list of movies in theatres. This is a release type query that looks for all movies that have a release type of 2 or 3 within the specified date range.
  Future<PaginableMovieResult> getNowPlaying({page = 1}) async {
    Map<String, String> headers = {
      'language': 'pt-BR',
      'page': page.toString(),
      'region': 'BR'
    };
    if (BaseApi.genresList.isEmpty) {
      await updateGenres();
    }
    Map<String, dynamic> responseMap =
        await getResponse('/movie/now_playing', headers);
    return PaginableMovieResult.fromJson(responseMap);
  }

  Future<PaginableMovieResult> getTrending(TimeWindown tw) async {
    Map<String, String> headers = {};
    Map<String, dynamic> responseMap =
        await getResponse('/trending/movie/${tw.name}', headers);
    return PaginableMovieResult.fromJson(responseMap);
  }

  /// Get the primary information about a movie.
  Future<MovieDetails> getDetails(int movieID) async {
    Map<String, String> headers = {
      'language': 'pt-BR',
      'append_to_response': 'images,videos,credits'
    };
    if (BaseApi.genresList.isEmpty) {
      await updateGenres();
    }
    Map<String, dynamic> responseMap =
        await getResponse('/movie/$movieID', headers);
    return MovieDetails.fromJson(responseMap);
  }

  /// Get a list of recommended movies for a movie.
  Future<PaginableMovieResult> getRecommendations(int movieID) async {
    Map<String, String> headers = {
      'language': 'pt-BR',
      'append_to_response': 'images,videos,credits'
    };
    if (BaseApi.genresList.isEmpty) {
      await updateGenres();
    }
    Map<String, dynamic> responseMap =
        await getResponse('/movie/$movieID/recommendations', headers);
    return PaginableMovieResult.fromJson(responseMap);
  }
}
