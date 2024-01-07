import 'dart:async';

import 'package:ultimate_movie_database/domain/genres_repository.dart';
import 'package:ultimate_movie_database/model/genre.dart';
import 'package:ultimate_movie_database/ui/base/base_view_model.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';

class GenresViewModel extends BaseViewModel {
  final GenresRepository _genresRepository;

  final StreamController<ResourceState<List<Genre>>> getGenresState =
      StreamController();

  GenresViewModel({required GenresRepository genresRepository})
      : _genresRepository = genresRepository;

  @override
  void dispose() {
    getGenresState.close();
  }

  fetchMovieGenres() {
    getGenresState.add(ResourceState.loading());
    _genresRepository
        .getGenres()
        .then((value) => getGenresState.add(ResourceState.success(value)))
        .catchError((error) => getGenresState.add(ResourceState.error(error)));
  }
}
