import 'package:fanmovie/services/tmdAPI/base_api.dart';

class BelongsToCollection {
  BelongsToCollection({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.backdropPath,
  });
  late final int id;
  late final String name;
  late final String posterPath;
  late final String backdropPath;

  BelongsToCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    posterPath = json['poster_path'] != null ? BaseApi.getImageFromRelativePath2(json['poster_path'], 600).toString() : BaseApi.notFoundImage;
    backdropPath = json['backdrop_path'] != null
        ? BaseApi.getImageFromRelativePath2(json['backdrop_path'], 600).toString()
        : BaseApi.notFoundImage;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['poster_path'] = posterPath;
    data['backdrop_path'] = backdropPath;
    return data;
  }
}
