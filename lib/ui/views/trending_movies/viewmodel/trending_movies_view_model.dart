import 'dart:async';

import 'package:ultimate_movie_database/domain/movies_repository.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/base/base_view_model.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';

class TrendingMoviesViewModel extends BaseViewModel {
  final MoviesRepository _moviesRepository;

  final StreamController<ResourceState<List<Movie>>>
      getTrendingWeekMoviesState = StreamController();

  TrendingMoviesViewModel({required MoviesRepository moviesRepository})
      : _moviesRepository = moviesRepository;

  @override
  void dispose() {
    getTrendingWeekMoviesState.close;
  }

  fetchTrendingWeekMovies() {
    getTrendingWeekMoviesState.add(ResourceState.loading());

    _moviesRepository
        .getTrendingWeekMovies()
        .then((value) =>
            getTrendingWeekMoviesState.add(ResourceState.success(value)))
        .catchError((error) =>
            getTrendingWeekMoviesState.add(ResourceState.error(error)));
  }
}
