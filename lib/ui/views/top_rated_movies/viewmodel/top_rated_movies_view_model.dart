import 'dart:async';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ultimate_movie_database/domain/genres_repository.dart';
import 'package:ultimate_movie_database/domain/movies_repository.dart';
import 'package:ultimate_movie_database/model/genre.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/base/base_view_model.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';

class TopRatedMoviesViewModel extends BaseViewModel {
  final MoviesRepository _moviesRepository;
  final GenresRepository _genresRepository;

  final PagingController<int, Movie> pagingController =
      PagingController(firstPageKey: 1);

  final StreamController<ResourceState<List<Movie>>> getMoviesByTitleState =
      StreamController();

  final StreamController<ResourceState<List<Genre>>> getGenresState =
      StreamController();

  List<Movie> movies = [];

  TopRatedMoviesViewModel(
      {required MoviesRepository moviesRepository,
      required GenresRepository genresRepository})
      : _moviesRepository = moviesRepository,
        _genresRepository = genresRepository;

  @override
  void dispose() {
    pagingController.dispose();
    getMoviesByTitleState.close();
    getGenresState.close();
  }

  fetchTopMovies(int page) async {
    try {
      final newMovies = await _moviesRepository.getTopMovies(page: page);
      final isLastPage = newMovies.length < 20;

      movies.addAll(newMovies);

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

  void filterMoviesByGenre(int genreId) {
    var filteredMovies =
        movies.where((movie) => movie.genreIds.contains(genreId)).toList();
    pagingController.itemList = filteredMovies;
  }

  fetchMovieGenres() {
    getGenresState.add(ResourceState.loading());
    _genresRepository
        .getGenres()
        .then((value) => getGenresState.add(ResourceState.success(value)))
        .catchError((error) => getGenresState.add(ResourceState.error(error)));
  }
}
