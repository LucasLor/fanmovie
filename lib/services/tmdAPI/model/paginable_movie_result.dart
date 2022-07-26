import 'base_paginable_result.dart';
import 'dates.dart';
import 'movie.dart';

class PaginableMovieResult extends BasePaginableResult {
  late final List<Movie> results;

  PaginableMovieResult({
    dates,
    required page,
    required totalPages,
    required totalResults,
    required this.results,
  });

  PaginableMovieResult.fromJson(Map<String, dynamic> json) {
    dates = json['dates'] != null ?  Dates.fromJson(json['dates']) : null;
    page = json['page'];
    results =
        List.from(json['results']).map((e) => Movie.fromJson(e)).toList();
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['dates'] = dates?.toJson();
    data['page'] = page;
    data['results'] = results.map((e) => e.toJson()).toList();
    data['total_pages'] = totalPages;
    data['total_results'] = totalResults;
    return data;
  }
}
