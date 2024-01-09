import 'package:get_it/get_it.dart';
import 'package:ultimate_movie_database/data/genre/genres_data_impl.dart';
import 'package:ultimate_movie_database/data/genre/remote/genres_remote_impl.dart';
import 'package:ultimate_movie_database/data/movie/movies_data_impl.dart';
import 'package:ultimate_movie_database/data/movie/remote/movies_remote_impl.dart';
import 'package:ultimate_movie_database/data/remote/network_client.dart';
import 'package:ultimate_movie_database/domain/genres_repository.dart';
import 'package:ultimate_movie_database/domain/movies_repository.dart';
import 'package:ultimate_movie_database/ui/views/genres_movies/viewmodel/genres_view_model.dart';
import 'package:ultimate_movie_database/ui/views/genres_movies/viewmodel/top_rated_movies_view_model.dart';
import 'package:ultimate_movie_database/ui/views/search_page/viewmodel/search_page_view_model.dart';
import 'package:ultimate_movie_database/ui/views/trending_movies/viewmodel/trending_movies_view_model.dart';

final inject = GetIt.instance;

class AppModules {
  setup() {
    _setupMainModule();
    _setupMoviesModule();
    _setupGenresModule();
  }

  _setupMainModule() {
    inject.registerSingleton(NetworkClient());
  }

  _setupMoviesModule() {
    inject.registerFactory(() => MoviesRemoteImpl(networkClient: inject.get()));
    inject.registerFactory<MoviesRepository>(
        () => MoviesDataImpl(remoteImpl: inject.get()));
    inject.registerFactory(
        () => TrendingMoviesViewModel(moviesRepository: inject.get()));
    inject.registerFactory(
        () => SearchMovieViewModel(moviesRepository: inject.get()));
    inject.registerFactory(
        () => TopRatedMoviesViewModel(moviesRepository: inject.get()));
  }

  _setupGenresModule() {
    inject.registerFactory(() => GenresRemoteImpl(networkClient: inject.get()));
    inject.registerFactory<GenresRepository>(
        () => GenresDataImpl(remoteImpl: inject.get()));
    inject
        .registerFactory(() => GenresViewModel(genresRepository: inject.get()));
  }
}
