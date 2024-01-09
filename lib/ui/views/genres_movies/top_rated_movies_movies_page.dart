import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ultimate_movie_database/di/app_modules.dart';
import 'package:ultimate_movie_database/model/genre.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';
import 'package:ultimate_movie_database/ui/navigation/navigation_routes.dart';
import 'package:ultimate_movie_database/ui/views/genres_movies/viewmodel/genres_view_model.dart';
import 'package:ultimate_movie_database/ui/views/genres_movies/viewmodel/top_rated_movies_view_model.dart';
import 'package:ultimate_movie_database/ui/widgets/error/error_view.dart';
import 'package:ultimate_movie_database/ui/widgets/loading/loading_view.dart';
import 'package:ultimate_movie_database/ui/widgets/movie_list_item/movie_list_item.dart';

class TopRatedMoviesPage extends StatefulWidget {
  const TopRatedMoviesPage({Key? key}) : super(key: key);

  @override
  TopRatedMoviesPageState createState() => TopRatedMoviesPageState();
}

class TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  final GenresViewModel _genresViewModel = inject<GenresViewModel>();
  final TopRatedMoviesViewModel _moviesViewModel =
      inject<TopRatedMoviesViewModel>();

  List<Genre> _genres = [];
  String? _selectedGenreId;

  @override
  void initState() {
    super.initState();
    _selectedGenreId = null;
    _genresViewModel.getGenresState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _genres = state.data!;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _genresViewModel.fetchMovieGenres();
          });
          break;
      }
    });
    _genresViewModel.fetchMovieGenres();

    _moviesViewModel.getMoviesByTitleState.stream.listen(
      (state) {
        switch (state.status) {
          case Status.LOADING:
            if (_moviesViewModel.pagingController.nextPageKey == 1) {
              LoadingView.show(context);
            }
            break;
          case Status.SUCCESS:
            LoadingView.hide();
            break;
          case Status.ERROR:
            LoadingView.hide();
            ErrorView.show(context, state.exception!.toString(), () {
              _moviesViewModel.fetchTopMovies(
                  _moviesViewModel.pagingController.nextPageKey ?? 1);
            });
            break;
        }
      },
    );

    _moviesViewModel.pagingController.addPageRequestListener((pageKey) {
      _moviesViewModel.fetchTopMovies(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 10.0,
                right: 10.0),
            child: const Text(
              "TOP RATED MOVIES",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent,
                shadows: [
                  Shadow(
                    offset: Offset(0, 0),
                    blurRadius: 10.0,
                    color: Colors.amberAccent,
                  ),
                  Shadow(
                    offset: Offset(0, 0),
                    blurRadius: 10.0,
                    color: Colors.amberAccent,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 25),
          DropdownButton<String>(
            value: _selectedGenreId,
            hint: const Text("Select Genre",
                style: TextStyle(color: Colors.white)),
            onChanged: (String? newValue) {
              setState(() {
                _selectedGenreId = newValue;
              });
            },
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All', style: TextStyle(color: Colors.amberAccent)),
              ),
              ..._genres.map<DropdownMenuItem<String>>((Genre genre) {
                return DropdownMenuItem<String>(
                  value: genre.id.toString(),
                  child: Text(genre.name,
                      style: const TextStyle(color: Colors.amberAccent)),
                );
              }).toList(),
            ],
          ),
          Expanded(
            child: PagedListView<int, Movie>(
              pagingController: _moviesViewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Movie>(
                itemBuilder: (context, movie, index) {
                  if (_selectedGenreId == null ||
                      movie.genreIds.contains(int.parse(_selectedGenreId!))) {
                    return MovieListItem(
                      movie: movie,
                      navigationRoute: NavigationRoutes
                          .TOP_MOVIES_BY_GENDER_MOVIE_DETAIL_ROUTE,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
                noItemsFoundIndicatorBuilder: (context) =>
                    const Text("No movies found"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _genresViewModel.dispose();
    super.dispose();
  }
}
