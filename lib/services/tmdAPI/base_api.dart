import 'dart:convert';
import 'package:http/http.dart' as http;


abstract class BaseApi {
  final _APIKEY = 'be28a2cddb09eaaf152092a1267611a4';
  final _BASEURL = 'api.themoviedb.org';
  final _BASEIMAGEAPI = 'image.tmdb.org';

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

  Uri getImageFromRelativePath(String imageUrl, [int width = 0]) {
    Uri uri = Uri(
        scheme: 'https',
        host: _BASEIMAGEAPI,
        path: '/t/p/${width == 0 ? 'original' : 'w$width'}${imageUrl.startsWith('/') ? imageUrl : '/$imageUrl'}',
      );
      
    return uri;
  }

  Future<Map<String, dynamic>> getResponse(
      String endPoint, Map<String, String> headers) async {
    http.Response response = await http.get(getFullUrl(endPoint, headers));
    Map<String, dynamic> responseMap;

    if (response.statusCode == 200) {
      responseMap = jsonDecode(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 404) {
      responseMap = jsonDecode(response.body);
      throw Exception(
          'Error: (${response.statusCode})  ${responseMap['status_message']}');
    } else {
      throw Exception('Error ao fazer request: endpoint: $endPoint');
    }

    return responseMap;
  }

}
