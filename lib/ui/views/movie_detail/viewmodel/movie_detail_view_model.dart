import 'dart:async';

import 'package:ultimate_movie_database/domain/movies_repository.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/base/base_view_model.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';

class MovieDetailViewModel extends BaseViewModel {
  final MoviesRepository _moviesRepository;
  List<Movie> _watchListMovies = [];

  final StreamController<ResourceState<List<Movie>>> addToWatchListState =
      StreamController();

  final StreamController<ResourceState<List<Movie>>> removeFromWatchListState =
      StreamController();

  final StreamController<ResourceState<List<Movie>>>
      getMoviesFromWatchListState = StreamController();

  MovieDetailViewModel({required MoviesRepository moviesRepository})
      : _moviesRepository = moviesRepository;

  @override
  void dispose() {
    addToWatchListState.close();
    removeFromWatchListState.close();
    getMoviesFromWatchListState.close();
  }

  Future<void> addToWatchList(Movie movie) async {
    try {
      addToWatchListState.add(ResourceState.loading());
      await _moviesRepository.addToWatchList(movie);
      addToWatchListState.add(ResourceState.success([movie]));
    } catch (e) {
      addToWatchListState.add(
          ResourceState.error(e is Exception ? e : Exception(e.toString())));
    }
  }

  Future<void> removeFromWatchList(Movie movie) async {
    try {
      removeFromWatchListState.add(ResourceState.loading());
      await _moviesRepository.removeFromWatchList(movie);
      removeFromWatchListState.add(ResourceState.success([movie]));
    } catch (e) {
      removeFromWatchListState.add(
          ResourceState.error(e is Exception ? e : Exception(e.toString())));
    }
  }

  Future<void> fetchMoviesFromWatchList() async {
    try {
      getMoviesFromWatchListState.add(ResourceState.loading());
      _watchListMovies = await _moviesRepository.getMoviesFromWatchList();
      getMoviesFromWatchListState.add(ResourceState.success(_watchListMovies));
    } catch (e) {
      getMoviesFromWatchListState.add(
          ResourceState.error(e is Exception ? e : Exception(e.toString())));
    }
  }

  Future<bool> isMovieInWatchList(Movie movie) async {
    await fetchMoviesFromWatchList();
    return _watchListMovies
        .any((watchListMovie) => watchListMovie.id == movie.id);
  }
}
