import 'package:ultimate_movie_database/data/genre/remote/genres_remote_impl.dart';
import 'package:ultimate_movie_database/data/genre/remote/mapper/genre_remote_impl.dart';
import 'package:ultimate_movie_database/domain/genres_repository.dart';
import 'package:ultimate_movie_database/model/genre.dart';

class GenresDataImpl extends GenresRepository {
  final GenresRemoteImpl _remoteImpl;

  GenresDataImpl({required GenresRemoteImpl remoteImpl})
      : _remoteImpl = remoteImpl;

  @override
  Future<List<Genre>> getGenres() async {
    try {
      final remoteGenres = await _remoteImpl.getGenres();
      return remoteGenres.map(GenreRemoteMapper.fromRemote).toList();
    } catch (e) {
      throw Exception('Error al obtener los géneros: $e');
    }
  }
}
