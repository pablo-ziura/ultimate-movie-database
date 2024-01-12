import 'package:ultimate_movie_database/data/movie/local/model/movie_local_model.dart';
import 'package:ultimate_movie_database/model/movie.dart';

class MovieLocalMapper {
  static MovieLocalModel toLocal(Movie movie) {
    return MovieLocalModel(
      backdropPath: movie.backdropPath,
      id: movie.id,
      title: movie.title,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      posterPath: movie.posterPath,
      genreIds: movie.genreIds,
      popularity: movie.popularity,
      releaseDate: movie.releaseDate,
      video: movie.video,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
    );
  }

  static Movie fromLocal(MovieLocalModel localModel) {
    return Movie(
      backdropPath: localModel.backdropPath,
      id: localModel.id,
      title: localModel.title,
      originalTitle: localModel.originalTitle,
      overview: localModel.overview,
      posterPath: localModel.posterPath,
      genreIds: localModel.genreIds,
      popularity: localModel.popularity,
      releaseDate: localModel.releaseDate,
      video: localModel.video,
      voteAverage: localModel.voteAverage,
      voteCount: localModel.voteCount,
    );
  }
}
