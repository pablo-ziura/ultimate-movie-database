import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ultimate_movie_database/di/app_modules.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';
import 'package:ultimate_movie_database/ui/navigation/navigation_routes.dart';
import 'package:ultimate_movie_database/ui/views/search_page/viewmodel/search_page_view_model.dart';
import 'package:ultimate_movie_database/ui/widgets/error/error_view.dart';
import 'package:ultimate_movie_database/ui/widgets/loading/loading_view.dart';
import 'package:ultimate_movie_database/ui/widgets/movie_list_item/movie_list_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _movieTitleController = TextEditingController();
  final SearchMovieViewModel _viewModel = inject<SearchMovieViewModel>();

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
            _viewModel.fetchMoviesByTitle(_movieTitleController.text,
                _viewModel.pagingController.nextPageKey ?? 1);
          });
          break;
      }
    });

    _viewModel.pagingController.addPageRequestListener((pageKey) {
      _viewModel.fetchMoviesByTitle(_movieTitleController.text, pageKey);
    });
  }

  void _searchMovie() {
    final String title = _movieTitleController.text;
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The search query can not be empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    _viewModel.pagingController.refresh();
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
              "SEARCH FOR YOUR MOVIE",
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
          Container(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 50, vertical: 15),
            child: TextField(
              controller: _movieTitleController,
              decoration: const InputDecoration(
                hintText: 'Movie Title',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _searchMovie,
            child: const Text('SEARCH'),
          ),
          Expanded(
            child: PagedListView<int, Movie>(
              pagingController: _viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Movie>(
                itemBuilder: (context, movie, index) {
                  return MovieListItem(
                    movie: movie,
                    navigationRoute:
                        NavigationRoutes.SEARCH_PAGE_MOVIE_DETAIL_ROUTE,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _movieTitleController.dispose();
    _viewModel.dispose();
    super.dispose();
  }
}
