// ignore_for_file: constant_identifier_names

import 'package:go_router/go_router.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/views/favorite_movies/favorite_movies.dart';
import 'package:ultimate_movie_database/ui/views/genres_movies/top_rated_movies_movies_page.dart';
import 'package:ultimate_movie_database/ui/views/home_page/home_page.dart';
import 'package:ultimate_movie_database/ui/views/search_page/search_page.dart';
import 'package:ultimate_movie_database/ui/views/trending_movies/trending_movies_page.dart';
import 'package:ultimate_movie_database/ui/widgets/movie_detail/movie_detail_page.dart';

class NavigationRoutes {
  // Routes

  static const String INITIAL_ROUTE = "/";
  static const String TRENDING_MOVIES_ROUTE = "/trending-movies";
  static const String SEARCH_PAGE_ROUTE = "/search-movies";
  static const String FAVORITE_MOVIES_ROUTE = "/fav-movies";
  static const String MOVIES_BY_GENRE_ROUTE = "/movies-by-genre";

  static const String TRENDING_MOVIE_DETAIL_ROUTE =
      "$TRENDING_MOVIES_ROUTE/$_MOVIE_DETAIL_PATH";

  static const String SEARCH_PAGE_MOVIE_DETAIL_ROUTE =
      "$SEARCH_PAGE_ROUTE/$_MOVIE_DETAIL_PATH";

  static const String TOP_MOVIES_BY_GENDER_MOVIE_DETAIL_ROUTE =
      "$MOVIES_BY_GENRE_ROUTE/$_MOVIE_DETAIL_PATH";

  //Paths

  static const _MOVIE_DETAIL_PATH = "movie_detail";
}

final GoRouter router = GoRouter(
  initialLocation: NavigationRoutes.TRENDING_MOVIES_ROUTE,
  routes: [
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => HomePage(
              navigationShell: navigationShell,
            ),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: NavigationRoutes.TRENDING_MOVIES_ROUTE,
              builder: (context, state) => const TrendingMoviesPage(),
              routes: [
                GoRoute(
                  path: NavigationRoutes._MOVIE_DETAIL_PATH,
                  builder: (context, state) =>
                      MovieDetailPage(movie: state.extra as Movie),
                )
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: NavigationRoutes.SEARCH_PAGE_ROUTE,
              builder: (context, state) => const SearchPage(),
              routes: [
                GoRoute(
                  path: NavigationRoutes._MOVIE_DETAIL_PATH,
                  builder: (context, state) =>
                      MovieDetailPage(movie: state.extra as Movie),
                )
              ],
            )
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: NavigationRoutes.MOVIES_BY_GENRE_ROUTE,
              builder: (context, state) => const TopRatedMoviesPage(),
              routes: [
                GoRoute(
                  path: NavigationRoutes._MOVIE_DETAIL_PATH,
                  builder: (context, state) =>
                      MovieDetailPage(movie: state.extra as Movie),
                )
              ],
            )
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: NavigationRoutes.FAVORITE_MOVIES_ROUTE,
              builder: (context, state) => const FavoriteMovies(),
            )
          ])
        ])
  ],
);
