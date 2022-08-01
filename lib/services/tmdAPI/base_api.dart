import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/genre.dart';

class BaseApi {
  static const _apiKey = 'be28a2cddb09eaaf152092a1267611a4';
  static const _baseUrl = 'api.themoviedb.org';
  static const _baseImageUrl = 'image.tmdb.org';
  static const notFoundImage =
      'https://lightwidget.com/wp-content/uploads/local-file-not-found-480x488.png';
  static List<Genre> genresList = [];
  static String language = 'pt-BR';

  Future<List<Genre>> updateGenres() async {
    List<Genre> g = await getGenres();
    if (g.isNotEmpty) {
      genresList.clear();
      genresList.addAll(g);
    }
    return g;
  }

  static void setLanguage(String lang) {
    language = lang;
  }

  ///Get the list of official genres.
  Future<List<Genre>> getGenres() async {
    Map<String, String> headers = getQueryParameters({});

    Map<String, dynamic> responseMap =
        await getResponse('/genre/movie/list', headers);
    List<dynamic> genresMap = responseMap['genres'];
    List<Genre> genresList = genresMap.map((e) => Genre.fromJson(e)).toList();
    return genresList;
  }

  Uri getFullUrl(String endPoint, [Map<String, dynamic> params = const {}]) {
    Uri uri = Uri(
        scheme: 'https',
        host: _baseUrl,
        path:
            '/3/${endPoint.startsWith('/') ? endPoint.substring(1) : endPoint}',
        queryParameters: params);

    return uri;
  }

  static Uri getImageFromRelativePath2(String imageUrl, [int width = 0]) {
    Uri uri = Uri(
      scheme: 'https',
      host: _baseImageUrl,
      path:
          '/t/p/${width == 0 ? 'original' : 'w$width'}${imageUrl.startsWith('/') ? imageUrl : '/$imageUrl'}',
    );

    return uri;
  }

  Future<Map<String, dynamic>> getResponse(
      String endPoint, Map<String, String> headers) async {
    http.Response response = await http.get(getFullUrl(endPoint, headers));
    Map<String, dynamic> responseMap;
    if (response.statusCode == 200) {
      responseMap = jsonDecode(response.body);
    } else {
      throw Exception('Error: (${response.statusCode})');
    }

    return responseMap;
  }

// Concatena os parâmetros atuais com os parâmetros default.
  Map<String, String> getQueryParameters(Map<String, String> header) {
    Map<String, String> defaultparams = {
      'language': language,
      'api_key': _apiKey
    };
    for (var i = 0; i < header.length; i++) {
      defaultparams.update(
          header.keys.elementAt(i), (value) => header.values.elementAt(i),
          ifAbsent: () => header.values.elementAt(i));
    }
    return defaultparams;
  }
}
