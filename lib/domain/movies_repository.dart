import 'package:ultimate_movie_database/model/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getTrendingWeekMovies();
  Future<List<Movie>> getMoviesByTitle(String movieTitle, {int page = 1});
  Future<List<Movie>> getTopMovies({int page = 1});
  Future<List<Movie>> getMoviesFromWatchList();
  Future<void> addToWatchList(Movie movie);
  Future<void> removeFromWatchList(Movie movie);
}
