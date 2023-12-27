import 'package:ultimate_movie_database/data/genre/remote/model/genre_remote_model.dart';

class GenresNetworkResponse {
  List<GenreRemoteModel> genres;

  GenresNetworkResponse({
    required this.genres,
  });

  factory GenresNetworkResponse.fromMap(Map<String, dynamic> json) =>
      GenresNetworkResponse(
        genres: List<GenreRemoteModel>.from(
            json["genres"].map((x) => GenreRemoteModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "genres": List<dynamic>.from(genres.map((x) => x.toMap())),
      };
}
