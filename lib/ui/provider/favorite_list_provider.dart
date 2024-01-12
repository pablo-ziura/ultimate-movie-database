import 'package:flutter/material.dart';
import 'package:ultimate_movie_database/domain/movies_repository.dart';
import 'package:ultimate_movie_database/model/movie.dart';

class FavoriteListProvider extends ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  final MoviesRepository _moviesRepository;
  bool _isLoading = false;

  FavoriteListProvider(this._moviesRepository);

  bool get isLoading => _isLoading;

  Future<void> fetchMoviesFromWatchList() async {
    _isLoading = true;

    try {
      _movies = await _moviesRepository.getMoviesFromWatchList();
    } catch (e) {
      print('Error fetching movies: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToWatchList(Movie movie) async {
    try {
      await _moviesRepository.addToWatchList(movie);
      await fetchMoviesFromWatchList();
    } catch (e) {
      print('Error adding movie to watch list: $e');
    }
  }

  Future<void> removeFromWatchList(Movie movie) async {
    try {
      await _moviesRepository.removeFromWatchList(movie);
      await fetchMoviesFromWatchList();
    } catch (e) {
      print('Error removing movie from watch list: $e');
    }
  }
}
