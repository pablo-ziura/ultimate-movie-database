import 'package:ultimate_movie_database/data/movie/remote/mapper/movie_remote_mapper.dart';
import 'package:ultimate_movie_database/data/movie/remote/movies_remote_impl.dart';
import 'package:ultimate_movie_database/domain/movies_repository.dart';
import 'package:ultimate_movie_database/model/movie.dart';

class MoviesDataImpl extends MoviesRepository {
  final MoviesRemoteImpl _remoteImpl;

  MoviesDataImpl({required MoviesRemoteImpl remoteImpl})
      : _remoteImpl = remoteImpl;

  @override
  Future<List<Movie>> getTrendingWeekMovies() async {
    try {
      final remoteMovies = await _remoteImpl.getTrendingWeekMovies();
      return remoteMovies.map(MovieRemoteMapper.fromRemote).toList();
    } catch (e) {
      throw Exception('Error al obtener películas: $e');
    }
  }
}
