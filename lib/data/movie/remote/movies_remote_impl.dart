import 'package:ultimate_movie_database/data/movie/remote/model/movie_remote_model.dart';
import 'package:ultimate_movie_database/data/movie/remote/model/movies_network_response_model.dart';
import 'package:ultimate_movie_database/data/remote/error/remote_error_mapper.dart';
import 'package:ultimate_movie_database/data/remote/network_client.dart';
import 'package:ultimate_movie_database/data/remote/network_constants.dart';

class MoviesRemoteImpl {
  final NetworkClient _networkClient;

  MoviesRemoteImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  Future<List<MovieRemoteModel>> getTrendingWeekMovies() async {
    try {
      final response = await _networkClient.dio.get(
        NetworkConstants.WEEK_TRENDING_MOVIES_URL,
        queryParameters: {'api_key': NetworkConstants.API_KEY},
      );

      if (response.statusCode == 200) {
        MoviesNetworkResponse moviesResponse =
            MoviesNetworkResponse.fromMap(response.data);
        return moviesResponse.results;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }

  Future<List<MovieRemoteModel>> getMoviesByTitle(String movieTitle,
      {int page = 1}) async {
    try {
      final response = await _networkClient.dio.get(
        NetworkConstants.SEARCH_MOVIE_URL,
        queryParameters: {
          'api_key': NetworkConstants.API_KEY,
          'query': movieTitle,
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        MoviesNetworkResponse moviesResponse =
            MoviesNetworkResponse.fromMap(response.data);
        return moviesResponse.results;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }

  Future<List<MovieRemoteModel>> getTopMovies({int page = 1}) async {
    try {
      final response = await _networkClient.dio.get(
        NetworkConstants.TOP_MOVIES_URL,
        queryParameters: {
          'api_key': NetworkConstants.API_KEY,
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        MoviesNetworkResponse moviesResponse =
            MoviesNetworkResponse.fromMap(response.data);
        return moviesResponse.results;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }
}
