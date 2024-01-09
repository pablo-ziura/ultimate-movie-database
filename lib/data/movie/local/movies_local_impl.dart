import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultimate_movie_database/data/movie/local/model/movie_local_model.dart';

class MoviesLocalImpl {
  static const watchListKey = 'watch_list';
  final SharedPreferences prefs;

  MoviesLocalImpl({required this.prefs});

  Future<void> addToWatchList(MovieLocalModel movie) async {
    List<MovieLocalModel> watchList = await getMoviesFromWatchList();

    if (!watchList.any((item) => item.id == movie.id)) {
      watchList.add(movie);
      List<String> watchListJson =
          watchList.map((movie) => json.encode(movie.toMap())).toList();
      await prefs.setStringList(watchListKey, watchListJson);
    }
  }

  Future<void> removeFromWatchList(MovieLocalModel movie) async {
    List<MovieLocalModel> watchList = await getMoviesFromWatchList();

    watchList.removeWhere((item) => item.id == movie.id);
    List<String> watchListJson =
        watchList.map((movie) => json.encode(movie.toMap())).toList();
    await prefs.setStringList(watchListKey, watchListJson);
  }

  Future<List<MovieLocalModel>> getMoviesFromWatchList() async {
    List<String> watchListJson = prefs.getStringList(watchListKey) ?? [];
    return watchListJson
        .map((str) => MovieLocalModel.fromMap(json.decode(str)))
        .toList();
  }
}
