import 'package:fanmovie/services/tmdAPI/model/image_dat_info.dart';

class Images {
  Images({
    required this.backdrops,
    required this.logos,
    required this.posters,
  });
  late final List<ImageDataInfo> backdrops;
  late final List<ImageDataInfo> logos;
  late final List<ImageDataInfo> posters;

  Images.fromJson(Map<String, dynamic> json) {
    backdrops =
        List.from(json['backdrops']).map((e) => ImageDataInfo.fromJson(e)).toList();
    logos = List.from(json['logos']).map((e) => ImageDataInfo.fromJson(e)).toList();
    posters =
        List.from(json['posters']).map((e) => ImageDataInfo.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['backdrops'] = backdrops.map((e) => e.toJson()).toList();
    data['logos'] = logos.map((e) => e.toJson()).toList();
    data['posters'] = posters.map((e) => e.toJson()).toList();
    return data;
  }
}
