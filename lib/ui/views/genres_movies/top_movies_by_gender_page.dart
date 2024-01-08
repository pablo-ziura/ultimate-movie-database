import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ultimate_movie_database/data/remote/network_constants.dart';
import 'package:ultimate_movie_database/di/app_modules.dart';
import 'package:ultimate_movie_database/model/genre.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';
import 'package:ultimate_movie_database/ui/navigation/navigation_routes.dart';
import 'package:ultimate_movie_database/ui/views/genres_movies/viewmodel/top_movies_view_model.dart';
import 'package:ultimate_movie_database/ui/widgets/error/error_view.dart';
import 'package:ultimate_movie_database/ui/widgets/loading/loading_view.dart';

class TopMoviesByGenderPage extends StatefulWidget {
  const TopMoviesByGenderPage({Key? key, required this.genre})
      : super(key: key);
  final Genre genre;

  @override
  State<TopMoviesByGenderPage> createState() => _TopMoviesByGenderPageState();
}

class _TopMoviesByGenderPageState extends State<TopMoviesByGenderPage> {
  final TopMoviesViewModel _viewModel = inject<TopMoviesViewModel>();

  _TopMoviesByGenderPageState();

  @override
  void initState() {
    super.initState();
    _viewModel.getMoviesByTitleState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          if (_viewModel.pagingController.nextPageKey == 1) {
            LoadingView.show(context);
          }
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _viewModel
                .fetchTopMovies(_viewModel.pagingController.nextPageKey ?? 1);
          });
          break;
      }
    });

    _viewModel.pagingController.addPageRequestListener((pageKey) {
      _viewModel.fetchTopMovies(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 25),
          Text(
            widget.genre.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Colors.white.withOpacity(0.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: PagedListView<int, Movie>(
              pagingController: _viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Movie>(
                itemBuilder: (context, movie, index) {
                  if (movie.genreIds.contains(widget.genre.id)) {
                    return _buildMovieListItem(movie);
                  } else {
                    return Container();
                  }
                },
                noItemsFoundIndicatorBuilder: (context) => Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieListItem(Movie movie) {
    Widget imageWidget;
    if (movie.backdropPath != null && movie.backdropPath!.isNotEmpty) {
      imageWidget = Image.network(
        NetworkConstants.BASE_URL_IMAGE + movie.backdropPath!,
        fit: BoxFit.cover,
        height: 150,
        width: 100,
      );
    } else {
      imageWidget = Image.asset(
        'assets/img/image_not_available.png',
        fit: BoxFit.cover,
        height: 150,
        width: 100,
      );
    }

    return InkWell(
      onTap: () {
        context.go(NavigationRoutes.SEARCH_PAGE_MOVIE_DETAIL_ROUTE,
            extra: movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Text(
            movie.title,
            style: const TextStyle(color: Colors.white),
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: imageWidget,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
