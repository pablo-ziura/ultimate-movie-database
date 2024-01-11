import 'dart:async';

import 'package:ultimate_movie_database/domain/movies_repository.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/base/base_view_model.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';

class FavoriteMoviesViewModel extends BaseViewModel {
  final MoviesRepository _moviesRepository;

  final StreamController<ResourceState<List<Movie>>>
      getMoviesFromWatchListState = StreamController();

  FavoriteMoviesViewModel({required MoviesRepository moviesRepository})
      : _moviesRepository = moviesRepository;

  @override
  void dispose() {
    getMoviesFromWatchListState.close();
  }

  Future<void> fetchMoviesFromWatchList() async {
    getMoviesFromWatchListState.add(ResourceState.loading());
    _moviesRepository
        .getMoviesFromWatchList()
        .then((value) =>
            getMoviesFromWatchListState.add(ResourceState.success(value)))
        .catchError((error) =>
            getMoviesFromWatchListState.add(ResourceState.error(error)));
  }
}
