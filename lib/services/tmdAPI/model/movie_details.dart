import 'package:fanmovie/services/tmdAPI/base_api.dart';

import 'belongs_to_collection.dart';
import 'credits.dart';
import 'genre.dart';
import 'images.dart';
import 'production_companies.dart';
import 'production_countries.dart';
import 'spoken_languages.dart';
import 'videos.dart';

class MovieDetails {
  MovieDetails({
    required this.adult,
    required this.backdropPath,
    required this.belongsToCollection,
    required this.budget,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.imdbId,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
     this.images,
     this.videos,
     this.credits,
  });
  late final bool adult;
  late final String backdropPath;
  late final BelongsToCollection? belongsToCollection;
  late final int budget;
  late final List<Genre> genres;
  late final String homepage;
  late final int id;
  late final String? imdbId;
  late final String originalLanguage;
  late final String originalTitle;
  late final String overview;
  late final double popularity;
  late final String posterPath;
  late final List<ProductionCompanies> productionCompanies;
  late final List<ProductionCountries> productionCountries;
  late final String releaseDate;
  late final int revenue;
  late final Duration runtime;
  late final List<SpokenLanguages> spokenLanguages;
  late final String status;
  late final String tagline;
  late final String title;
  late final bool video;
  late final double voteAverage;
  late final int voteCount;
  late final Images? images;
  late final Videos? videos;
  late final Credits? credits;

  MovieDetails.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'] != null ? BaseApi.getImageFromRelativePath2(json['backdrop_path']).toString() : BaseApi.notFoundImage;
    belongsToCollection = json['belongs_to_collection'] != null ?
        BelongsToCollection.fromJson(json['belongs_to_collection']) : null;
    budget = json['budget'];
    genres = List.from(json['genres']).map((e) => Genre.fromJson(e)).toList();
    homepage = json['homepage'];
    id = json['id'];
    imdbId = json['imdb_id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'] != null
        ? BaseApi.getImageFromRelativePath2(json['poster_path']).toString()
        : BaseApi.notFoundImage;
    productionCompanies = List.from(json['production_companies'])
        .map((e) => ProductionCompanies.fromJson(e))
        .toList();
    productionCountries = List.from(json['production_countries'])
        .map((e) => ProductionCountries.fromJson(e))
        .toList();
    releaseDate = json['release_date'];
    revenue = json['revenue'];
    runtime = json['runtime'] != null ? Duration(minutes: json['runtime']) : Duration();
    spokenLanguages = List.from(json['spoken_languages'])
        .map((e) => SpokenLanguages.fromJson(e))
        .toList();
    status = json['status'];
    tagline = json['tagline'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
    images =  json['images'] != null ? Images.fromJson(json['images']) : null;
    videos = json['videos'] != null ? Videos.fromJson(json['videos']) : null;
    credits = json['credits'] != null ? Credits.fromJson(json['credits']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['adult'] = adult;
    data['backdrop_path'] = backdropPath;
    data['belongs_to_collection'] = belongsToCollection?.toJson();
    data['budget'] = budget;
    data['genres'] = genres.map((e) => e.toJson()).toList();
    data['homepage'] = homepage;
    data['id'] = id;
    data['imdb_id'] = imdbId;
    data['original_language'] = originalLanguage;
    data['original_title'] = originalTitle;
    data['overview'] = overview;
    data['popularity'] = popularity;
    data['poster_path'] = posterPath;
    data['production_companies'] =
        productionCompanies.map((e) => e.toJson()).toList();
    data['production_countries'] =
        productionCountries.map((e) => e.toJson()).toList();
    data['release_date'] = releaseDate;
    data['revenue'] = revenue;
    data['runtime'] = runtime;
    data['spoken_languages'] = spokenLanguages.map((e) => e.toJson()).toList();
    data['status'] = status;
    data['tagline'] = tagline;
    data['title'] = title;
    data['video'] = video;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    data['images'] = images?.toJson();
    data['videos'] = videos?.toJson();
    data['credits'] = credits?.toJson();
    return data;
  }
}
