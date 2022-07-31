import 'package:fanmovie/services/tmdAPI/base_api.dart';

class ImageDataInfo {
  ImageDataInfo({
    required this.aspectRatio,
    required this.height,
    this.iso_639_1,
    required this.filePath,
    required this.voteAverage,
    required this.voteCount,
    required this.width,
  });
  late final double aspectRatio;
  late final int height;
  late final String? iso_639_1;
  late final String filePath;
  late final double? voteAverage;
  late final int voteCount;
  late final int width;

  ImageDataInfo.fromJson(Map<String, dynamic> json) {
    aspectRatio = json['aspect_ratio'];
    height = json['height'];
    iso_639_1 = null;
    filePath = json['file_path'] != null && (json['file_path'] as String).isNotEmpty ? BaseApi.getImageFromRelativePath2(json['file_path'], 600).toString() : BaseApi.NOTFOUNDIMAGE;
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['aspect_ratio'] = aspectRatio;
    data['height'] = height;
    data['iso_639_1'] = iso_639_1;
    data['file_path'] = filePath;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    data['width'] = width;
    return data;
  }
}
