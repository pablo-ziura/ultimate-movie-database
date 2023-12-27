import 'package:ultimate_movie_database/data/movie/remote/model/movie_remote_model.dart';

class MoviesNetworkResponse {
  int page;
  List<MovieRemoteModel> results;
  int totalPages;
  int totalResults;

  MoviesNetworkResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesNetworkResponse.fromMap(Map<String, dynamic> json) =>
      MoviesNetworkResponse(
        page: json["page"],
        results: List<MovieRemoteModel>.from(
            json["results"].map((x) => MovieRemoteModel.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toMap() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}
