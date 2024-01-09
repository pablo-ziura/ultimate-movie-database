import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ultimate_movie_database/data/remote/network_constants.dart';
import 'package:ultimate_movie_database/model/movie.dart';

class MovieListItem extends StatelessWidget {
  final Movie movie;
  final String navigationRoute;

  const MovieListItem(
      {Key? key, required this.movie, required this.navigationRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        context.go(navigationRoute, extra: movie);
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
}
