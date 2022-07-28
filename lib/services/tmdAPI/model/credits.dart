import 'cast.dart';
import 'crew.dart';

class Credits {
  Credits({
    required this.cast,
    required this.crew,
  });
  late final List<Cast> cast;
  late final List<Crew> crew;

  Credits.fromJson(Map<String, dynamic> json) {
    cast = List.from(json['cast']).map((e) => Cast.fromJson(e)).toList();
    crew = List.from(json['crew']).map((e) => Crew.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['cast'] = cast.map((e) => e.toJson()).toList();
    data['crew'] = crew.map((e) => e.toJson()).toList();
    return data;
  }
}
