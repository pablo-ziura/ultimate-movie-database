import 'package:flutter/material.dart';
import 'package:ultimate_movie_database/di/app_modules.dart';
import 'package:ultimate_movie_database/model/genre.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';
import 'package:ultimate_movie_database/ui/views/search_page/viewmodel/genres_view_model.dart';
import 'package:ultimate_movie_database/ui/widget/error/error_view.dart';
import 'package:ultimate_movie_database/ui/widget/loading/loading_view.dart';

class MoviesByGenre extends StatefulWidget {
  const MoviesByGenre({super.key});

  @override
  State<MoviesByGenre> createState() => _MoviesByGenreState();
}

class _MoviesByGenreState extends State<MoviesByGenre> {
  final GenresViewModel _genresViewModel = inject<GenresViewModel>();
  List<Genre> _genres = [];

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "TOP MOVIES BY GENRE",
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
          ),
          GridView.builder(
            padding: const EdgeInsets.only(top: 140, left: 5, right: 5),
            itemCount: _genres.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (_, index) {
              final genre = _genres[index];
              return Card(
                child: InkWell(
                  onTap: () {},
                  child: Center(
                    child: Text(
                      genre.name,
                      style: const TextStyle(color: Colors.amber),
                    ),
                  ),
                ),
              );
            },
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
