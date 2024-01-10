import 'dart:async';

import 'package:ultimate_movie_database/domain/movies_repository.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/base/base_view_model.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';

class FavoriteMoviesViewModel extends BaseViewModel {
  final MoviesRepository _moviesRepository;
  List<Movie> _watchListMovies = [];

  final StreamController<ResourceState<List<Movie>>>
      getMoviesFromWatchListState = StreamController();

  FavoriteMoviesViewModel({required MoviesRepository moviesRepository})
      : _moviesRepository = moviesRepository;

  @override
  void dispose() {
    getMoviesFromWatchListState.close();
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
}
