import 'package:ultimate_movie_database/data/movie/local/mapper/movie_local_mapper.dart';
import 'package:ultimate_movie_database/data/movie/local/model/movie_local_model.dart';
import 'package:ultimate_movie_database/data/movie/local/movies_local_impl.dart';
import 'package:ultimate_movie_database/data/movie/remote/mapper/movie_remote_mapper.dart';
import 'package:ultimate_movie_database/data/movie/remote/movies_remote_impl.dart';
import 'package:ultimate_movie_database/domain/movies_repository.dart';
import 'package:ultimate_movie_database/model/movie.dart';

class MoviesDataImpl extends MoviesRepository {
  final MoviesRemoteImpl _remoteImpl;
  final MoviesLocalImpl _localImpl;

  MoviesDataImpl(this._localImpl, {required MoviesRemoteImpl remoteImpl})
      : _remoteImpl = remoteImpl;

  @override
  Future<List<Movie>> getTrendingWeekMovies() async {
    try {
      final remoteMovies = await _remoteImpl.getTrendingWeekMovies();
      return remoteMovies.map(MovieRemoteMapper.fromRemote).toList();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<List<Movie>> getMoviesByTitle(String movieTitle,
      {int page = 1}) async {
    try {
      final remoteMovies =
          await _remoteImpl.getMoviesByTitle(movieTitle, page: page);
      return remoteMovies.map(MovieRemoteMapper.fromRemote).toList();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<List<Movie>> getTopMovies({int page = 1}) async {
    try {
      final remoteMovies = await _remoteImpl.getTopMovies(page: page);
      return remoteMovies.map(MovieRemoteMapper.fromRemote).toList();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<void> addToWatchList(Movie movie) async {
    await _localImpl.addToWatchList(MovieLocalMapper.toLocal(movie));
  }

  @override
  Future<void> removeFromWatchList(Movie movie) async {
    await _localImpl.removeFromWatchList(MovieLocalMapper.toLocal(movie));
  }

  @override
  Future<List<Movie>> getMoviesFromWatchList() async {
    List<MovieLocalModel> localMovies =
        await _localImpl.getMoviesFromWatchList();
    return localMovies.map(MovieLocalMapper.fromLocal).toList();
  }
}
