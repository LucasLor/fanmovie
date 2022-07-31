import 'dart:convert';
import 'package:http/http.dart' as http;

import 'model/genre.dart';


class BaseApi {
  static const _APIKEY = 'be28a2cddb09eaaf152092a1267611a4';
  static const _BASEURL = 'api.themoviedb.org';
  static const _BASEIMAGEAPI = 'image.tmdb.org';
  static const NOTFOUNDIMAGE = 'https://lightwidget.com/wp-content/uploads/local-file-not-found-480x488.png';
  static List<Genre> genresList = [];
  
   Future<List<Genre>> updateGenres() async {
    try {
      List<Genre> g = await getGenres();
      if (g.isNotEmpty) {
        genresList.clear();
        genresList.addAll(g);
      }
      return g;
    } catch(e) {
      rethrow;
    }
  }

  ///Get the list of official genres for movies.
  Future<List<Genre>> getGenres() async {
    Map<String, String> headers = {'language': 'pt-BR'};
    Map<String, dynamic> responseMap =
        await getResponse('/genre/movie/list', headers);
    List<dynamic> genresMap = responseMap['genres'];
    List<Genre> genresList = genresMap.map((e) => Genre.fromJson(e)).toList();
    return genresList;
  }

  Uri getFullUrl(String endPoint, [Map<String, dynamic> params = const {}]) {
    Map<String, dynamic> newParams = Map<String, dynamic>.from(params);
    newParams.addAll({'api_key': _APIKEY});
    // Uri uri = Uri.https(_BASEURL, '/3$endPoint', newParams);
    // return  uri;

    Uri uri = Uri(
        scheme: 'https',
        host: _BASEURL,
        path: '/3/${endPoint.startsWith('/') ? endPoint.substring(1) : endPoint}',
        queryParameters: newParams);

    return uri;
  }

  static Uri getImageFromRelativePath2(String imageUrl, [int width = 0]) {
    Uri uri = Uri(
        scheme: 'https',
        host: _BASEIMAGEAPI,
        path: '/t/p/${width == 0 ? 'original' : 'w$width'}${imageUrl.startsWith('/') ? imageUrl : '/$imageUrl'}',
      );
      
    return uri;
  }
  
  Uri getImageFromRelativePath(String imageUrl, [int width = 0]) {
    Uri uri = Uri(
        scheme: 'https',
        host: _BASEIMAGEAPI,
        path: '/t/p/${width == 0 ? 'original' : 'w$width'}${imageUrl.startsWith('/') ? imageUrl : '/$imageUrl'}',
      );
      
    return uri;
  }

  Future<Map<String, dynamic>> getResponse(String endPoint, Map<String, String> headers) async {
    http.Response response = await http.get(getFullUrl(endPoint, headers));
    Map<String, dynamic> responseMap;
    if (response.statusCode == 200) {
      responseMap = jsonDecode(response.body);
    } else {
      throw Exception('Error: (${response.statusCode})');
    } 

    return responseMap;
  }

}
