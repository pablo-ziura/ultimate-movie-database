import 'package:ultimate_movie_database/model/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getTrendingWeekMovies();
}
