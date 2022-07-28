import 'package:fanmovie/services/tmdAPI/model/video.dart';

class Videos {
  Videos({
    required this.results,
  });
  late final List<Video> results;

  Videos.fromJson(Map<String, dynamic> json) {
    results =
        List.from(json['results']).map((e) => Video.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['results'] = results.map((e) => e.toJson()).toList();
    return data;
  }
}
