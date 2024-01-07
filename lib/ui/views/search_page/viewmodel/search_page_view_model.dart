import 'dart:async';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ultimate_movie_database/domain/movies_repository.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/base/base_view_model.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';

class SearchMovieViewModel extends BaseViewModel {
  final MoviesRepository _moviesRepository;

  final PagingController<int, Movie> pagingController =
      PagingController(firstPageKey: 1);

  final StreamController<ResourceState<List<Movie>>> getMoviesByTitleState =
      StreamController();

  SearchMovieViewModel({required MoviesRepository moviesRepository})
      : _moviesRepository = moviesRepository;

  @override
  void dispose() {
    pagingController.dispose();
    getMoviesByTitleState.close();
  }

  fetchMoviesByTitle(String movieTitle, int page) async {
    try {
      final newMovies =
          await _moviesRepository.getMoviesByTitle(movieTitle, page: page);
      final isLastPage = newMovies.length < 20;
      if (isLastPage) {
        pagingController.appendLastPage(newMovies);
      } else {
        final nextPageKey = page + 1;
        pagingController.appendPage(newMovies, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }
}
