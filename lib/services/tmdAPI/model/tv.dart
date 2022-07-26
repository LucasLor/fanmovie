class Tv {
  Tv({
    this.backdropPath,
    required this.firstAirDate,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });
  late final String? backdropPath;
  late final String firstAirDate;
  late final List<int> genreIds;
  late final int id;
  late final String name;
  late final List<String> originCountry;
  late final String originalLanguage;
  late final String originalName;
  late final String overview;
  late final double popularity;
  late final String? posterPath;
  late final double voteAverage;
  late final int voteCount;

  Tv.fromJson(Map<String, dynamic> json) {
    backdropPath = json['backdrop_path'];
    firstAirDate = json['first_air_date'];
    genreIds = List.castFrom<dynamic, int>(json['genre_ids']);
    id = json['id'];
    name = json['name'];
    originCountry = List.castFrom<dynamic, String>(json['origin_country']);
    originalLanguage = json['original_language'];
    originalName = json['original_name'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['backdrop_path'] = backdropPath;
    data['first_air_date'] = firstAirDate;
    data['genre_ids'] = genreIds;
    data['id'] = id;
    data['name'] = name;
    data['origin_country'] = originCountry;
    data['original_language'] = originalLanguage;
    data['original_name'] = originalName;
    data['overview'] = overview;
    data['popularity'] = popularity;
    data['poster_path'] = posterPath;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    return data;
  }
}
