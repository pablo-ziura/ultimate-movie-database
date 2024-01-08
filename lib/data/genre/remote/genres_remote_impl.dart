import 'package:ultimate_movie_database/data/genre/remote/model/genre_remote_model.dart';
import 'package:ultimate_movie_database/data/genre/remote/model/genres_network_response_model.dart';
import 'package:ultimate_movie_database/data/remote/error/remote_error_mapper.dart';
import 'package:ultimate_movie_database/data/remote/network_client.dart';
import 'package:ultimate_movie_database/data/remote/network_constants.dart';

class GenresRemoteImpl {
  final NetworkClient _networkClient;

  GenresRemoteImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  Future<List<GenreRemoteModel>> getGenres() async {
    try {
      final response = await _networkClient.dio.get(
        NetworkConstants.MOVIE_CATEGORIES_URL,
        queryParameters: {'api_key': NetworkConstants.API_KEY},
      );

      if (response.statusCode == 200) {
        GenresNetworkResponse genresResponse =
            GenresNetworkResponse.fromMap(response.data);
        return genresResponse.genres;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }
}
