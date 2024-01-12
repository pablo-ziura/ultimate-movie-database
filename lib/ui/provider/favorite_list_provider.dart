import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ultimate_movie_database/di/app_modules.dart';
import 'package:ultimate_movie_database/domain/movies_repository.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';

class FavoriteListProvider extends ChangeNotifier {
  final MoviesRepository _moviesRepository = inject.get<MoviesRepository>();

  final StreamController<ResourceState<List<Movie>>> _moviesStreamController =
      StreamController.broadcast();

  Stream<ResourceState<List<Movie>>> get moviesStream =>
      _moviesStreamController.stream;

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  Future<void> fetchMoviesFromWatchList() async {
    _moviesStreamController.add(ResourceState.loading());
    try {
      _movies = await _moviesRepository.getMoviesFromWatchList();
      _moviesStreamController.add(ResourceState.success(_movies));
    } catch (e) {
      _moviesStreamController.add(ResourceState.error(Exception(e.toString())));
    }
  }

  Future<void> addToWatchList(Movie movie) async {
    try {
      await _moviesRepository.addToWatchList(movie);
      await fetchMoviesFromWatchList();
    } catch (e) {
      _moviesStreamController.add(ResourceState.error(Exception(e.toString())));
    }
  }

  Future<void> removeFromWatchList(Movie movie) async {
    try {
      await _moviesRepository.removeFromWatchList(movie);
      await fetchMoviesFromWatchList();
    } catch (e) {
      _moviesStreamController.add(ResourceState.error(Exception(e.toString())));
    }
  }

  @override
  void dispose() {
    _moviesStreamController.close();
    super.dispose();
  }
}
