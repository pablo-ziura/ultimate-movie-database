// ignore_for_file: constant_identifier_names

import 'package:go_router/go_router.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/views/trending_movies/movie_detail_page.dart';
import 'package:ultimate_movie_database/ui/views/trending_movies/trending_movies_page.dart';

class NavigationRoutes {
  static const String INITIAL_ROUTE = "/";
  static const String TRENDING_MOVIES_ROUTE = "/joke-categories";
  static const String MOVIE_DETAIL_ROUTE =
      "$TRENDING_MOVIES_ROUTE/$_MOVIE_DETAIL_PATH";

  static const String _MOVIE_DETAIL_PATH = "movie-detail";
}

final GoRouter router = GoRouter(
  initialLocation: NavigationRoutes.INITIAL_ROUTE,
  routes: [
    GoRoute(
      path: NavigationRoutes.INITIAL_ROUTE,
      builder: (context, state) => const TrendingMoviesPage(),
    ),
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
    )
  ],
);
