import 'package:flutter/material.dart';
import 'package:ultimate_movie_database/di/app_modules.dart';
import 'package:ultimate_movie_database/model/genre.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';
import 'package:ultimate_movie_database/ui/views/search_page/viewmodel/genres_view_model.dart';
import 'package:ultimate_movie_database/ui/widget/error/error_view.dart';
import 'package:ultimate_movie_database/ui/widget/loading/loading_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GenresViewModel _genresViewModel = inject<GenresViewModel>();
  final TextEditingController _movieTitleController = TextEditingController();
  String _selectedGenre = '';
  List<Genre> _genres = [];

  void _searchMovie() {
    final String title = _movieTitleController.text;
    final String genre = _selectedGenre;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Título: $title, Género: $genre'),
      ),
    );
  }

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
            if (_genres.isNotEmpty) {
              _selectedGenre = _genres.first.name;
            }
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
      body: Stack(children: [
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          right: 0,
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
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
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 200,
          left: 20,
          right: 20,
          child: Column(
            children: [
              TextField(
                controller: _movieTitleController,
                decoration: const InputDecoration(
                  hintText: 'Movie Title',
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              DropdownButton<String>(
                value: _selectedGenre,
                onChanged: (newValue) {
                  setState(() {
                    _selectedGenre = newValue!;
                  });
                },
                dropdownColor: Colors.black,
                items: _genres.map<DropdownMenuItem<String>>((Genre genre) {
                  return DropdownMenuItem<String>(
                    value: genre.name,
                    child: Text(
                      genre.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _searchMovie,
                child: const Text('SEARCH'),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _genresViewModel.dispose();
    _movieTitleController.dispose();
    super.dispose();
  }
}
