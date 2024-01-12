import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_movie_database/ui/navigation/navigation_routes.dart';
import 'package:ultimate_movie_database/ui/provider/favorite_list_provider.dart';
import 'package:ultimate_movie_database/ui/widgets/movie_list_item/movie_list_item.dart';

class FavoriteMovies extends StatefulWidget {
  const FavoriteMovies({super.key});

  @override
  State<FavoriteMovies> createState() => _FavoriteMoviesState();
}

class _FavoriteMoviesState extends State<FavoriteMovies> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<FavoriteListProvider>(context, listen: false)
          .fetchMoviesFromWatchList();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteListProvider>(context);

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
              "MOVIES I WANT TO WATCH",
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
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: provider.movies.length,
                    itemBuilder: (context, index) {
                      final movie = provider.movies[index];
                      return Dismissible(
                        key: Key(movie.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          provider.removeFromWatchList(movie);
                        },
                        child: MovieListItem(
                          movie: movie,
                          navigationRoute: NavigationRoutes
                              .FAVORITE_MOVIES_MOVIE_DETAIL_ROUTE,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
