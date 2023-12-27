import 'package:ultimate_movie_database/model/genre.dart';

abstract class GenresRepository {
  Future<List<Genre>> getGenres();
}
