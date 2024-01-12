import 'package:ultimate_movie_database/data/movie/remote/model/movie_remote_model.dart';
import 'package:ultimate_movie_database/model/movie.dart';

class MovieRemoteMapper {
  static Movie fromRemote(MovieRemoteModel remoteModel) {
    return Movie(
      backdropPath: remoteModel.backdropPath,
      id: remoteModel.id,
      title: remoteModel.title,
      overview: remoteModel.overview,
      posterPath: remoteModel.posterPath,
      releaseDate: remoteModel.releaseDate,
      voteAverage: remoteModel.voteAverage,
      voteCount: remoteModel.voteCount,
      originalTitle: remoteModel.originalTitle,
      genreIds: remoteModel.genreIds,
      popularity: remoteModel.popularity,
      video: remoteModel.video,
      budget: remoteModel.budget,
      revenue: remoteModel.revenue,
      runtime: remoteModel.runtime,
    );
  }
}
