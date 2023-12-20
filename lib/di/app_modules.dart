import 'package:get_it/get_it.dart';
import 'package:ultimate_movie_database/data/movie/movies_data_impl.dart';
import 'package:ultimate_movie_database/data/movie/remote/movies_remote_impl.dart';
import 'package:ultimate_movie_database/data/remote/network_client.dart';
import 'package:ultimate_movie_database/domain/movies_repository.dart';
import 'package:ultimate_movie_database/ui/views/trending_movies/viewmodel/movies_view_model.dart';

final inject = GetIt.instance;

class AppModules {
  setup() {
    _setupMainModule();
    _setupMoviesModule();
  }

  _setupMainModule() {
    inject.registerSingleton(NetworkClient());
  }

  _setupMoviesModule() {
    inject.registerFactory(() => MoviesRemoteImpl(networkClient: inject.get()));
    inject.registerFactory<MoviesRepository>(
        () => MoviesDataImpl(remoteImpl: inject.get()));
    inject
        .registerFactory(() => MoviesViewModel(moviesRepository: inject.get()));
  }
}
